---
title: "How to Undo a `git push --force`"
description: How to recover from a force push with Git.
tags:
- blogumentation
- git
image: https://media.jvt.me/53239026de.png
date: 2021-10-23T10:26:23+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: undo-force-push
aliases:
- /posts/2021/10/23/git-commit-verbose/
---
I really like telling a descriptive story with our Git commit history, and spend a fair bit of time making sure that the history provides the right level of information.

Because writing Git commit messages, and having a good commit history, leads to needing to rewrite Git history, I'm quite comfortable with `git rebase` and [rewriting Git history safely](/posts/2018/09/18/safely-force-git-push/).

One of my colleagues recently got in touch with me to say that they'd force pushed to the wrong branch, and needed a hand to recover things if possible.

Fortunately, this is something I've had to do numerous times - because I've got it wrong myself - so I was able to help.

In the spirit of [blogumentation](/posts/2017/06/25/blogumentation/), I thought I'd document it for future me.

# Finding the commit hash to restore

Note that these are from the viewpoint of your local machine being the one who's pushed it - if trying to recover someone else's, you may need to `git fetch --all` at some point, and play around with the commands. Unfortunately, without a practical example, I can't share too much about how to do that.

## From the Git CLI

### With the output from `git push --force`

The first thing is to make sure that they didn't close the window, or lose the output of the command they'd just run to force push.

Let's say that the output they see is:

```
Enumerating objects: 9, done.
Counting objects: 100% (9/9), done.
Delta compression using up to 16 threads
Compressing objects: 100% (5/5), done.
Writing objects: 100% (5/5), 632 bytes | 632.00 KiB/s, done.
Total 5 (delta 4), reused 0 (delta 0), pack-reused 0
...
To ssh://gitlab.com/jamietanna/jvt.me
 + c574fceb1...5e2791da4 update/wiremock-docs -> update/wiremock-docs (forced update)
```

Git is telling us that it's just force pushed the branch `update/wiremock-docs` to commit `5e2791da4`, when before it was `c574fceb1`.

This means that the left-hand side commit hash, `c574fceb1` is the one we need to restore to.

### Without the output from `git push --force`

If you don't have that output any more, we can fortunately use `git reflog` to recover this.

If we're using the branch `update/wiremock-docs`, on the Git remote `origin`, then we can use `git reflog` like so:

```sh
$ git reflog refs/remotes/origin/update/wiremock-docs
5e2791da4 refs/remotes/origin/update/wiremock-docs@{0}: update by push
c574fceb1 refs/remotes/origin/update/wiremock-docs@{1}: update by push
```

This tells us that the last push to the remote was `5e2791da4` and it overrode `c574fceb1`, so `c574fceb1` is the one we need to restore to.

## Using the GitHub UI

When force pushing on GitHub, the UI shows information about the force-pushes that have occurred:

![A screenshot of the GitHub Web UI, which shows multiple entries with the phrase "jamietanna force-pushed the `chore/spotless` branch from", indicating the commit hashes before and after the push](https://media.jvt.me/9bee4074d5.png)

Let's take the final example:

```
jamietanna force-pushed the chore/spotless branch from 5bc1d11 to 83da01d 2 days ago
```

This means that `5bc1d11` was force pushed over by `83da01d`, which means `5bc1d11` is the one we need to restore.

## Using the GitLab UI

GitLab's UI isn't as clear to read as GitHub's, and so I'd recommend using the `git reflog` trick from above if possible.

However, if you want to try it, GitLab lists the set of commits that are new to the branch:

![A screenshot of the GitLab UI, which shows two entries with the phrase "jamietanna added 1 commit" and the commit hash of the commit that was pushed](https://media.jvt.me/9eb4385d90.png)

In this case, we can see that `5e2791da4` was force pushed over by `4b682452`, which means `5e2791da4` is the one we need to restore to.

## Using the GitHub Events API

Following [this StackOverflow answer](https://stackoverflow.com/a/35273807/2257038) we may be able to recover this using the GitHub [Events](https://docs.github.com/en/rest/activity/events) and [Git references](https://docs.github.com/en/rest/git/refs?apiVersion=2022-11-28) APIs.

Let's say that we overwrote the `main` branch, we could run ([docs](https://docs.github.com/en/rest/activity/events?apiVersion=2022-11-28#list-public-events)):

```sh
gh api /repos/oapi-codegen/nethttp-middleware/events
```

This gives us a JSON blob that we can use to find the most recent event that pushed to `refs/heads/main`:

```json
[
  {
    "actor": {
      "avatar_url": "https://avatars.githubusercontent.com/u/3315059?",
      "display_login": "jamietanna",
      "gravatar_id": "",
      "id": 3315059,
      "login": "jamietanna",
      "url": "https://api.github.com/users/jamietanna"
    },
    "created_at": "2023-09-03T15:00:44Z",
    "id": "31563695994",
    "org": {
      "avatar_url": "https://avatars.githubusercontent.com/u/142752710?",
      "gravatar_id": "",
      "id": 142752710,
      "login": "oapi-codegen",
      "url": "https://api.github.com/orgs/oapi-codegen"
    },
    "payload": {
      "before": "05f0bc05b2f492fa733352779777a79fafc047d2",
      "commits": [
        {
          "author": {
            "email": "...",
            "name": "Jamie Tanna"
          },
          "distinct": true,
          "message": "Migrate to net/http middleware\n\nInstead of just being for chi, we can take this opportunity to make it\nclear this works for any net/http compatible router.\n\nWe can also make sure we've got test coverage for both Chi and Gorilla,\nthe routers that right now would be using this middleware.",
          "sha": "52a3f7be6e47b6f93fcdd8821eca08ead613f14b",
          "url": "https://api.github.com/repos/oapi-codegen/nethttp-middleware/commits/52a3f7be6e47b6f93fcdd8821eca08ead613f14b"
        }
      ],
      "distinct_size": 1,
      "head": "52a3f7be6e47b6f93fcdd8821eca08ead613f14b",
      "push_id": 14904507573,
      "ref": "refs/heads/main",
      "repository_id": 685699676,
      "size": 1
    },
    "public": true,
    "repo": {
      "id": 685699676,
      "name": "oapi-codegen/nethttp-middleware",
      "url": "https://api.github.com/repos/oapi-codegen/nethttp-middleware"
    },
    "type": "PushEvent"
  }
]
```

From here, we can see `payload.before` refers to the commit that was present before the push occurred.

Then, we can create a new branch from that commit:

```sh
gh api /repos/oapi-codegen/nethttp-middleware/git/refs -f ref=refs/heads/tmp-branch-recover -f sha=05f0bc05b2f492fa733352779777a79fafc047d2
```

Now if you run `git fetch` we'll get the old version of the branch available.

# Restoring the branch

Now we've got the commit hash we need to restore to, I'd recommend backing up where we currently are, with the commits we've just force pushed over with:

```sh
$ git branch backup/overriden-branch
```

Then, we need to reset the current branch back to what it was before we force pushed, for instance:

```sh
$ git reset --hard c574fceb1
$ git push --force
```

This then gets us back to where we were, and we can continue with `backup/overriden-branch`'s progress and push it to the right branch this time!
