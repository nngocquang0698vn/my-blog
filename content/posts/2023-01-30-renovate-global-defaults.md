---
title: "Setting up default Renovate configuration while allowing overriding of that configuration"
description: "How to run Renovate to provide some defaults for repos that aren't opted-in, as well as allowing repos to opt-in."
date: 2023-01-30T09:41:42+0000
tags:
- "blogumentation"
- "renovate"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/6661d55f5a.jpeg"
slug: renovate-global-defaults
---
I've [written about](/tags/renovate/) how great Renovate is great for managing your dependencies across the toolchains you support, and giving you control over how the updates are made across your repositories.

Although it can be handy for teams owning repositories to have full control over their `renovate.json` and tweaking which rules are used, sometimes we also want to have some default configuration for teams that aren't "onboarded" to Renovate by having a `renovate.json` in their repo.

Let's say that we have the requirements:

- we want to ensure that teams are keeping on top of their Docker and GitLab CI updates
- we don't want to add a `renovate.json` to each repository with default configuration, and then keep it up-to-date
- we want to allow teams to specify their own configuration to override / augment the defaults

We'll create a repository `renovate-config` in our organisation to store our shared configuration, and in it we'll start by defining the `not-onboarded.json` preset:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "github>some-org/renovate-config:base",
    "schedule:weekly"
  ],
  "enabledManagers": [
    "dockerfile",
    "docker-compose",
    "kubernetes",
    "gitlabci"
  ]
}
```

This inherits from `base.json`, which has some org-wide defaults:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "hostRules": [
    {
      "matchHost": "artifacts.example.com",
      "username": "svc_renovate",
      "password": "..."
    }
  ]
}
```

Then, when we're [configuring Renovate using a `config.js`](https://docs.renovatebot.com/getting-started/running/#using-configjs), we'll get:

```javascript
module.exports = {
  requireConfig: "optional",
  onboarding: false,
  extends: [
    "github>some-org/renovate-config:not-onboarded",
  ],
}
```

This gives us the first two requirements, but how would a team override this to use the preset `default.json`:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "config:base",
    "github>some-org/renovate-config-presets:base"
  ]
}
```

Well, in the team's repo, they would create their `renovate.json`:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "github>some-org/renovate-config"
  ],
  "ignorePresets": [
    "github>some-org/renovate-config-presets:not-onboarded"
  ]
}
```

Note that you do need the `ignorePresets` in each repo's `renovate.json` instead of being able to put it in `default.json`, as [found in this discussion](https://github.com/renovatebot/renovate/discussions/19166#discussioncomment-4703941).
