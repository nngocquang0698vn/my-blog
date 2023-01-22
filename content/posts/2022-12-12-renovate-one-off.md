---
title: "Performing arbitrary executions with Renovate"
description: "How to run Renovate for one-off package upgrades, rather than using it for longer term maintenance."
date: 2022-12-12T21:27:32+0000
syndication:
- https://brid.gy/publish/twitter
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

In this case, there's no handy way to roll out a change across your repos as part of Renovate, while also ignoring existing Renovate PRs or Dependency Dashboards, which meant I needed to roll my own lightweight wrapper on top of Renovate, which is available in the new NPM package, [`@jamietanna/renovate-one-off`](https://www.npmjs.com/package/@jamietanna/renovate-one-off).

As mentioned in [the README](https://gitlab.com/tanna.dev/renovate-one-off), can be run like so:

```sh
renovate-one-off --token $GITHUB_COM_TOKEN --autodiscover --autodiscover-filter '<org>/*'
```

This works alongside a `config.js`:

```javascript
module.exports = {
  // i.e.
  platform: "github",
  // if you pin to forks, for instance
  includeForks: true,

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

Which will then raise any relevant PRs your organisation for relevant package updates - straightforward, and only rolls out the changes as required!
