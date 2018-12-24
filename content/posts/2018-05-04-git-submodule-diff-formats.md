---
title: Better Git Diff Outputs with Git Submodules
description: How to get nicer `diff`s when working with submodules.
categories:
- blogumentation
tags:
- blogumentation
- git
- cli
image: /img/vendor/git.png
date: 2018-05-04
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
---
I've recently been playing around with [Git Submodules] a little bit more, and have been frustrated by the output of `git diff`s:

```diff
diff --git a/vendor/git/startbootstrap-clean-blog b/vendor/git/startbootstrap-clean-blog
index eda0a67..5daffc9 160000
--- a/vendor/git/startbootstrap-clean-blog
+++ b/vendor/git/startbootstrap-clean-blog
@@ -1 +1 @@
-Subproject commit eda0a676f655da9e909464eec6a028757b880bf0
+Subproject commit 5daffc976c4a8769129f98733c961a0df90d0246
```

When trying to write commit messages, via [_Viewing your diff while writing your commits with `git commit --verbose`_][git-commit-verbose], I've found that there's nothing really useful in the diff that I can describe as I'm writing the commit. To gain some understanding of what's happened in the submodule, I run:

```
$ git log --oneline eda0a676f655da9e909464eec6a028757b880bf0...5daffc976c4a8769129f98733c961a0df90d0246
5daffc9 Centre-align site subtitle
e51780f Make site subtitle bold
```

This would then be added to a commit message such as:

```
Theme: Subtitle changes

5daffc9 Centre-align site subtitle
e51780f Make site subtitle bold
```

However, after getting annoyed by this I've now discovered some other options, thanks to [Stack Overflow][so-submodule-diff], which can make it much easier to view changes with.

# `diff` Format

Perhaps the most useful of the options is an actual diff of changes within the submodule:

```diff
Submodule vendor/git/startbootstrap-clean-blog eda0a67..5daffc9:
diff --git a/vendor/git/startbootstrap-clean-blog/assets/vendor/startbootstrap-clean-blog/scss/_masthead.scss b/vendor/git/startbootstrap-clean-blog/assets/vendor/startbootstrap-clean-blog/scss/_masthead.scss
index f564652..fceee82 100644
--- a/vendor/git/startbootstrap-clean-blog/assets/vendor/startbootstrap-clean-blog/scss/_masthead.scss
+++ b/vendor/git/startbootstrap-clean-blog/assets/vendor/startbootstrap-clean-blog/scss/_masthead.scss
@@ -37,8 +37,9 @@ header.masthead {
       margin-top: 0;
     }
     .subheading {
+      text-align: center;
       font-size: 24px;
-      font-weight: 300;
+      font-weight: bold;
       line-height: 1.1;
       display: block;
       margin: 10px 0 0;
```

You can set this as your default by running:

```bash
# either
$ git config --global diff.submodule diff
# or
$ git config --global -e
```

And adding:

```ini
[diff]
  submodule=diff
```

# `short` Format

`short` simply shows the commit at the beginning and the end of a stage, such as:

```diff
diff --git a/vendor/git/startbootstrap-clean-blog b/vendor/git/startbootstrap-clean-blog
index eda0a67..5daffc9 160000
--- a/vendor/git/startbootstrap-clean-blog
+++ b/vendor/git/startbootstrap-clean-blog
@@ -1 +1 @@
-Subproject commit eda0a676f655da9e909464eec6a028757b880bf0
+Subproject commit 5daffc976c4a8769129f98733c961a0df90d0246
```

This is Git's default, but to always have this setting, you can run:

```bash
# either
$ git config --global diff.submodule short
# or
$ git config --global -e
```

And adding:

```ini
[diff]
  submodule=short
```

# `log` Format

Alternatively, you can get a log format, which is nice for putting in a CHANGELOG/commit message:

```
Submodule vendor/git/startbootstrap-clean-blog eda0a67..5daffc9:
  > Centre-align site subtitle
  > Make site subtitle bold
```

You can set this as your default by running:

```bash
# either
$ git config --global diff.submodule log
# or
$ git config --global -e
```

And adding:

```ini
[diff]
  submodule=log
```

[Git Submodules]: https://git-scm.com/book/en/v2/Git-Tools-Submodules

[git-commit-verbose]: {{< ref 2017-06-01-git-commit-verbose >}}
[so-submodule-diff]: https://stackoverflow.com/questions/10757091/git-list-of-all-changed-files-including-those-in-submodules

