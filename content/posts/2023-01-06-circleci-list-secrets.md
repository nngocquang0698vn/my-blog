---
title: "Listing secrets stored in CircleCI"
description: "How to list all the secrets in your CircleCI organisation."
date: 2023-01-06T09:36:15+0000
tags:
- blogumentation
- circleci
- go
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: circleci-list-secrets
image: https://media.jvt.me/98dfc9e215.png
---
If you've not seen, [CircleCI yesterday announced that they had recently had a breach](https://circleci.com/blog/january-4-2023-security-alert/). As part of this, teams are recommended to rotate all of their secrets, but to do that, you need to easily find out what secrets are in place.

I've put together a sample project on [on GitLab.com](https://gitlab.com/tanna.dev/circleci-secret-list) that allows querying for all secrets in Contexts as well as per-Project secrets, in a Tab Separated Value (TSV) format that makes it handy to copy-paste into things like Google Sheets.

To list all contexts:

```sh
export CIRCLE_TOKEN=...
./circleci-secret-list -token $CIRCLE_TOKEN -slug gh/jamietanna
```

Or to list all projects, if you've created a `repos.txt` using i.e. [this blog post](https://www.jvt.me/posts/2022/10/26/list-github-repos-org/):

```sh
export CIRCLE_TOKEN=...
./circleci-secret-list -token $CIRCLE_TOKEN -slug gh/jamietanna -repos repos.txt
```
