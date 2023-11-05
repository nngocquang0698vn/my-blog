---
title: "Using dependency-management-data with npm's SPDX and CycloneDX SBOM export functionality"
description: "How to get started with npm's SBOM export functionality with dependency-management-data."
tags:
- dependency-management-data
- sbom
- npm
date: 2023-11-05T20:45:17+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: npm-sbom-dmd
image: https://media.jvt.me/d4aced34cf.png
---
In [today's](https://devopsweeklyarchive.com/671/) [DevOps Weekly](https://www.devopsweekly.com/), it was mentioned that npm recently added support for [exporting Software Bill of Materials (SBOMs)](https://docs.npmjs.com/cli/v10/commands/npm-sbom/).

This was shipped as part of [npm's v10.2.0 release](https://github.com/npm/cli/releases/tag/v10.2.0) at the beginning of October, which we can use via:

```sh
# either
npm sbom --sbom-format spdx > renovate-graph.spdx.json
# or
npm sbom --sbom-format cyclonedx > renovate-graph.cyclonedx.json
```

Then, as per the [Getting Started with SBOM data cookbook](https://dmd.tanna.dev/cookbooks/getting-started-sbom/), we can run:

```sh
# set up the database
dmd db init --db dmd.db
# whitespace added for readability only
dmd import sbom --db dmd.db renovate-graph.spdx.json \
  --platform gitlab \
  --organisation tanna.dev \
  --repo renovate-graph
# or
dmd import sbom --db dmd.db renovate-graph.cyclonedx.json \
  --platform gitlab \
  --organisation tanna.dev \
  --repo renovate-graph
```

From here, we can then run queries such as:

```sql
-- how many dependencies do we have on Octokit libraries?
select count(*) from sboms where package_name like '@octokit/%'
```

While playing around with this, I noticed [a bug](https://gitlab.com/tanna.dev/dependency-management-data/-/merge_requests/147) in dependency-management-data's SPDX support, as well as a couple of bugs in npm's SBOM support too:

- [SBOM generation for SPDX generates invalid format for licenses - `Invalid type. Expected: string, given: object`](https://github.com/npm/cli/issues/6966)
- [SBOM generation for CycloneDX generates duplicate dependencies](https://github.com/npm/cli/issues/6967)

But it's great to have support natively in `npm`, and I'm looking forward to more support of SBOMs!
