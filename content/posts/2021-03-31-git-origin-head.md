---
title: "Working with a Git remote's default branch, using `origin/HEAD`"
description: "How to interact with the default branch for a remote repo, as well as update it if needed."
date: 2021-03-31T19:15:53+0100
tags:
- "blogumentation"
- git
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
slug: "git-origin-head"
image: /img/vendor/git.png
---
Git provides the `HEAD` pointer to reference the currently checked out branch. Locally, this would be whichever branch you're on, but for a remote Git repo, this can be the default branch to check out the repo for.

A number of Git hosting services are exposing this recently as `origin/HEAD`, and I've found it to be such a useful tool, especially when I'm working across repos that have a different default branch configured.

I'm finding it incredibly helpful to replace my muscle memory of `git rebase -i origin/develop` or `git rebase -i origin/main` with `git rebase -i origin/HEAD`, which saves me having to remember what branch is currently used!

Sometimes you clone a fresh repo, before a default branch is configured (i.e. if it's empty), and that leads to `origin/HEAD` never being updated, as it doesn't pull that information as part of a `git fetch`.

# When the remote repo exposes `origin/HEAD`

You may be fortunate with the repo host producing the `origin/HEAD` ref, in which case, you can run the following to sync your local `origin/HEAD` with them:

```sh
git remote set-head origin -a
```

# When the remote repo does not expose `origin/HEAD`

If it's not set, we need to do it ourselves. Assuming that the Git repo uses the `trunkasaurus` branch:

```sh
git update-ref origin/HEAD origin/trunkasaurus
```

This also works when you don't agree with what's being told to you as default, and you want a different value locally!
