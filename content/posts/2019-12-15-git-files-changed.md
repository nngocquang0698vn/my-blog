---
title: "List What Files Changed in a Git Commit"
description: "How to list what files changed in a given commit."
tags:
- blogumentation
- git
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-15T22:28:28+0000
slug: "git-files-changed"
image: /img/vendor/git.png
---
I've found in the past that it can be useful to know what files have changed in a given commit, i.e. to re-edit them, or to [add whitespace to the end of file]({{< ref "2019-09-02-newlines-all-git-files" >}}).

We can do this with the `diff-tree` subcommand, giving it a commit to look at, and it'll return a list of all files changed:

```sh
$ git diff-tree --no-commit-id --name-only -r HEAD
$ git diff-tree --no-commit-id --name-only -r e08f540464a6adbddda7de71b85fc793ddfac2a8
content/mf2/2019/12/ewhan.md
```

Taken from [_How to list all the files in a commit?_ on Stack Overflow](https://stackoverflow.com/a/424142).
