---
title: "dependency-management-data now supports Software Bill of Materials (SBOMs) and has better Dependabot support"
description: "Announcing improved support for Dependabot and support for Software Bill of Materials (SBOMs)."
tags:
- dependency-management-data
- sbom
- github
date: 2023-09-10T20:52:26+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: dmd-sbom-dependabot
---
As part of my work on [dependency-management-data](https://dmd.tanna.dev), I've mostly been focussing on utilising [Renovate](https://docs.renovatebot.com/) as the underlying datasource due to its excellent support for different package managers, language runtimes and ecosystems.

The original datasource for dependency-management-data - [before it was Open Source'd as dependency-management-data](https://www.jvt.me/posts/2022/09/29/roo-hacktoberfest-dependency-analysis/) - was Dependabot, but as mentioned in [_Prefer using the GitHub Software Bill of Materials (SBOMs) API over the Dependency Graph GraphQL API_](https://www.jvt.me/posts/2023/09/10/github-dependency-api-sbom/), the GraphQL API we were using for the data didn't provide the most usable data.

However, with this release, we're now using the [Software Bill of Materials endpoint](https://docs.github.com/en/rest/dependency-graph/sboms?apiVersion=2022-11-28), which provides much more actionable information, and means the Dependabot datasource is now much more useful 👏

With the ability to parse SBOMs from GitHub, I've also taken the opportunity to add support for parsing SBOMs from other data sources, so you can bring an SBOM from your own tooling, for instance [the Snyk SBOM export functionality](https://docs.snyk.io/snyk-api-info/get-a-projects-sbom-document-endpoint) or through tools like [syft](https://github.com/anchore/syft).

This launches with [v0.38.0](https://gitlab.com/tanna.dev/dependency-management-data/-/releases/v0.38.0), and is further improved with support for custom advisories with [v0.39.0](https://gitlab.com/tanna.dev/dependency-management-data/-/releases/v0.39.0), and in the coming releases I'll be improving the advisories functionality, although initially it looks like it won't be as powerful as the Renovate datasource, as the SBOMs I've worked with so far don't capture things like the version of Go, Ruby, etc in use.

And a big thanks to <span class="h-card"><a class="u-url" href="https://www.linkedin.com/in/ericsmalling">Eric Smalling</a></span> who helped with Snyk's SBOM support!
