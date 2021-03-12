---
title: "Ensuring Consistent Code Style with Job DSL Repos"
description: "How to make sure that your Job DSL configuration repos are managed with consistent code style."
tags:
- jenkins
- job-dsl
- spotless
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-03-12T19:05:56+0000
slug: "jobdsl-spotless"
image: /img/vendor/jenkins.png
---
We should generally treat our [Job DSL projects]({{< ref 2021-02-23-getting-started-jobdsl-standardised >}}) with the same level of standards that our production code would be fulfilling.

Without enforcing code style, it's up to code review or engineers "just knowing" the changes to make which is a bit more of a burden than needs to be had, especially as there are tools like [Spotless](https://github.com/diffplug/spotless) which fill this gap so perfectly, especially as [you can locally configure Spotless to always run]({{< ref 2020-05-15-gradle-spotless >}}), ensuring your code style is always consistent.

This is also really important because you may have teams who are coming with different tech backgrounds, or who may not be as used to working in Groovy code, which our pipelines will be based on.

# Applying Spotless

So how do we go about setting it up? In our `build.gradle`, we can make the following changes:

```diff
 plugins {
   id 'groovy'
+  id 'com.diffplug.spotless' version '5.11.0'
 }
+
+spotless {
+  groovy {
+    target '**/*.groovy', '**/*.Jenkinsfile'
+    greclipse()
+    trimTrailingWhitespace()
+    indentWithSpaces(2)
+    endWithNewline()
+  }
+  groovyGradle {
+    target '**/*.gradle'
+    greclipse()
+    trimTrailingWhitespace()
+    indentWithSpaces(2)
+    endWithNewline()
+  }
+}

 allprojects {
+  apply plugin: 'com.diffplug.spotless'

   repositories {
     mavenCentral()
     maven {
       url 'https://repo.jenkins-ci.org/releases/'
     }
   }
 }
```

The above code style choices are my preference, but you can tweak them as you need to. This allows us to keep all our Groovy, Jenkins jobs and Gradle configuration to the same standard.

We also `apply` the plugin across all projects, so any subprojects i.e. `jobs`, have code style enforced, too.

You'll notice that immediately after applying these changes, running a `./gradlew clean build` will fail, as you need to apply the changes. We can do this with `./gradlew spotlessApply`.

# Adding a Multibranch Pipeline for this Repo

Although not super necessary, I'd really recommend having a multibranch pipeline set up for your Job DSL configuration, which will allow anyone raising changes to the repo to make sure they're compliant with the code style, as well as making sure that the code at least compiles.

We need to set this up in `jobs/src/main/groovy/definitions/_seed.groovy` to add our new job:

```diff
 import utilities.JobFactory

 JobFactory.seedJob(this)
+JobFactory.seedJobPrBuilder(this)
```

Which requires our `jobs/src/main/groovy/utilities/JobFactory.groovy` be updated to add the new multibranch pipeline:

```groovy
static MultibranchWorkflowJob seedJobPrBuilder(DslFactory factory) {
  factory.multibranchPipelineJob("$BASE_BUILD_PATH/_Seed_PR_Builder") {
    branchSources {
      /* for example, when using GitHub */
      github {
        apiUri('...')
        buildForkPRMerge(true)
        buildOriginBranch(true)
        buildOriginBranchWithPR(true)
        buildOriginPRMerge(true)
        checkoutCredentialsId(SCM_CREDENTIALS_ID)
        repoOwner(PIPELINE_ORG)
        repository(PIPELINE_REPO_NAME)
        scanCredentialsId(SCM_CREDENTIALS_ID)
        /* id required to be unique, otherwise triggers won't work across duplicates in your Jenkins instance */
        id("$PIPELINE_ORG-$PIPELINE_REPO_NAME-seed-mb")
      }
    }
    factory {
      remoteJenkinsFileWorkflowBranchProjectFactory {
        scriptPath('jobs/build_seed.Jenkinsfile')
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
```

And finally, we want our `jobs/build_seed.Jenkinsfile` to simply build the project:

```groovy
node {
  stage('Checkout code') {
    checkout scm
  }
  stage('Compile') {
    sh './gradlew clean build'
  }
}
```

And that's it! We now will be able to get our jobs repo managed with a bit more quality, and can now set up PR builds on contributed changes!
