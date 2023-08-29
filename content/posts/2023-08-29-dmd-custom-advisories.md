---
title: "Custom Advisories: the unsung hero of dependency-management-data"
description: "How to use custom advisories with dependency-management-data to track packages that your organisation may not want to use."
tags:
- dependency-management-data
date: 2023-08-29T11:02:27+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: dmd-custom-advisories
---
As part of my work on [dependency-management-data](https://dmd.tanna.dev), I've found that having access to the raw dependency data for your organisation is a powerful thing. But on top of just having the data, being able to mould the data to your organisation's needs is even more important.

At Deliveroo, I was part of the Go Team, a group of folks working to shape and improve the usage of Go across the organisation. As part of this, we had some libraries that we tried to steer away from, for instance because there were known vulnerabilities in them, or it was an internally developed library that was no longer being maintained.

To get an understanding of which teams were affected and would need upgrades, I found myself re-writing the same SQL queries against the database, which could at least be shared around, but was suboptimal to keep tweaking the same base query.

In June, I decided enough was enough, and I added the ability to define custom Advisories. These integrated in with the existing Advisories concept - a way of flagging up package(s) for having known issues around maintenance, security, or otherwise - but provided a means to define your own, without modifying the code in dependency-management-data.

These advisories are defined in an SQLite table `advisories`, which allows you to insert a row like:

```sql
-- examples taken from https://gitlab.com/tanna.dev/dependency-management-data-contrib/-/blob/main/advisories/go.sql and https://gitlab.com/tanna.dev/dependency-management-data-contrib/-/blob/main/advisories/docker.sql respectively
INSERT INTO advisories (
  package_pattern,
  package_manager,
  version,
  version_match_strategy,
  advisory_type,
  description
) VALUES
(
  'github.com/pkg/errors',
  'gomod',
  NULL,
  NULL,
  'UNMAINTAINED',
  'pkg/errors was archived in 2021, and is unmaintained since'
),
(
  'public.ecr.aws/lambda/go',
  'docker',
  '1',
  'EQUALS',
  'DEPRECATED',
  'Amazon does not recommend the use of the v1 Go image, which is based off of Amazon Linux (v1) https://docs.aws.amazon.com/lambda/latest/dg/go-image.html#go-image-v1'
)
;
```

This produces a report that looks like:

<table>
  <thead>
    <tr>
      <th>Platform</th>
      <th>Organisation</th>
      <th>Repo</th>
      <th>Package</th>
      <th>Version</th>
      <th>Dependency Types</th>
      <th>Advisory Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tr>
    <td>github</td>
    <td>deepmap</td>
    <td>oapi-codegen</td>
    <td>github.com/pkg/errors</td>
    <td>v0.9.1 / v0.9.1</td>
    <td>["indirect"]</td>
    <td>UNMAINTAINED</td>
    <td>pkg/errors was archived in 2021, and is unmaintained since</td>
  </tr>
</table>

By being an arbitrary table, users can insert their own rules as necessary, giving them the visibility over which package(s) they feel shouldn't be in use, or that at least should be considered.

In July, I followed this up with the [dependency-management-data-contrib project](https://gitlab.com/tanna.dev/dependency-management-data-contrib/), which allows for community-sourced package advisories to be shared with all users of dependency-management-data, and was borne out of creating some package advisories at Deliveroo that weren't specific to Deliveroo's needs and therefore could be Open Source'd.

Users of dependency-management-data have found this to be a great feature, and I'm sure you may too!
