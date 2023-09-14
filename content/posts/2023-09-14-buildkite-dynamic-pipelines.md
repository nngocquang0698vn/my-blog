---
title: "Building dynamic jobs with BuildKite"
description: "How to dynamically generate job configuration for BuildKite, while running inside a pipeline."
date: 2023-09-14T11:40:33+0100
tags:
- "blogumentation"
- "buildkite"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: buildkite-dynamic-pipelines
---
If you're using [Buildkite](https://buildkite.com/) for your builds, you may want to reduce duplication in your job's configuration by looping over certain variables, for instance "for each of these 5 environments, deploy the application".

Although you could use a shell script / loop through them in the actual pipeline's configuration, BuildKite's got some great functionality to [dynamically define a pipeline](https://buildkite.com/blog/how-to-build-ci-cd-pipelines-dynamically).

However, while reading through this, I didn't find it clear as to whether you could only define the dynamic logic when you're defining the job's steps in the UI/via the API, for instance:

```yaml
- command: ".buildkite/script.sh | buildkite-agent pipeline upload"
```

Fortunately that's not the case, and we can see below that - as long as `buildkite-agent` is available in the executing environment - you can call `buildkite-agent pipeline upload` to dynamically insert whatever pipeline you'd like into the build!

For instance, if we have our job's steps defined as:

```yaml
steps:
- command: buildkite-agent pipeline upload .buildkite/pipeline.yml
```

Then we can define `.buildkite/pipeline.yml` as:

```yaml
steps:
  - label: ":go: Build"
    command: "echo go build -o list-environments"
  - wait
  - label: ":aws: Determine environments to deploy to"
    commands:
      # if this was a built binary, not a shell script, we'd use `buildkite-agent artifact download` here
      - ./list-environments | .buildkite/dynamic-steps.sh | buildkite-agent pipeline upload
```

In this case, we would see the following resulting result:

![A screenshot of the BuildKite pipeline, which shows that the pipeline includes the steps already defined in the YAML, and then has two additional steps for environment deployment that have been dynamically inserted](https://media.jvt.me/f92a807fa2.png)

This can be found as [an example project on GitLab.com](https://gitlab.com/tanna.dev/jvt.me-examples/buildkite-dynamic-example).
