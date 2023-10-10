---
title: "Listing environment variables used to trigger a Buildkite pipeline"
description: "How to use Buildkite's GraphQL API to list the environment variables provided to trigger a pipeline."
date: 2023-10-10T13:25:40+0100
tags:
- "blogumentation"
- "buildkite"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: buildkite-what-env-trigger
---
If you're using [Buildkite](https://buildkite.com/) for your builds, you may sometimes want to work out what environment variables were used to trigger a given build.

Although the Web UI allows you to see the environment variables a given step in the build takes, you can't see the job's environment variables itself, which can be frustrating if you're using them to allow parameterising your builds.

Fortunately, Buildkite provides a GraphQL API, so we can run the following query:

```graphql
query environmentVariables {
  build(slug: "example/something/1234") {
     env
  }
}
```

This would then output, for instance:

```json
{
  "data": {
    "build": {
      "env": [
        "USER=jamie.tanna",
        "AWS_REGION=eu-west-1"
      ]
    }
  }
}
```
