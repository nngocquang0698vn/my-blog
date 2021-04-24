---
title: "Disabling a Multibranch Pipeline using Job DSL"
description: "How to disable all branches of a `MultibranchWorkflowJob` with Jenkins Job DSL."
tags:
- blogumentation
- jenkins
- job-dsl
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-04-24T19:44:54+0100
slug: "job-dsl-disable-multibranch"
image: /img/vendor/jenkins.png
---
Using Job DSL to manage your pipelines is useful, but sometimes you want to not run a pipeline, for instance so it doesn't trigger in your [test environment]({{< ref 2021-04-06-job-dsl-test-environment >}}).

In the Jenkins UI, you can click a `Disable` button which disables the project, but interestingly this doesn't change the job's XML behind the scenes, so it seems to be controlled through some other Jenkins state.

This means we need to think a bit out of the box to do this, which led me to the use of the `excludes` property, where we can exclude all the branches that are discovered:

```groovy
factory.multibranchPipelineJob(jobLocation) {
  branchSources {
    /* for example */
    git {
      // other config
      excludes('*')
    }

    /* for example, when using GitHub */
    github {
      // other config
      excludes('*')
    }

```

I'd also recommend, in the cases we disable the pipeline, we update the description of the job to make it clear it's disabled.
