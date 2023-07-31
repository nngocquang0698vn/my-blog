---
title: "Performing arbitrary executions with Renovate"
description: "How to run Renovate for one-off package upgrades, rather than using it for longer term maintenance."
date: 2022-12-12T21:27:32+0000
tags:
- "blogumentation"
- "renovate"
- "open-source"
- "security"
- "typescript"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/6661d55f5a.jpeg"
slug: "renovate-one-off"
---
For those who've not seen my blog recently, I've been doing a lot with [Renovate](https://docs.renovatebot.com/) recently for easing the maintenance of my dependencies. This works well when looking to manage dependency updates on your own terms, for instance with per-repository configuration, but sometimes you also want to force some updates across your projects.

As I mentioned in [this GitHub Discussion](https://github.com/renovatebot/renovate/discussions/19352):

> For instance, let's say that in Go, there's a package called `github.com/<org>/grpc-models-go` and a Ruby gem called `grpc-models`, and in v2.0.0 there's a required update that all repositories must update to, for some arbitrary reason.

**Update 2023-07-31**: I previously had released a package, [`@jamietanna/renovate-one-off`](https://www.npmjs.com/package/@jamietanna/renovate-one-off), for this, but it's not necessary.

This requires we set up the following `config.js`:

```javascript
module.exports = {
  // --------------------------------------------------------------------------------
  // required configuration, which makes sure that we don't require Renovate configuration, and even if it's there, we ignore it
  "onboarding": false,
  "requireConfig": "ignored",

  // --------------------------------------------------------------------------------
  //
  // add any global `extends` here

  // to only pin to certain package managers
  enabledManagers: ["ruby", "gomod"],

  packageRules: [
    // make sure that everything but what we want to raise updates for is disabled
    {
      "matchPackagePatterns": [".*"],
      "enabled": false
    },
    // for `grpc-models` the Ruby library, and github.com/<org>/grpc-models-go
    {
      "matchPackagePatterns": [".*grpc-models.*"],
      "enabled": true,
      "allowedVersions": ">=2.0.0"
    },
  ]
};
```

From here, we can then run i.e.

```sh
npx renovate@latest --token $GITHUB_COM_TOKEN --autodiscover --autodiscover-filter '<org>/*'
```

**Note** that if you are running Renovate regularly using the same token as you're doing for this one-off, it may lead to closing existing Renovate PRs or Dependency Dashboards.
