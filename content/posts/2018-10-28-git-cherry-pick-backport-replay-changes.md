---
title: "Backporting/Replaying Changes Using `git cherry-pick`"
description: "Using `git cherry-pick` to make it easier to backport or replay Git commits across different versions of your codebase."
tags:
- blogumentation
- git
- git-cherry-pick
image: /img/vendor/git.png
date: 2018-10-28T22:22:50+00:00
license_prose: CC-BY-NC-SA-4.0
license_code: MIT
slug: git-cherry-pick-backport-replay-changes
---
If you've ever supporting multiple versions of the same piece of software, you may need to apply fixes to each of the versions you're supporting. This could be backporting a fix that has been contributed to a newer version of the software, or vice versa.

As these changes may not be small, either, this can be quite a pain to re-implement and ensure that each version has the patch ported correctly. Instead of manually reimplementing the patch, we can instead use `git cherry-pick`. This means that we won't lose necessary Git history, which is very important to preserve as the commit messages can help you track down reasoning for why changes were made, as well as potential issue tracking numbers for further details.

Note that this is made easier where commits are atomic, but can still be used in places where the changes are not atomic.

For example, let us pretend that we're the maintainers of [Jekyll](https://github.com/jekyll/jekyll). As maintainers, we are responsible for the `master` branch where upcoming releases are developed, but we're also supporting previous versions with bugfixes. In this example of Jekyll there are two main branches we care about:

- master
- 3.8-stable

Let us assume that we've recently had some code contributions to the `3.8-stable` branch, but we've realised that our automated build pipeline using Travis CI is broken as it's testing versions of Ruby we no longer need to support. Our Git log for `.travis-ci.yml` on the `3.8-stable` branch currently looks like:


```
* f119d2c9 (7 months)  <Frank Taillandier> Fix build on Travis
* e0f50011 (7 months)  <Frank Taillandier> bump rubies
* 8b61d7a3 (7 months)  <Kacper Duras>      Bump JRuby (#6878)
* c96289f4 (10 months) <jekyllbot>         CI: Test against Ruby 2.5.0 (#6664)
* dd5685bb (12 months) <ashmaroli>         Bump JRuby version in Travis config (#6561)
```

But when we have a look at our `master` branch, we notice that we've got a number of newer commits that would fix our issues:

```
* a0dc346e (6 weeks)   <Frank Taillandier>  Unlock bundler
* ef41eeb7 (3 months)  <Pat Hawks>          Name some of our Travis builds
* e61cc513 (3 months)  <Ashwin Maroli>      Lock Travis to Bundler-1.16.2 (#7144)
* f8dfbd2f (6 months)  <Ashwin Maroli>      Drop support for older versions of Rouge (#6978)
* c2851766 (6 months)  <Ashwin Maroli>      Drop support for Ruby 2.1 and 2.2 (#6560)
* f119d2c9 (7 months)  <Frank Taillandier>  Fix build on Travis
* e0f50011 (7 months)  <Frank Taillandier>  bump rubies
* 8b61d7a3 (7 months)  <Kacper Duras>       Bump JRuby (#6878)
* c96289f4 (10 months) <jekyllbot>          CI: Test against Ruby 2.5.0 (#6664)
* dd5685bb (12 months) <ashmaroli>          Bump JRuby version in Travis config (#6561)
```

We now have two options:

- Reimplement the commits by copy-pasting file content, resulting in a new Git commit. However, this would lose the Git history, the context for the commits, and i.e. who contributed them
- Use `git cherry-pick` to replay the commits, retaining the full Git history

From the article title, I think you can tell which option we're going for!

We want to make sure we have each of these commits _in the order they were committed to the `master` branch_, so we'll need to `git cherry-pick` them in chronological, which is the reverse order to that of our Git log. This makes most sense when looking through the logs due to the timestamping, but it doesn't necessarily always need to be in this order.

```
$ git branch
* 3.8-stable
  master
$ git cherry-pick c2851766
[3.8-stable 83ccfe19] Drop support for Ruby 2.1 and 2.2 (#6560)
 Author: Ashwin Maroli <ashmaroli@users.noreply.github.com>
 Date: Mon Apr 30 21:14:48 2018 +0530
 5 files changed, 15 insertions(+), 12 deletions(-)
```

