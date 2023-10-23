---
title: "Importing a subdirectory from one repo into another"
description: "How to import a subdirectory of a given Git repository into another one, using `git subtree`."
tags:
- blogumentation
- git
- git-subtree
- command-line
image: https://media.jvt.me/53239026de.png
date: 2023-10-23T20:15:18+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: import-subtree-git-repo
---
When I wrote [_Merging multiple repositories into a monorepo, while preserving history, using `git subtree`_](https://www.jvt.me/posts/2018/06/01/git-subtree-monorepo/), I'd found it useful to be able to merge multiple repos into a single one. However, sometimes you don't want the _whole_ repo, but only a subdirectory.

(After it being on my TODO list for [over 6 years (!)](https://gitlab.com/tanna.dev/jvt.me/-/issues/101), I'm finally documenting it.)

This has recently been very useful with [working to reduce the size of the dependency tree in oapi-codegen](https://www.jvt.me/posts/2023/10/23/oapi-codegen-v2-decrease/), as we've been splitting out parts of the repository into multiple repos. I wanted to retain the Git history for this, but wanted to make sure that it was only for the subset of the repository I cared about, instead of having the whole repo's history since the beginning of time.

To do this, we can follow [the `git subtree` option from this StackOverflow](https://stackoverflow.com/a/30386041).

For instance, when doing this with oapi-codegen, I ran the following to import the `pkg/runtime` subdirectory:

```sh
#
git remote add upstream --no-tags https://github.com/deepmap/oapi-codegen
git fetch upstream
git checkout upstream/master
git subtree split -P pkg/runtime -b tmp
git checkout main
git subtree add tmp -P pkg
git mv pkg/* .
git add .
git commit -m 'Flatten directory structure'
```
