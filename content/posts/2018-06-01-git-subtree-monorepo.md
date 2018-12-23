---
title: 'Merging multiple repositories into a monorepo, while preserving history, using `git subtree`'
description: 'How to merge multiple repositories, with their history, into a single repository, using the `git subtree add` command'
categories: blogumentation howto
tags: blogumentation git monorepo git-subtree cli
image: /img/vendor/git.png
no_toc: true
---
When I started to give talks, either at [Hacksoc][hacksoc] or Meetups, I wanted a nice way to share both my slides and the sources, so others could see what I did to write them, as well as supporting my passion for Free Software and spreading knowledge.

However this started to get a little unwieldy, and I was finding there was a little overhead creating and maintaining repos, as well as not being able to easily share common files.

This led me to wanting to move to having a single repository for all of my talks, much like how [Luke, a friend of mine had][luke-talks]. This meant I could point anyone to the same repo, and they'd not only find the slides they wanted, but they'd also be able to discover other talks I'd done.

As part of this move, I was very much in favour of being able to preserve the Git history of the separate repos if possible, which would let me track changes back in time. This led me to finding `git subtree`, which is built-in functionality that can do exactly that!

From the [man page][git-subtree]:

```
Subtrees allow subprojects to be included within a subdirectory of the main project, optionally including the subproject’s entire history.

For example, you could include the source code for a library as a subdirectory of your application.
```

## Example

In this example, we've got a new repo, with a single commit:

```
$ git log --oneline
8943210 Initial README
$ ls
README.md
```

And we want to pull the [`gittalk15`](https://github.com/jamietanna/gittalk15) repo and place it into the `git-talk` subdirectory:

```
$ git subtree add --prefix=git-talk https://github.com/jamietanna/gittalk15 master
git fetch https://github.com/jamietanna/gittalk15 master
warning: no common commits
remote: Counting objects: 42, done.
remote: Total 42 (delta 0), reused 0 (delta 0), pack-reused 42
Unpacking objects: 100% (42/42), done.
From ssh://github.com/jamietanna/gittalk15
 * branch            master     -> FETCH_HEAD
Added dir 'git-talk'
```

We can verify that the directory now exists, and that the history has been imported:

```
$ ls
git-talk
README.md
$ ls git-talk
intro-to-git-talk-15
intro-to-git-workshop
README.md
$ git log --oneline
016d39f Add 'git-talk/' from commit '620bb0e91da4268be43f8861a52b396953d0ac90'
8943210 Initial README
620bb0e Added a thanks to @AnnaDodson for helping out!
f86223b Git + Hacktoberfest talk
a2a5b1c Rename intro talk directory
960a7e7 Updated README with a bit more information
78f47ba Initial commit with final source files for Introduction to Git talk.
```

We also get a handy commit to track the import of the subtree, mentioning:

- `git-subtree-dir`: the directory the subtree was imported into
- `git-subtree-mainline`: the commit on the existing branch, in this case `Initial README`
- `git-subtree-split`: the commit that the subtree was on when it was imported

```
$ git show 016d39f
commit 016d39f9f312a401bf0ace153b3a309aecaa3c5d (HEAD -> master)
Merge: 8943210 620bb0e
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Fri Jun 1 20:14:51 2018 +0100

    Add 'git-talk/' from commit '620bb0e91da4268be43f8861a52b396953d0ac90'

    git-subtree-dir: git-talk
    git-subtree-mainline: 89432100d4842616b0c4b3fb187591de73126d22
    git-subtree-split: 620bb0e91da4268be43f8861a52b396953d0ac90
...
```

This is actually a really straightforward way to combine repositories while preserving history.

Watch this space, there will be [another article soon](https://gitlab.com/jamietanna/jvt.me/issues/101) to investigate only pulling in a certain subdirectory.

[git-subtree]: https://github.com/git/git/blob/master/contrib/subtree/git-subtree.txt
[gittalk15]: https://github.com/jamietanna/gittalk15
[hacksoc]: http://hacksocnotts.co.uk/
[luke-talks]: https://github.com/lukeg101/Talks
