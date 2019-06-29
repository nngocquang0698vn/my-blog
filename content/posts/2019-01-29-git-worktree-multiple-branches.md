---
title: "Using `git worktree` to have multiple branches checked out at once"
description: "How to use `git worktree` to check out multiple Git branches from the same repo at once."
tags:
- blogumentation
- git
- git-worktree
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-01-29T21:39:04+00:00
slug: "git-worktree-multiple-branches"
image: /img/vendor/git.png
---
On some of the projects I work on (such as this site) I'll be often multi-tasking between pieces of work. I'll be regularly context switching between branches i.e. responding to review comments, or moving further on development of a feature. One of the most painful things about this is only being able to check out one branch at a time.

That is, unless you know about [`git worktree`](https://git-scm.com/docs/git-worktree)! The command allows you to have an arbitrary number of branches checked out from the same Git repo in different folders, saving you from re-cloning the repo.

# Checkout out a branch

If we follow the approach of context switching, we'll use the example of having two branches open - our primary branch is `feature/h-card-entry` and we will be we will be switching back and forth from `article/git-worktree-multiple-branches` as review comments arrive.

```
repo $ git status
On branch feature/hcard-entry
nothing to commit, working tree clean
repo $ git log
commit c8340c91c458aa886a8281792e08b67c1b535056
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Tue Jan 29 20:45:52 2019 +0000

    Configure h-card entry for me

commit 99e99f47f2a81d4d6823349f40d1420e61c2b9b5
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Tue Jan 29 20:23:25 2019 +0000

    New Hugo site
```

We've just seen some emails come in to say we've received some review comments on our second branch, so instead of `git commit` / `git stash`ing our work and then checking out the other branch, we'll utilise `git worktree` to check out the branch in a new folder `article/git-worktree-multiple-branches`:

```
repo $ git worktree add .worktrees/article-git-worktree-multiple-branches article/git-worktree-multiple-branches
Preparing worktree (checking out 'article/git-worktree-multiple-branches')
HEAD is now at 4bc7724 Add article
```

There are a couple of things to note here that are personal choices:

- I stick all my worktrees in a `.worktrees` folder, so it doesn't clog up my root level view of the project, as well as making it easier to ignore in i.e. Vim, IntelliJ
- I convert branch names to slugs (i.e. remove the `/`s) so it's easier to `cd` around

Now this is done, we can now see our branch checked out in the folder:

```
repo $ ls .worktrees
article-git-worktree-multiple-branches
repo/.worktrees/article-git-worktree-multiple-branches $ cd .worktrees/article-git-worktree-multiple-branches
repo/.worktrees/article-git-worktree-multiple-branches $ git log
commit 4bc7724a559e966675619b1fe7ad8bc70856640e
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Tue Jan 29 20:45:05 2019 +0000

    Add article

commit 99e99f47f2a81d4d6823349f40d1420e61c2b9b5
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Tue Jan 29 20:23:25 2019 +0000

    New Hugo site
```

In the case that we want to check which branches are currently being tracked by `git worktree`, we can use the `list` subcommand:

```
repo $ git worktree list
/path/to/repo                                                    c8340c9 [feature/hcard-entry]
/path/to/repo/.worktrees/article-git-worktree-multiple-branches  4bc7724 [article/git-worktree-multiple-branches]
```

This makes it easy to see at-a-glance which branches have been checked out where.

# Making changes to these branches

These branches can be interacted with just as if we'd only got one branch checked out - we can `git commit`, `git push` and `git pull` / `git fetch` to our heart's content!

One great thing about worktrees is that we don't need to worry about `git fetch`ing everywhere - because the Git repo root is shared across all worktrees, a fetch in any worktree can be seen everywhere else!

# Cleaning up branches

But what about when it gets to the point that we need to remove some of our worktrees, for instance if `article/git-worktree-multiple-branches` has been merged?

```
repo $ git status
repo $ git log master
commit 4bc7724a559e966675619b1fe7ad8bc70856640e
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Tue Jan 29 20:45:05 2019 +0000

    Add article

commit 99e99f47f2a81d4d6823349f40d1420e61c2b9b5
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Tue Jan 29 20:23:25 2019 +0000

    New Hugo site
```

If we say tried to [clean up our Git branches]({{< ref 2017-06-07-clean-up-git-branches >}}), we would see the below error:

```
repo $ git branch --all --merged | egrep -v "(^\*|master|develop)" | xargs git branch -d
error: Cannot delete branch 'article/git-worktree-multiple-branches' checked out at '/path/to/repo/.worktrees/article-git-worktree-multiple-branches'
```

This is annoying, but fair enough - the same would be true if we only had one branch checked out and we'd tried to remove it. Instead, we need to `rm` the directory and its contents:

```
repo $ rm -r worktree/feature-1
repo $ git worktree list
repo $ ls -al worktree
total 0
drwxr-xr-x 1 jamie jamie  0 Jan 29 20:51 .
drwxr-xr-x 1 jamie jamie 18 Jan 29 20:51 ..
```

So now the worktree is no longer on disk, why is it still in our list of worktrees? This is because Git is clever and tracks the worktree information internally instead of relying on files on disk (this is largely due to the usecase of worktrees potentially being on network attached storage):

```
$ ls -al .git/worktrees/
```

So to clean up our branches, we'll need to run `git worktree prune`:

```
$ git worktree prune
$ git worktree list
/path/to/repo                                                    c8340c9 [feature/hcard-entry]
```

This then shows that we've only got our `feature/hcard-entry` branch checked out - great success!
