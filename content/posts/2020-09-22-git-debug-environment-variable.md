---
title: "Debugging Git Errors Using Environment Variables"
description: "How to use environment variables such as `GIT_TRACE` to debug what's going wrong / what's happening under the hood with `git`."
tags:
- blogumentation
- git
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-09-22T13:48:10+0100
slug: "git-debug-environment-variable"
image: https://media.jvt.me/53239026de.png
---
One of the frustrating things I've found with Git is that it can be difficult to work out why errors have occurred:

```
error: gpg failed to sign the data
fatal: failed to write commit object
```

This is especially frustrating as some commands have a `--verbose` flag, but do not tell us anything useful (which is made clear on the man pages, once you read about it).

I've found today that the [official Git documentation has a section on "Environment Variables"](https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables), and gives us information about various environment variables we can use to debug.

For instance, `GIT_TRACE` gives us information about what's happening under the hood:

```
$ GIT_TRACE=1 git commit -m "Add page that always requires a logged-in user"
20:52:58.902766 git.c:328               trace: built-in: git 'commit' '-vvv' '-m' 'Add page that always requires a logged-in user'
20:52:58.918467 run-command.c:626       trace: run_command: 'gpg' '--status-fd=2' '-bsau' '23810377252EF4C2'
error: gpg failed to sign the data
fatal: failed to write commit object
```
