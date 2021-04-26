---
title: "Building a Multibranch Pipeline on a Schedule"
description: "A more convenient solution for setting up periodic rebuilds of certain branches in a Jenkins Multibranch pipelines."
tags:
- blogumentation
- jenkins
- job-dsl
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-04-26T09:12:00+0100
slug: "jenkins-schedule-multibranch"
image: /img/vendor/jenkins.png
---
There are cases you want to rebuild your Multibranch projects on a schedule, for instance if there are regular updates to the pipeline, but not to the project itself, so you want to make sure that the projects still work, or to ensure that you're constantly rebuilding and running compliance checks against the latest version of the code, especially if there's no active development.

I'd looked at the options, and although [there are solutions by putting it into the Multibranch's `Jenkinsfile`](https://stackoverflow.com/questions/39168861/build-periodically-with-a-multi-branch-pipeline-in-jenkins), I found that this wasn't the best solution, because the job's configuration only becomes active if that branch has been built, and can look a bit awkward.

I found a more elegant solution was to create a separate job that runs on a scheduled and triggers the branches we want, which allows us to control this more easily, as well as easily disabling any scheduling across the board.

Let's say that we want to build the `main` branch on our repo, and the `develop` branch if one exists, and that the Multibranch pipeline is located at `Pipelines/Multibranch`.

If we were using Job DSL, we would use the following definition for the schedule job:

```groovy
factory.pipelineJob('Pipelines/_Schedule_Multibranch') {
  definition {
    cpsScm {
      triggers {
        cron('@weekly')
      }
      scm {
        git {
          remote {
            url '...'
          }
        }
        scriptPath 'jobs/scheduled.Jenkinsfile'
      }
    }
  }
}
```

Then `jobs/scheduled.Jenkinsfile` has the definition:

```groovy
build job: 'Multibranch/main', wait: false
try {
  build job: 'Multibranch/develop', wait: false
} catch (Exception e) {
  // allow failure, as it could not exist
}
```
