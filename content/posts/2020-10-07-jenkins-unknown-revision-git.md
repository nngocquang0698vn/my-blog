---
title: "`unknown revision or path not in the working tree` after Jenkins Git Plugin Update"
description: "How to fix `git rev-parse` suddenly not working after a Jenkins Git plugin update."
tags:
- blogumentation
- jenkins
- git
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-10-07T22:09:44+0100
slug: "jenkins-unknown-revision-git"
image: https://media.jvt.me/0318664e33.png
---
A few times this year I've been helping folks at work fighting an odd issue where, after performing Jenkins Git plugin updates, they're suddenly having their projects failing to build with the error:

```
git rev-parse origin/...
 git output: fatal: ambiguous argument 'origin/...': unknown revision or path not in the working tree.
Use '--' to separate paths from revisions, like this:
```

From what I've seen, it's when we're checking out a branch, but then we're trying to run `git rev-parse` against a branch that isn't the current branch. After debugging, it turns out that this is due to the way that the Git plugin now defaults to not pulling all the Git refs on clone, so needs tweaking in the Jenkins UI to include the refs that you want including.
