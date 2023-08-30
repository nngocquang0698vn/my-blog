---
title: "Setting up Renovate On-Prem for GitLab.com on Fly.io"
description: "How to set up Renovate On-Prem on Fly.io, when integrating with GitLab.com."
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

Fortunately Mend, the company behind Renovate, provide a _free_ tool called [Renovate On-Prem](https://www.mend.io/free-developer-tools/renovate/on-premises/) which wraps the Renovate Open Source project with the ability to react real-time to notifications.

The last couple of days I was clearing down the backlog of dependency updates I had to do in [dependency-management-data](https://dmd.tanna.dev) and found that conflicts in the `go.mod` and `go.sum` between different dependency updates meant the upgrade process was fairly slow.

Because I've run Renovate On-Prem before at work, I set about doing the same for [my Open Source projects](/open-source/).

I've been using Fly.io for hosting all my apps recently, so set about doing the same for Renovate On-Prem. All the code and config below can be found [in the repo on GitLab.com](https://www.mend.io/free-developer-tools/renovate/on-premises/).

We can use the following `Dockerfile` for the app:

```dockerfile
FROM whitesource/renovate:5.0.1

# defaults
ENV ACCEPT_WHITESOURCE_TOS=y
ENV RENOVATE_PLATFORM=gitlab
ENV RENOVATE_ENDPOINT=https://gitlab.com/api/v4/

# personal configuration
ENV SCHEDULER_CRON='0 * * * *'
ENV RENOVATE_EXTRA_FLAGS=--autodiscover=true

# secrets
ARG LICENSE_KEY
ARG RENOVATE_TOKEN
ARG GITHUB_COM_TOKEN
ARG WEBHOOK_SECRET

EXPOSE 8080
```

Then, we can specify the secrets needed by Renovate with i.e.

```sh
flyctl secrets set WEBHOOK_SECRET=.....
```

You should scale down to 1 instance (as it doesn't horizontally scale):

```sh
flyctl scale count
```

And I've found that 512MB is a good amount of memory to set for Renovate On-Prem to work (it crashes with Out Of Memory (OOM) errors with the default minimal memory limit Fly gives you):

```sh
flyctl scale memory 512
```

The [Renovate On-Prem documentation for GitLab](https://github.com/mend/renovate-on-prem/blob/main/docs/configuration-gitlab.md) covers the definition of the variables, and what you need to do to get Webhooks set up.
