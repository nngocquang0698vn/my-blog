---
title: "Introducing `renovate-to-sbom` to convert Renovate data to Software Bill of Materials (SBOMs)"
description: "Creating a new command-line tool for converting Renovate data exports to Software Bill of Materials (SBOMs)."
tags:
- dependency-management-data
- renovate
- sbom
date: 2023-11-03T21:46:05+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: renovate-to-sbom
image: "https://media.jvt.me/6661d55f5a.jpeg"
---
Over the last few months building [dependency-management-data](https://dmd.tanna.dev), I've been playing around with the great data from [Renovate](https://docs.renovatebot.com/) via [`renovate-graph`](https://www.jvt.me/posts/2022/11/01/renovate-dependency-graph/), as well as [Software Bill of Materials (SBOMs)](https://about.gitlab.com/blog/2022/10/25/the-ultimate-guide-to-sboms/).

One thing early on in the dependency-management-data project was considering [generating Software Bill of Materials (SBOMs)](https://gitlab.com/tanna.dev/dependency-management-data/-/issues/55) from Renovate's data, so it could be consumed by other tools.

Although I've since added support for consuming SBOMs in dependency-management-data, I find it interesting to be able to take existing data forms and convert them to a more standardised form. I'm not actually sure if it _will_ be super useful to anyone, but it was fun to build, and has been interesting writing SBOMs as well as just consuming them.

As part of the v0.52.0 release of dependency-management-data, we can install [the `renovate-to-sbom` command](https://dmd.tanna.dev/commands/renovate-to-sbom/):

```sh
go install dmd.tanna.dev/cmd/renovate-to-sbom@latest
```

Then we can use the CLI to take exports from `renovate-graph`:

```sh
renovate-to-sbom 'renovate/*.json' --out-format spdx2.3+json
```

Or we can take debug logs from Renovate:

```sh
renovate-to-sbom 'debug.log' --out-format cyclonedx1.5+json
```

