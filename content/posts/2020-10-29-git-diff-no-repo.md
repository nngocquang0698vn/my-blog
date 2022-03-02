---
title: "Using Git Diff Without a Repo"
description: "How to use `git diff` when you're not in a Git repo."
tags:
- blogumentation
- git
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-10-29T09:24:38+0000
slug: "git-diff-no-repo"
image: https://media.jvt.me/53239026de.png
---
I really like using `git diff`, as it's got some good defaults, and has some good options on top of it.

But when you're not in a Git repo, you can't use it, right? Not quite.

Fortunately, there's the `--no-index` flag which allows you to diff between files that aren't related to a Git repo:

```sh
# does not work, returns status code 0
git diff README.md ../other-repo/README.md
# works, returns status code 1 and the diff
git diff --no-index README.md ../other-repo/README.md
```