Now, we can see something interesting here. Even though we've `cherry-pick`'d commit `c2851766`, Git has mentioned that on this branch it's now `83ccfe19`. This is due to the way that Git hashes are cryptographically generated based on the existing branch and the contents of the changes. The commit on the `master` branch is re-applied to the `.travis-ci.yml` file, and then the Git hash is regenerated.

We can then repeat the same for each of the other commits.

```
$ git cherry-pick f8dfbd2f
[3.8-stable a1a77fcf] Drop support for older versions of Rouge (#6978)
 Author: Ashwin Maroli <ashmaroli@users.noreply.github.com>
 Date: Thu May 3 19:33:55 2018 +0530
 9 files changed, 10 insertions(+), 73 deletions(-)
 delete mode 100644 lib/jekyll/utils/rouge.rb
$ git cherry-pick e61cc513
[3.8-stable 04900f46] Lock Travis to Bundler-1.16.2 (#7144)
 Author: Ashwin Maroli <ashmaroli@users.noreply.github.com>
 Date: Tue Jul 17 20:12:10 2018 +0530
 1 file changed, 1 insertion(+), 1 deletion(-)
$ git cherry-pick ef41eeb7
[3.8-stable 6dba6771] Name some of our Travis builds
 Author: Pat Hawks <pat@pathawks.com>
 Date: Mon Jul 23 12:57:56 2018 -0500
 1 file changed, 2 insertions(+)
$ git cherry-pick a0dc346e
[3.8-stable c49b6094] Unlock bundler
 Author: Frank Taillandier <frank.taillandier@gmail.com>
 Date: Wed Sep 19 02:35:41 2018 -0700
 1 file changed, 1 insertion(+), 1 deletion(-)
```

Now we've picked the commits we want, we can see that now our `.travis-ci.yml` file has all the changes that we wanted from the `master` branch.

```
* a0dc346e (6 weeks)   <Frank Taillandier>  Unlock bundler
* ef41eeb7 (3 months)  <Pat Hawks>          Name some of our Travis builds
* e61cc513 (3 months)  <Ashwin Maroli>      Lock Travis to Bundler-1.16.2 (#7144)
* f8dfbd2f (6 months)  <Ashwin Maroli>      Drop support for older versions of Rouge (#6978)
* c2851766 (6 months)  <Ashwin Maroli>      Drop support for Ruby 2.1 and 2.2 (#6560)
* f119d2c9 (7 months)  <Frank Taillandier>  Fix build on Travis
* e0f50011 (7 months)  <Frank Taillandier>  bump rubies
* 8b61d7a3 (7 months)  <Kacper Duras>       Bump JRuby (#6878)
* c96289f4 (10 months) <jekyllbot>          CI: Test against Ruby 2.5.0 (#6664)
* dd5685bb (12 months) <ashmaroli>          Bump JRuby version in Travis config (#6561)
```

# Finding Who `git cherry-pick`'d

It can sometimes be useful tracking down who actually `cherry-pick`'d a commit. However, that information is hidden from you when you perform a regular `git show`, which simply displays the original commit:

```
commit c49b60949988ab92fd1c54441f09c000ea2e32bb
Author: Frank Taillandier <frank.taillandier@gmail.com>
Date:   Wed Sep 19 02:35:41 2018 -0700

    Unlock bundler

    https://github.com/bundler/bundler/issues/6629 has been fixed

diff --git a/.travis.yml b/.travis.yml
index d1c4f739..44e29968 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -54,4 +54,4 @@ after_success:

 before_install:
   - gem update --system
-  - gem install bundler --version 1.16.2
+  - gem install bundler
```

If you want the full details, you need to i.e. run `git show --format=fuller`:

```
commit c49b60949988ab92fd1c54441f09c000ea2e32bb
Author:     Frank Taillandier <frank.taillandier@gmail.com>
AuthorDate: Wed Sep 19 02:35:41 2018 -0700
Commit:     Jamie Tanna <jamie@jamietanna.co.uk>
CommitDate: Sun Oct 28 21:56:36 2018 +0000

    Unlock bundler

    https://github.com/bundler/bundler/issues/6629 has been fixed

diff --git a/.travis.yml b/.travis.yml
index d1c4f739..44e29968 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -54,4 +54,4 @@ after_success:

 before_install:
   - gem update --system
-  - gem install bundler --version 1.16.2
+  - gem install bundler
```

This shows you that it was original authored in September, but I've just now re-committed it in October.
