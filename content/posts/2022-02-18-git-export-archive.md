---
title: Exporting a Git repo as an archive
description: "How to export a Git repo as an archive format, such as a `.tar.gz` or a `.zip`."
tags:
- blogumentation
- git
image: /img/vendor/git.png
date: 2022-02-18T14:01:20+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: git-export-archive
syndication:
- "https://brid.gy/publish/twitter"
---
I almost always work on projects with a Git repo backing it, even if it's not pushed anywhere and is more for a safer undo/redo functionality.

I've recently been doing some work that's required sending a ZIP of my work, rather than sharing a Git repo.

Although I would usually turn to the GitLab/GitHub UI to export to an archive for me, I remember reading that [git-archive](https://linux.die.net/man/1/git-archive) command exists, and is in fact used under the hood.

In your Git repo, we can run `git archive` to do this for us:

```sh
$ git archive origin/main -o archive.zip
# or we can be explicit about the file format
$ git archive origin/main --format=tgz -o archive.tar.gz
# defaults to stdout, beware!
$ git archive origin/main > archive.tar
```
