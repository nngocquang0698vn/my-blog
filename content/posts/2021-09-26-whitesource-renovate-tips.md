---
title: "Tips for Reducing Dependency Upgrade Toil with WhiteSource Renovate"
description: "Some tips I've picked up while working with WhiteSource Renovate to keep my projects up-to-date."
date: 2021-09-26T18:21:40+0100
tags:
- blogumentation
- renovate
- open-source
- security
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/c676e51a31.png"
slug: "whitesource-renovate-tips"
---
Although it's generally the most fun part of working on a new piece of software, the initial building of it is much smaller in time investment than maintaining it.

One of the things you need to do as a maintainer is to keep the project's dependencies updated. As well as ensuring that you're picking up security upgrades, there's also the need to keep generally up to date. By staying up to date, we make sure we're able to build on top of bug fixes, performance improvements, and new features that can help us write better code in the future.

Between work and personal life, I manage a lot of projects that need to stay up to date, and although I'd tried to keep on top of it myself, fairly regularly checking that things were up to date, it really doesn't scale, and can lead to expending a tonne of energy for seemingly little gain in comparison.

One way that we can improve the experience of keeping on top of dependencies is using tools like [Dependabot](https://dependabot.com/) or [WhiteSource Renovate](https://www.whitesourcesoftware.com/free-developer-tools/renovate/), which are able to automagically determine what's required, perform the version bump, and get a Pull Request/Merge Request raised for your review.

I've been using Renovate at work, as well as with a few of the personal projects I run on GitLab.com, and have found some good tips for getting effective use of Renovate that I thought would be worth sharing.

# Utilise Presets

Because there are a lot of common workflows and requirements that communities have, Renovate's got the concept of presets which allows reducing duplication.

For instance, the below sets the Renovate configuration to leverage a tonne of recommended configuration by Renovate, and the community:

```json
{
  "extends": [
    "config:base"
  ]
}
```

These help massively reduce your time to getting feedback from Renovate, and includes some really great things.

As well as the ["full config" presets](https://docs.renovatebot.com/presets-config/), such as `config:base`, there's also more [granular presets](https://docs.renovatebot.com/presets-default/) that you can apply, as well as the ability to configure the Renovate JSON configuration fully.

# Utilise Centralised Configuration

To simplify the configuration across all your repos, I'd very strongly recommend managing it through an [organisation-level preset](https://docs.renovatebot.com/config-presets/#organization-level-presets).

This allows us to keep things consistent, reducing duplication, and providing a central place to push out new requirements.

If you want to override it on a per-repo basis, you can inherit from the organisation level configuration and then extend what you want, or you can completely override what configuration is applied at the organisation level.

# Bundle Upgrades Together

On a few of our services at work, we perform a full build/test/deploy through a dev environment for each Pull Request, which means we're seeing ~45 minutes per dependency upgrade. Renovate's `config:base` presets lead to 20 PRs being raised which started to flood our deployments, incurring a lot of wasted deployment costs for very minor upgrades.

Where we require branches to be in sync with their target branch before merging, this would lead to us being only able to tackle one upgrade at a time, which was pretty slow, and meant that for some repos which were fairly behind on upgrades, we'd take quite some time to get back up-to-date.

This is especially slow for the services that require deployments, but even for libraries that can build/test pretty speedily, it adds unnecessary overhead to keeping things up to date, and slows down the ability to sit down and keep updated.

We found that the best way of handling this is to upgrade minor + patch releases together, as they _generally_ just work:

```json
{
  "extends": [
    "group:allNonMajor"
  ]
}
```

Or, if you need to tweak it more:

```json
{
  "packageRules": [
    {
      "matchPackagePatterns": [
        "*"
      ],
      "matchUpdateTypes": [
        "minor",
        "patch"
      ],
      "groupName": "all non-major dependencies",
      "groupSlug": "all-minor-patch"
    }
  ]
}
```


We've had a few times where we need to checkout the branch and apply some manual tweaks, but in most cases, the PRs work fine, and test coverage gives us evidence it's safe to release.

This then means that major upgrades (much more likely to be breaking) are still raised separately, leading to an easier way to review + update them.

## Excluding Breaking Dependencies (such as Localstack)

Some dependencies may not follow [Semantic Versioning](https://semver.org), or they may still be on a 0.x release, so bundling the minor/patch upgrades may not be as simple as you think.

We've been bitten by this before with Localstack, which we've made sure isn't included in our grouped PRs:

```json
{
  "packageRules": [
    {
      "matchPackagePatterns": [
        "*"
      ],
      "matchUpdateTypes": [
        "minor",
        "patch"
      ],
      "excludePackageNames": [
        "localstack/localstack"
      ],
      "groupName": "all non-major dependencies",
      "groupSlug": "all-minor-patch"
    }
  ]
}
```

This ensures that Localstack PRs can be reviewed separately to the others, and gives us a bit more control over when they are merged.

# Dependency Dashboard

Although it's more useful when not bundling minor+patch releases together, using the [Dependency Dashboard](https://docs.renovatebot.com/key-concepts/dashboard/) can be very helpful to see how your dependency upgrades are doing, whether there are higher priority PRs not yet picked up, and allows you to require approval for certain packages.

# Experimenting

Finally, have a bit of a trial in what works well for your project, maintainers, and frequency of updates. You may find that you want to exclude development dependencies (i.e. in NPM) or that you want to schedule the PRs being raised / built overnight, so it doesn't impact active development.
