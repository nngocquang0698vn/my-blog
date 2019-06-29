---
title: "Using Git refs to help track your GitLab Environments, from your local repo"
description: "How to pull the Git refs that GitLab Environments exposes in your GitLab repo."
tags:
- blogumentation
- git
- gitlab
- review-apps
- git-ref
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-01-19T18:06:00+00:00
slug: "git-ref-gitlab-environments"
image: /img/vendor/gitlab-wordmark.png
---
If you're using GitLab's Environments concept to track your deployments to i.e. Production, or even to a feature branch using [Review Apps](https://docs.gitlab.com/ee/ci/review_apps/), you may be aware that GitLab will map the Environment's deployment back to the commit that created it.

This is all done using [Git refs](https://git-scm.com/book/en/v2/Git-Internals-Git-References), and means that if we were to pull that reference down, we'd be able to actually `git checkout` that deployment's code - which is an _awesome_ way to determine what's running there and then, instead of i.e. tracking down what artefact it is, etc.

And in action, a `git log --decorate`:

```
commit 8056534399346aa620be7b61f905dde5c374eea2 (HEAD -> article/git-refs, origin/master, origin/environments/staging/deployments/1191, origin/environments/production/deployments/1192, origin/HEAD)
Merge: 4a5603c 390a588
Author: Jamie Tanna <gitlab@jamietanna.co.uk>
Date:   Fri Jan 18 18:06:00 2019 +0000

    Merge branch 'defect/rss-desc' into 'master'

    Use post's `description` tag for RSS description

    See merge request jamietanna/jvt.me!233
```

Once you configure it, following one of the options below, every `git pull` or `git fetch` will pick up any new changes in GitLab's Environments - yay!

Note: this is documented in [GitLab's Environments documentation](https://docs.gitlab.com/ee/ci/environments.html#checkout-deployments-locally).

# Configuring per-repo using `git config`

If you want only the current repo you're in to attempt to pick up Environments, you can run the following in the repo:

```sh
git config remote.origin.fetch '+refs/environments/*:refs/remotes/origin/environments/*'
```

# Configuring globally using `git config --global`

If you want any repo you use to attempt to pick up Environments, you can run the following:

```sh
git config --global remote.origin.fetch '+refs/environments/*:refs/remotes/origin/environments/*'
```

# Configuring globally using `~/.gitconfig`

The way that I've got this set up in my personal configuration is that for each repo I have, it will try and pull down any refs under `environments` for the `origin` remote:

```ini
[remote "origin"]
	fetch = +refs/environments/*:refs/remotes/origin/environments/*
```
