---
layout: post
title: git commit --verbose
description: Viewing your diff while writing your commits.
categories: finding
tags: git commit shell
---
Note that this article can be summed up by viewing the asciicast:

[![asciicast](https://asciinema.org/a/f0wcjzdp608d1k25ps2nqd4mb.png)](https://asciinema.org/a/f0wcjzdp608d1k25ps2nqd4mb)

<div class="divider"></div>

My common workflow for writing commit messages, used to be something like:

```bash
$ vim $file
$ git add -p
$ git diff --cached
$ git commit
```

Alternatively, when using [vim-fugitive][vim-fugitive], while writing a commit, I would run `:Gdiff`, which would open up the diff in a split.

However, as an even better way of doing this, we can take advantage of Git's `git commit --verbose` mode, which prepopulates a commit message with the full diff, i.e.

```diff

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch master
# Your branch is up-to-date with 'origin/master'.
#
# Changes to be committed:
#	new file:   _drafts/git-commit-verbose.md
#
# ------------------------ >8 ------------------------
# Do not touch the line above.
# Everything below will be removed.
diff --git a/_drafts/git-commit-verbose.md b/_drafts/git-commit-verbose.md
new file mode 100644
index 0000000..03deabc
--- /dev/null
+++ b/_drafts/git-commit-verbose.md
@@ -0,0 +1,22 @@
+---
+layout: post
+title: `git commit --verbose`
+description: Viewing your diff while writing your commits.
+categories: finding
+tags: git commit shell
+---
+My common workflow for writing about a commit is either to do something like:
+
+```bash
+$ vim $file
+$ git add -p
+$ git diff --cached
+$ git commit
+```
+
+Alternatively, when using [vim-fugitive][vim-fugitive], while writing a commit, I can run `:Gdiff`.
+
+However, as an even better way of doing this, we can take advantage of Git's `git commit --verbose` mode, which prepopulates a commit message with the full diff, i.e.
+
+
+[vim-fugitive]: https://github.com/tpope/vim-fugitive
```

This gives you the ease of being able to see the diff as you're writing your commit, meaning that it's much more efficient, and isn't as much swapping between commit message and diff.

This is especially useful because I spend a lot of time crafting the actual commits themselves, ensuring that the commit message follows [commit guidelines][git-commit], and that I can easily swap between the code and the commit message.

[vim-fugitive]: https://github.com/tpope/vim-fugitive
[git-commit]: https://chris.beams.io/posts/git-commit/
