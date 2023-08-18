---
title: "Determining if there are uncommitted changes in Git"
description: "A one-liner to work out whether there are uncommitted changes in a repository."
date: "2022-04-29T16:45:02+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1520068964029800454"
tags:
- "blogumentation"
- "command-line"
- "git"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/53239026de.png"
slug: "git-uncommitted-changes"
---
Sometimes you want to validate that your Git worktree is clean, for instance to make sure that there aren't any uncommitted formatting changes when building your project in CI/CD.

You could try and do it with a `git status --porcelain` and check that there are no lines, but as per [this StackOverflow answer](https://stackoverflow.com/questions/3878624/how-do-i-programmatically-determine-if-there-are-uncommitted-changes/3879077#3879077), it's even simpler by running:

```sh
git diff-index --quiet HEAD --
```

This exits with a non-zero error code if there are changes found, so you can use it to fail the build.

Alternatively, you may want to see the unexpected changes, in which case you can run:

```sh
git diff-index --exit-code --patch HEAD --
```
