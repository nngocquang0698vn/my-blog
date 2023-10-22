---
title: "Plea to Software Composition Analysis (SCA) providers and Software Bill of Materials (SBOMs) producers: give us more data!"
description: "Why I think dependency scanning tooling should be providing as much data as possible about scanned projects, to allow other tooling to make better inferences about the data."
tags:
- sbom
- dependency-management-data
- persuasive
date: 2023-10-22T14:15:06+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: plea-sca-sbom-data
---
While working on [dependency-management-data](https://dmd.tanna.dev), one of the greatest pieces of interesting data was to understand what version of languages such as Node.JS and Ruby teams are running, to then be able to flag up usage of deprecated or end-of-life software, in this case via [endoflife.date](https://endoflife.date).

This data was only available through the [Renovate datasource](https://dmd.tanna.dev/concepts/datasource/#renovate), and has been a particularly disappointing outcome of working with either GitHub's Dependabot or through a few Open Source and proprietary tools to produce SBOMs. This may be due to Renovate being used for a slightly different purpose, but I also believe this is _more_ that Renovate's Open Source nature and excellent contributing model allows for a much wider set of data to be gleaned.

It's a shame that SBOMs and other SCA exports I've seen don't necessarily have the depth that I'd like to be able to start making other assumptions, so this is a plea to add them!

This may be a slightly controversial opinion, because some folks I've spoken to about this have disagreed, and only want _production-facing_ dependencies included, not any utilities or test-only.

I say this as someone who's absolutely been burned before by poorly utilised data, and so who realises the damage that it can cause. For instance, at Capital One, our SCA tools weren't tuned correctly for Gradle (despite us raising Pull Requests to show and remediate the issue, which were never accepted by internal teams) which led to test-only dependencies being treated as production dependencies, resulting in far more vulnerabilities needing fixing than counterparts doing the exact same work, with Maven.

We shouldn't let situations like this tarnish our ability to collect more useful data, and should instead correctly discover dependencies as the type they are, and make it possible to flag false positives.

Let's make the data better and more able to serve a widespread set of use-cases, rather than just "what software am I running in Production". If we want to have a split between production and production-and-everything-else, why not build two SBOMs, and we can't do it with the tools or formats we have available, maybe we need to improve them.
