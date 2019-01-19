---
title: "Using Git refs to check out GitLab Merge Requests, from your local repo"
description: "How to pull the Git refs for Merge Requests to your GitLab repo."
categories:
- blogumentation
- git
- gitlab
tags:
- blogumentation
- git
- gitlab
- git-ref
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-01-19
slug: "git-ref-gitlab-merge-requests"
image: /img/vendor/gitlab-wordmark.png
---
When reviewing a Merge Request, it can be often more helpful to check out the codebase with the changes applied, rather than just reviewing through the interface.

If you're not wanting to just use [GitLab's Web IDE](https://docs.gitlab.com/ee/user/project/web_ide/), you would want to do this locally. However, that'd require you to `git clone` the fork, and check out their branch, right?

Not quite! GitLab actually provides a [Git ref](https://git-scm.com/book/en/v2/Git-Internals-Git-References) that allows you to check out **??**

And in action:

```
$ git fetch
$ git show-ref
20a50e400fd82aa3ae9d4f97a808a38f75db2f23 refs/heads/master
20a50e400fd82aa3ae9d4f97a808a38f75db2f23 refs/remotes/origin/HEAD
20a50e400fd82aa3ae9d4f97a808a38f75db2f23 refs/remotes/origin/master
d6b3080d9b75d7a859ad0bc019c27b061e83cf23 refs/remotes/origin/merge-requests/1/head
$ git log -1 origin/merge-requests/1/head (origin/merge-requests/1/head)
commit d6b3080d9b75d7a859ad0bc019c27b061e83cf23
Author: Anna <itxad7@nottingham.ac.uk>
Date:   Mon Aug 1 21:08:37 2016 +0100

    Add CV template and Update Setup.sh

    - Added template.tex from modernCV
    - Removed bibliography and commented out picture from template
    - Renamed to cv.tex
    - Amended setup script to enable document type CV
```

Note: this is documented in [GitLab's Merge Requests documentation](https://docs.gitlab.com/ee/user/project/merge_requests/#checkout-merge-requests-locally).

# Configuring per-repo using `git config`

If you want only the current repo you're in to attempt to pick up Merge Requests, you can run the following in the repo:

```sh
git config remote.origin.fetch '+refs/merge-requests/*:refs/remotes/origin/merge-requests/*'
```

# Configuring globally using `git config --global`

If you want any repo you use to attempt to attempt to pick up Merge Requests, you can run the following in the repo:

```sh
git config --global remote.origin.fetch '+refs/merge-requests/*:refs/remotes/origin/merge-requests/*'
```

# Configuring globally using `~/.gitconfig`

The way that I've got this set up in my personal configuration is that for each repo I have, it will try and pull down any Merge Requests for the `origin` remote:

```ini
[remote "origin"]
	fetch = +refs/merge-requests/*:refs/remotes/origin/merge-requests/*
```
