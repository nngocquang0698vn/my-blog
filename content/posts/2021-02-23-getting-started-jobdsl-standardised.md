---
title: "Getting Started With Jenkins Job DSL Plugin for Standardising Your Pipelines"
description: "A worked example of how to use Jenkins Job DSL to set up a standardised pipeline for Java libraries."
tags:
- jenkins
- job-dsl
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-02-23T22:27:54+0000
slug: "getting-started-jobdsl-standardised"
image: /img/vendor/jenkins.png
syndication:
- https://lobste.rs/s/ggbnyj/getting_started_with_jenkins_job_dsl
- https://news.ycombinator.com/item?id=26243856
---
# What is Job DSL?

The [Jenkins Job DSL plugin](https://github.com/jenkinsci/job-dsl-plugin), commonly referred to as "Job DSL", is a plugin that allows you to manage all your Jenkins jobs' configuration as code.

Now, I hear some of you readers say "I can do that already, I've got a `Jenkinsfile` I store in my project" - the issue is that you still need to configure a job in the Jenkins UI to read that `Jenkinsfile`. The perk of Job DSL is that it allows us to go one step further than that, as we can populate folders, jobs, and more, all through one manually created Jenkins job and a (git) repo.

By using a source controlled configuration, we can ensure that we always have a source of truth in-tree that we enforce code review on, and are able to use things like `git revert` if things go wrong.

# Why Standardise Pipelines

The best application I've found for Job DSL is to make your Jenkins pipelines standardised. This allows us to think about how we want to run pipelines in a way that's more common across repos/projects/teams, and to enforce teams to work in a similar way, with the aim not to remove any flexibility or room to experiment we want, but to simplify the build/test/deploy lifecycle for applications, and to make it much more effective to get work shipped to customers.

I've taken some learnings from a few years of Job DSL and distilled it into the below post, and am sure I'm going to improve the resource with future blog posts. These learnings have been based on building a build/test/deploy pipeline for AWS services, shared Java libraries, and recently, Chef cookbooks.

Using the shared Java libraries, which is the best of these examples, which all need the same basic functionality for getting these libraries shipped for internal consumption:

- Build a PR
- Build a build from our trunk branch
- Run security and license scanning

We have two flavours of our pipeline - Gradle and Maven, as each build tool has a slightly different way of working.

To create a new library, all we need to do is raise a PR to the Job DSL repo and once it's merged and the seed job has run, we'll have the new library with all its jobs set up, which is _so_ much easier than going into Jenkins and manually creating these jobs.

Aside: These pipeline flavours can also be used for controlling versions of software used - for instance, you could use a Chef pipeline for Chef Client 15, and when teams are comfortable making the major version jump to Chef Client 16, they could opt-in as and when they're ready.

# How?

Note that the examples for this article can be found in [<i class="fa fa-gitlab"></i>&nbsp;jamietanna/job-dsl-example](https://gitlab.com/jamietanna/job-dsl-example). You may find it easier to step through the commit history on the repo, as the diffs may be easier to read.

## Preparing Jenkins

To start off, we need to install [the Job DSL plugin](https://github.com/jenkinsci/job-dsl-plugin) onto our Jenkins server of choice.

Then, we want to create a top-level folder hierarchy, `Managed-Pipeline/Java`, which will house the managed pipeline we're creating for Java libraries.

Finally, we need to create a seed job, called `_Seed`, which we can create by Pipeline Job which executes from i.e. `https://gitlab.com/jamietanna/job-dsl-example` with Script Path `jobs/src/main/groovy/definitions/_seed.Jenkinsfile`.

## Preparing the Repo

To get going, we will want to simplify our local development by setting up a build tool. I'm more comfortable with Gradle, so I'll be using that, but you can use others if you'd prefer.

In our fresh repo, we need to get a `.gitignore`:

```sh
curl https://www.gitignore.io/api/java,gradle,intellij -Lo .gitignore
```

Next, we'll set up Gradle using the Gradle Wrapper, which removes the need for our Jenkins agent(s) to have a pre-installed version of Gradle:

```sh
gradle wrapper
```

We'll initialise our Gradle project with a `build.gradle`:

```groovy
plugins {
  id 'groovy'
}

allprojects {
  repositories {
    mavenCentral()
    maven {
      url 'https://repo.jenkins-ci.org/releases/'
    }
  }
}
```

Next, create the file `settings.gradle` with the following contents:

```groovy
include 'jobs'
```

To get IntelliJ to recognise our project (for ease of local development), we'll create the file `jobs/src/resources/idea.gdsl` with the contents from [the Job DSL docs for IDE Support](https://github.com/jenkinsci/job-dsl-plugin/wiki/IDE-Support).

Finally, we'll set up our jobs source set with `jobs/build.gradle`:

```groovy
apply plugin: 'groovy'

dependencies {
  implementation 'org.codehaus.groovy:groovy:2.5.14'
  implementation 'org.jenkins-ci.plugins:job-dsl-core:1.77'
}
```

At this point, we've got the key configuration in place to set up our project, and start writing configuration for our pipelines.

## Creating the Seed Job

The most important job for us to set up is our seed job, as that'll be in control of re-seeding our jobs. We'll start by creating that, by creating the file `jobs/seed.Jenkinsfile`:

```groovy
node {
  stage('Checkout code') {
    checkout scm
  }
  stage('Compile') {
    sh './gradlew clean :jobs:build'
  }
  stage('Seed Jenkins') {
    jobDsl targets: 'jobs/src/main/groovy/definitions/**/*.groovy',
      additionalClasspath: 'jobs/build/libs/*.jar' // this uses the build `jobs` JAR that contains our factory and other utilities
  }
}
```

With this in place, we could now run the job, and it would end up seeding nothing, as there are no job definitions yet.

To do this, we need to create the `jobs/src/main/groovy/definitions/_seed.groovy` file:

```groovy
import utilities.JobFactory

JobFactory.seedJob(this)
```

You'll note that we're using an abstraction that we've called the `JobFactory` which provides utilities to create the jobs. This simplifies the job configuration, and provides a nicer API for consumers to use when adding jobs of their own.

The `JobFactory` is created in `jobs/src/main/groovy/utilities/JobFactory.groovy`:

```groovy
package utilities

import javaposse.jobdsl.dsl.DslFactory
import javaposse.jobdsl.dsl.Folder
import javaposse.jobdsl.dsl.jobs.WorkflowJob

class JobFactory {
  private static final String HOST = 'git.example.com'
  private static final String PIPELINE_ORG = 'Managed-Pipelines'
  private static final String PIPELINE_REPO_NAME = 'Java'
  private static final String PIPELINE_REPO_BRANCH = 'master'
  private static final String PIPELINE_GIT_ORG_URL = "https://$HOST/$PIPELINE_ORG"
  private static final String PIPELINE_GIT_REPO_URL = "$PIPELINE_GIT_ORG_URL/$PIPELINE_REPO_NAME"
  private static final String SCM_CREDENTIALS_ID = '...'
  private static final String BASE_BUILD_PATH = 'Managed-Pipeline'

  static WorkflowJob seedJob(DslFactory factory) {
    factory.pipelineJob("$BASE_BUILD_PATH/_Seed") {
      description 'Pipeline to seed the Managed Pipeline jobs for Java projects'
      definition {
        cpsScm {
          scm {
            git {
              remote {
                url PIPELINE_GIT_REPO_URL
              }
              branch PIPELINE_REPO_BRANCH
            }
            scriptPath 'jobs/seed.Jenkinsfile'
          }
        }
      }
    }
  }
}
```

Now we've set this up, we can run our seed job and validate that our seed itself is now managed by Job DSL:

```
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Seed Jenkins)
[Pipeline] jobDsl
Processing DSL script jobs/src/main/groovy/definitions/_seed.groovy
Added items:
    GeneratedJob{name='Managed-Pipeline/Java/_Seed'}
[Pipeline] }
[Pipeline] // stage
```

(Note that Script Security on Jenkins may cause you issues - please refer to the [Job DSL Script Security documentation](https://github.com/jenkinsci/job-dsl-plugin/wiki/Script-Security) for more info if you're seeing compilation errors  )

## Creating our library jobs

Next, we need to have some way of creating jobs for our libraries. For now, we'll create just a multibranch pipeline, but we could add pipelines for things like security scanning on a schedule, too.

As our libraries are present in different organisations in our Git hosting platform, we want to use some conventions to better organise our pipelines. For instance, for the library in `https://git.example.com/org-name/example-library`, we'd create the file `jobs/src/main/groovy/definitions/org_name/example_library.groovy` (note that we need to use underscores for separators, as required by Job DSL):

```
import utilities.DefaultPipeline
import utilities.JobFactory

JobFactory factory = new JobFactory(this, 'org-name', 'library-name', DefaultPipeline.GRADLE)
factory.createFolder()
factory.createMultibranchPipeline()
```

Here, our factory gives us the ability to scope all the jobs for our library, and the standard pipeline for Gradle projects.

To start with, we need to add our `jobs/src/main/groovy/utilities/DefaultPipeline.groovy`:

```groovy
package utilities

enum DefaultPipeline {
  GRADLE,
}
```

To make this work, we need to extend our `JobFactory`:

```groovy
package utilities

import javaposse.jobdsl.dsl.DslFactory
import javaposse.jobdsl.dsl.Folder
import javaposse.jobdsl.dsl.jobs.MultibranchWorkflowJob
import javaposse.jobdsl.dsl.jobs.WorkflowJob

class JobFactory {

  // ...

  private final DslFactory factory
  private final String gitOrgName
  private final String gitRepoName
  private final DefaultPipeline pipeline
  private final String gitOrgUrl
  private final String gitRepoUrl
  private final String orgBaseBuildPath
  private final String projectBaseBuildPath

  JobFactory(DslFactory factory, String gitOrgName, String gitRepoName, DefaultPipeline pipeline) {
    this.factory = factory
    this.gitOrgName = gitOrgName
    this.gitRepoName = gitRepoName
    this.pipeline = pipeline

    this.gitOrgUrl = "https://$HOST/$gitOrgName"
    this.gitRepoUrl = "${this.gitOrgUrl}/$gitRepoName"
    this.orgBaseBuildPath = "$BASE_BUILD_PATH/$gitOrgName"
    this.projectBaseBuildPath = "$orgBaseBuildPath/$gitRepoName"
  }

  Folder createFolder() {
    factory.folder(orgBaseBuildPath) {
      description("Jobs for building Java projects in the $gitOrgName organisation")
    }
    factory.folder(projectBaseBuildPath) {
      description("Jobs for building the $gitRepoName project")
    }
  }

  MultibranchWorkflowJob createMultibranchPipeline() {
    def jobLocation = "$projectBaseBuildPath/Pipeline"
    def scriptPath = "pipelines/${pipeline.name().toLowerCase()}/multibranch.groovy"

    createMultibranchPipelineDefinition(jobLocation, scriptPath)
  }

  private MultibranchWorkflowJob createMultibranchPipelineDefinition(String jobLocation, String script) {
    factory.multibranchPipelineJob(jobLocation) {
      branchSources {
        /* for example, when using GitHub */
        github {
          apiUri('...')
          buildForkPRMerge(true)
          buildOriginBranch(true)
          buildOriginBranchWithPR(true)
          buildOriginPRMerge(true)
          checkoutCredentialsId(SCM_CREDENTIALS_ID)
          repoOwner(gitOrgName)
          repository(gitRepoName)
          scanCredentialsId(SCM_CREDENTIALS_ID)
          /* id required to be unique, otherwise triggers won't work across duplicates in your Jenkins instance */
          id("$PIPELINE_ORG-$PIPELINE_REPO_NAME-$gitOrgName-$gitRepoName-mb")
        }
      }
      factory {
        remoteJenkinsFileWorkflowBranchProjectFactory {
          scriptPath(script)
          localMarker('') /* everything is valid */
          remoteJenkinsFileSCM {
            gitSCM {
              userRemoteConfigs {
                userRemoteConfig {
                  name('origin')
                  url(PIPELINE_GIT_REPO_URL)
                  refspec("+refs/heads/$PIPELINE_REPO_BRANCH:refs/remotes/origin/$PIPELINE_REPO_BRANCH")
                  credentialsId(SCM_CREDENTIALS_ID)
                }
              }
              branches {
                branchSpec {
                  name(PIPELINE_REPO_BRANCH)
                }
              }
              browser {}
              gitTool('/usr/bin/env git')
            }
          }
        }
      }
    }
  }
}
```

Running this now will populate our jobs for our library:

```
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Seed Jenkins)
[Pipeline] jobDsl
Processing DSL script jobs/src/main/groovy/definitions/_seed.groovy
Processing DSL script jobs/src/main/groovy/definitions/org_name/example_library.groovy
Added items:
    GeneratedJob{name='Managed-Pipeline/Java/org-name/example-library/Pipeline'}
    GeneratedJob{name='Managed-Pipeline/Java/org-name/example-library'}
    GeneratedJob{name='Managed-Pipeline/Java/jitpack'}
Existing items:
    GeneratedJob{name='Managed-Pipeline/Java/_Seed'}
[Pipeline] }
[Pipeline] // stage
```

## Implementing the Pipeline

Now we've populated the jobs, we need to actually create the pipelines that will run for jobs.

Because we want to make it easier to keep our pipelines consistent, we can again lean on abstraction, and create a `BuildFactory` in `src/buildutilities/BuildFactory.groovy`:

```groovy
package buildutilities

interface BuildFactory {
  def checkoutScm()
  def clean()
  def compile()
  def test()
  def staticAnalysis()
  def publish()
}
```

This then allows us to implement this for our Gradle pipeline as `src/buildutilities/GradleBuildFactory.groovy`, and make it simple to implement other flavours, too:

```groovy
package buildutilities

class GradleBuildFactory implements BuildFactory {

  def jenkins

  GradleBuildFactory(jenkins) {
    this.jenkins = jenkins
  }

  def checkoutScm() {
    execute {
      stage('Checkout') {
        checkout scm
      }
    }
  }

  def clean() {
    execute {
      stage('Clean') {
        sh './gradlew clean'
      }
    }
  }

  def compile() {
    execute {
      stage('Compile') {
        sh './gradlew compileJava'
      }
    }
  }

  def test() {
    execute {
      stage('Test') {
        try {
          sh './gradlew test'
        } finally {
          junit '**/build/test-results/**/*.xml'
        }
      }
    }
  }

  def staticAnalysis() {
    execute {
      stage('Static Analysis') {
        // i.e. sh './gradlew sonarqube'
      }
    }
  }

  def publish() {
    execute {
      if ('master' == env.BRANCH_NAME) {
        stage('Publish') {
          // withCredentials(...)
          sh './gradlew publish'
        }
      }
    }
  }

  def execute(stage) {
    stage.delegate = jenkins
    stage()
  }
}
```

Now we've implemented our Gradle implementation, we need to create the pipeline file in `pipelines/gradle/multibranch.groovy`:

```groovy
@Library('managed-java-pipeline-library')
import buildutilities.BuildFactory
import buildutilities.GradleBuildFactory

BuildFactory factory = new GradleBuildFactory(this)

node {
  docker.image('openjdk:8-alpine').inside('') {
    factory.checkoutScm()
    factory.clean()
    factory.compile()
    factory.test()
    factory.staticAnalysis()
    factory.publish()
  }
}
```

We need to update our `settings.gradle` to add the `pipelines` sources, so i.e. IntelliJ will recognise the files:

```groovy
include 'jobs'
include 'pipelines'
```

Finally, we need to add a pipeline library, which will allow us to access the classes in `buildutilities`. To do this, we need to add a pipeline library on the `Java` folder:

- Name: `managed-java-pipeline-library`
- Default Version: `master`
- Load implicitly: unticked (leave off)
- SCM: i.e. `https://gitlab.com/jamietanna/job-dsl-example`

And it's that simple! Now we can go and trigger our jobs to build them, and they'll now be running against the pipeline.

# Questions?

I hope this was helpful showing you an example of how to get started with building out standardised pipelines with Jenkins, heavily relying on configuration-as-code, and using the right level of abstractions and code reusage to make it straightforward to onboard, in this example, a new library to our standardised pipeline.

It truly is amazing the difference it makes to not have to worry about your jobs getting stale, or folks manually editing jobs, because you can now really lock down configuration to administrators only, and require that only code reviewed configuration is usable - I never want to go back to the old ways!

Any questions? Please do reach out, contact details are in the footer.
