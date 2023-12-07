---
title: "You can now interact with dependency-management-data using GraphQL"
description: "Announcing the release of the GraphQL API for dependency-management-data."
tags:
- dependency-management-data
- graphql
date: 2023-12-07T21:21:50+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: dmd-graphql
image: https://media.jvt.me/7d569c90fd.png
---
When I first started working on [dependency-management-data](https://dmd.tanna.dev), I wanted to hold off creating an API for the data until I really understood how it'd be used. I instead focussed on improving the database layer, focussing on the actual data, and understanding what was commonly queried, leading to the web application for DMD that provided an SQL frontend using [Datasette](https://datasette.io/).

Towards the end of my time at Deliveroo, we were starting to understand some of the common usecases we had for the data, and were starting to look at making it possible to take dependency-management-data and integrate it with some of our other internal systems, which required we add an API on top of it.

We decided that a GraphQL API was the best way to do this, so [raised an issue for it](https://gitlab.com/tanna.dev/dependency-management-data/-/issues/151) and hoped that we'd get around to it at some point. A couple of weeks later, my excellent (now ex-)colleague <span class="h-card"><a class="u-url" href="https://www.linkedin.com/in/keithlyall">Keith</a></span> had already made some great progress with it.

It's taken a bit of back-and-forth - not helped at least with the speed that I've been making changes to dependency-management-data, inflicting several breaking changes and new datasources that have made landing the Merge Request a bit of a moving target - but as of tonight in the [v0.61.0](https://gitlab.com/tanna.dev/dependency-management-data/-/tags/v0.61.0) release, we now have support for GraphQL 👏🏼

You can check out the schema documentation [on the documentation site](https://dmd.tanna.dev/graphql/) and play with the [GraphQL playground on the example application](https://dependency-management-data-example.fly.dev/graphql-playground).

As well as the existing [`dmd-web`](https://dmd.tanna.dev/commands/dmd-web/) command that adds a `/graphql` route, you can also use the new [`dmd-graph`](https://dmd.tanna.dev/commands/dmd-graph/) CLI to run just the GraphQL API.

Note that until [support is added](https://gitlab.com/tanna.dev/dependency-management-data/-/issues/172), there's no authentication or authorization support, so beware running it as an internet-facing application.

I look forward to hearing about any use-cases you've got that this enables, as well as any other features that'd be useful aside from [those already on the issue tracker](https://gitlab.com/tanna.dev/dependency-management-data/-/issues/?label_name%5B%5D=graphql).
