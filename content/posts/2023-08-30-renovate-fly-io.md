---
title: "Setting up Mend Renovate Community Edition for GitLab.com on Fly.io"
description: "How to set up Mend Renovate Community Edition on Fly.io, when integrating with GitLab.com."
date: 2023-08-30T10:16:22+0100
tags:
- "blogumentation"
- "renovate"
- "fly.io"
- "gitlab"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/6661d55f5a.jpeg"
slug: renovate-fly-io
---
I've written about being a huge fan of [Renovate](https://docs.renovatebot.com) before, and have been using it personally and professionally for a few years.

I first set up Renovate for my personal GitLab.com projects using [the official GitLab setup](https://gitlab.com/renovate-bot/renovate-runner), which followed the original way I set up Renovate at Deliveroo using the [Renovate GitHub Action](https://github.com/renovatebot/github-action).

This model works well for a while, but at some point, losing out on the real-time updates on Pull/Merge Requests or through the Dependency Dashboard can make the app feel rather sluggish, especially if you've been using the hosted app on GitHub.

Fortunately Mend, the company behind Renovate, provide a _free_ tool called [Mend Renovate Community Edition](https://www.mend.io/renovate-community/) (previously called Mend Renovate On-Prem) which wraps the Renovate Open Source project with the ability to react real-time to notifications.

The last couple of days I was clearing down the backlog of dependency updates I had to do in [dependency-management-data](https://dmd.tanna.dev) and found that conflicts in the `go.mod` and `go.sum` between different dependency updates meant the upgrade process was fairly slow.

Because I've run Mend Renovate Community Edition before at work, I set about doing the same for [my Open Source projects](/open-source/).

I've been using Fly.io for hosting all my apps recently, so set about doing the same for Mend Renovate Community Edition. All the code and config below can be found [in the repo on GitLab.com](https://gitlab.com/tanna.dev/renovate-runner).

We can use the following `Dockerfile` for the app:

```dockerfile
FROM ghcr.io/mend/renovate-ce:6.0.0-full

ENV MEND_RNV_ACCEPT_TOS=y
ENV MEND_RNV_PLATFORM=gitlab
ENV MEND_RNV_ENDPOINT=https://gitlab.com/api/v4/
ENV MEND_RNV_CRON_JOB_SCHEDULER='0 * * * *'
ENV RENOVATE_EXTRA_FLAGS=--autodiscover=true

ARG MEND_RNV_LICENSE_KEY
ARG MEND_RNV_GITLAB_PAT
ARG GITHUB_COM_TOKEN
ARG MEND_RNV_WEBHOOK_SECRET

EXPOSE 8080
```

Then, we can specify the secrets needed by Renovate with i.e.

```sh
flyctl secrets set MEND_RNV_WEBHOOK_SECRET=.....
```

You should scale down to 1 instance (as it doesn't horizontally scale):

```sh
flyctl scale count 1
```

And I've found that 1024MB is a good amount of memory to set for Mend Renovate Community Edition to work (it crashes with Out Of Memory (OOM) errors with the default minimal memory limit Fly gives you):

```sh
fly scale vm shared-cpu-1x
flyctl scale memory 1024
```

The [Renovate On-Prem documentation for GitLab](https://github.com/mend/renovate-on-prem/blob/main/docs/configuration-gitlab.md) covers the definition of the variables, and what you need to do to get Webhooks set up.

Also, make sure you've turned off the ability for Fly to [Automatically stop and start Machines](https://fly.io/docs/apps/autostart-stop/).

**Update 2023-09-28**: Coming from Renovate On Prem? Check out [the official migration docs](https://github.com/mend/renovate-ce-ee/blob/main/docs/migrating-to-renovate-ce.md) and [the changes I needed to make on my personal installation](https://gitlab.com/tanna.dev/renovate-runner/-/merge_requests/1).
