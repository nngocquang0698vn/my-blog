---
title: Viewing your diff while writing your commits with git commit --verbose
description: Making it easier to write commit messages by having the diff in your editor.
categories:
- blogumentation
tags:
- git
- commit
- shell
- workflow
image: /img/vendor/git.png
date: 2017-06-01
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
---
I am a firm believer of the fact that Git history should be documentation for the reasoning behind _why_ the code is as it is. As such, I take care to make my commits follow [Chris Beams' commit guidelines][git-commit], which usually involves writing the commit while reading the diff of what's changed, so I don't forget anything.

# Manual `git diff`s

My common workflow for writing commit messages used to be along the lines of:

```bash
$ vim $file
$ git add -p
$ git diff --cached
$ git commit
```

This meant I would have fresh in my mind the changes that I had recently made, and therefore would be able to have the message accurately detail the _why_ of the changes I made in a commit.

However, this wasn't great for large diffs, as I'd have to either remember the full diff and all the changes made, or switch between `$EDITOR` and diff.

# Using `vim-fugitive`

Then, I discovered [vim-fugitive][vim-fugitive] which adds easy access to Git-specific information from Vim. This allowed me to run `:Gdiff` while editing a commit, which would open up the diff in a split.

# Using `git commit --verbose`

However, as an even better way of doing this, I found I can take advantage of Git's `commit --verbose` mode, which prepopulates a commit message with the full diff, i.e.

```diff
Commit message goes here

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

Part of #93.

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch master
# Your branch is up-to-date with 'origin/master'.
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
+title: `git commit --verbose`
+description: Viewing your diff while writing your commits.
+categories: blogumentation
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

This means that I don't need any plugins, and can remain in my `$EDITOR`, as well as it being a fully supported configuration by Git, by running `git config --global commit.verbose true`.

# In Summary

To see this article in action, check out the asciicast:

<asciinema-player src="/casts/git-commit-verbose.json"></asciinema-player>

[vim-fugitive]: https://github.com/tpope/vim-fugitive
[git-commit]: https://chris.beams.io/posts/git-commit/
