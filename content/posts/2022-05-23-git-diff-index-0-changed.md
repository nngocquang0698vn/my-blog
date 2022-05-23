---
title: "Weirdness with `git diff-index` showing `1 file changed, 0 insertions(+), 0 deletions(-)`"
description: "Something weird I hit last week with `git diff-index`, which shows 1 file changed, but no changes."
date: 2022-05-23T09:11:22+0100
syndication:
- https://brid.gy/publish/twitter
tags:
- "blogumentation"
- "command-line"
- "git"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/53239026de.png"
slug: "git-diff-index-0-changed"
---
Last week I was writing some automation that would validate that [my Git repo had no uncommitted changes]( https://www.jvt.me/posts/2022/04/29/git-uncommitted-changes/) after running `go generate`, to make sure all source files were up to date.

I thought it was running fine locally, but CI was telling me that no, it was not working when running in `docker-compose` as part of the pipeline.

What I was seeing was:

```sh
$ go generate ./... && git diff-index --quiet HEAD --
$ echo $?
1
```

This was very odd, because when I would run `git diff` or `git status`, nothing would show as changed when run after `git diff-index`, but if I ran `git diff --shortstat` I would get the following output:

I spent a good day fighting this, trying to look into [debugging information in Git](https://www.jvt.me/posts/2020/09/22/git-debug-environment-variable/) but no luck.

Contrary to most StackOverflow responses, it was not related to [file permissions](https://stackoverflow.com/a/26054827/2257038), and setting that config changed nothing.

My hacky workaround solution was to instead run:

```sh
$ go generate ./... && git status; git diff-index --quiet HEAD --
$ echo $?
1
```

Sorry I don't have a fix for it, or a reproducible case, but hopefully if you have this issue in the past you know a workaround!
