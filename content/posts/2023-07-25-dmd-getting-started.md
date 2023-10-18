---
title: Getting started with Dependency Management Data
description: "How you can get started using Dependency Management Data in 3 commands."
tags:
- dependency-management-data
date: 2023-07-25T17:49:37+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: dmd-getting-started
---
**Note**: This blog post has been replaced by [the official getting started guide for dependency-management-data](https://dmd.tanna.dev/cookbooks/getting-started/). I've kept a copy here for posterity, but it's worthwhile checking out the up-to-date docs now, as this will not be updated in the future.

This is a companion post to go alongside [my talk writeup](https://www.jvt.me/posts/2023/07/25/dmd-getting-started/) of [my talk at DevOpsNotts July 2023](https://www.meetup.com/devops-notts/events/293929326/) about [the dependency-management-data (DMD) project](https://dmd.tanna.dev)

This is intended as a quick setup guide, rather than an exhaustive jump into what it is and how it works - if you'd like that, check out the talk writeup 👆

Want to know a bit more in-depth what it is and how it works? Check out [the more-indepth writeup](https://www.jvt.me/posts/2023/07/25/dmd-getting-started/).

## TL;DR extraordinaire

At a minimum, you need to:

- retrieve some data, for instance via [renovate-graph](https://gitlab.com/tanna.dev/renovate-graph)
  - note that you do _not_ need to be already using Renovate to use this!
- create the SQLite database for dependency-management-data
- import the data

We can do this by running:

```sh
go install dmd.tanna.dev/cmd/dmd@latest

# produce some data that DMD can import, for instance via renovate-graph
npx @jamietanna/renovate-graph@latest --token $GITHUB_TOKEN your-org/repo another-org/repo
# or for GitLab
env RENOVATE_PLATFORM=gitlab npx @jamietanna/renovate-graph@latest --token $GITLAB_TOKEN your-org/repo another-org/nested/repo

# set up the database
dmd db init --db dmd.db
# import renovate-graph data
dmd import renovate --db dmd.db 'out/*.json'
# then you can start querying it
sqlite3 dmd.db 'select count(*) from renovate'
```

## Retrieving the data

As noted above, we need to retrieve data to be imported into DMD. For dependencies, I'd recommend using [renovate-graph](https://gitlab.com/tanna.dev/renovate-graph), which uses [Renovate](https://docs.renovatebot.com) as the engine for retrieving package data.

We can run the following:

```sh
# optional, allows renovate-graph to retrieve the `current_version` column, as well as populate the `renovate_updates` table
export RG_INCLUDE_UPDATES='true'

# produce some data that DMD can import, for instance via renovate-graph
npx @jamietanna/renovate-graph@latest --token $GITHUB_TOKEN jamietanna/jamietanna deepmap/oapi-codegen
# or for GitLab
env RENOVATE_PLATFORM=gitlab npx @jamietanna/renovate-graph@latest --token $GITLAB_TOKEN tanna.dev/serve jamietanna/tidied
```

If you are looking at AWS infrastructure, check out the [README for endoflife-checker](https://gitlab.com/tanna.dev/endoflife-checker) which explains in more details how to pull AWS data.

## Creating the database and importing the data

Once `renovate-graph` has executed, you'll see an `out` directory with one file per repo.

First, we'll create the database:

```sh
# or any name, really
dmd db init --db dmd.db
```

Then, we need to import the data. Notice the quotes around the argument to avoid shell globbing

```sh
dmd import renovate --db dmd.db 'out/*.json'
```

Now our database is ready to go 👏

## Generating missing data (optional)

This is an optional step, but for ecosystems like the Java, the full dependency tree may not be immediately available.

We can run the following to (try) to fill in the missing dependency tree:

```sh
# note that this can take several minutes depending on how many dependencies you have!
dmd db generate missing-data --db dmd.db
```

## Generating advisories (optional)

This is an optional step, but allows us to get some more meaningful information about our dependencies.

We can run the following to set up our advisories:

```sh
# optionally fetch community-sourced custom advisories
dmd contrib download

# then generate advisories for all our packages
# note that this can take several minutes depending on how many dependencies you have!
dmd db generate advisories --db dmd.db
```

## Running some queries

Now we've got the data available, we can start to query it.

It's recommended you find your SQLite browser of choice and try the following queries:

```sql
-- how many packages have been ingested via renovate-graph
select count(*) from renovate

-- how many pending package updates have been ingested via renovate-graph
select count(*) from renovate_updates

-- how many packages have been ingested via dependabot-graph
select count(*) from dependabot

-- what are your most popular 10 transitive Go dependencies?
select
  distinct package_name,
  count(*)
from
  renovate,
  json_each(dep_types) as dep_type
where
  package_manager = 'gomod'
  and dep_type.value = 'indirect'
group by
  package_name
order by
  count(*) DESC
limit 10;

```

And from the `dmd` CLI, we can also run the following:

```sh
# if you've generated the advisories data
dmd report advisories --db dmd.db

dmd report mostPopularDockerImages --db dmd.db
dmd report mostPopularPackageManagers --db dmd.db
```

## Example

Interested in seeing what it's like with some pre-baked data? The [example project](https://gitlab.com/tanna.dev/dependency-management-data-example) has a web app [hosted on Fly.io](https://dependency-management-data-example.fly.dev/) that contains a lot of public repositories from GitHub and GitLab which can give you an idea based on some pre-seeded data.
