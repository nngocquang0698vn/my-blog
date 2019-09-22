---
title: "Pushing your Git Branches to a Matching Remote Branch"
description: "How to save yourself from typing `git push --set-upstream origin ${branch}` and have Git determine the branch you're pushing to."
tags:
- blogumentation
- git
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-22T15:33:14+0100
slug: "git-push-matching"
image: /img/vendor/git.png
---
One of the most annoying things about working with branches in Git is managing to push to the upstream repository without receiving the error:

```
$ git push
fatal: The current branch new has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin feature/new-thing
```

Yes, you could remember to run `git push -u origin feature/new-thing` or `git push --set-upstream origin feature/new-thing`, or as I do, have a handy shell alias for it, but life's too short.

It turns out that you can make Git push automagically just by changing default push behaviour. To configure it globally, run:

```sh
git config --global push.default current
```

Or add the following to your `~/.gitconfig`:

```ini
[push]
  default = current
```

This can be added on a per-repo basis by running the below command, if you don't want it to be set globally:

```sh
git config push.default current
```
