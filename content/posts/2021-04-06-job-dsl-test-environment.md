---
title: "Setting up a Test Environment for Job DSL Projects"
description: "How to tweak your Job DSL configuration to allow working with test environments, to validate jobs configure correctly."
tags:
- jenkins
- job-dsl
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-04-06T09:43:25+0100
slug: "job-dsl-test-environment"
image: /img/vendor/jenkins.png
---
There's only so much verification we can do with a Job DSL repo before we need to execute it against a real Jenkins server, due to the way it interacts with the Jenkins server's configuration and any other plugins installed.

Sure, we can get a local test environment build with i.e. Docker to allow us to more easily test your changes, but if it's not running on your actual Jenkins instance, we still won't get the confidence we want in what's going to happen.

We can get pretty close with reproducing the environment locally, but that has a cost of how much maintenance we want to undertake, and will still have gaps like permissions to deploy to infrastructure, or connectivity to certain servics.

As well as this, it's also quite awkward to test a new set of changes, as the repo generally hardcodes the main branch, like `master`, which means that you need to manually go through the UI and update the branches, which I've found to be incredibly painful.

There are two good solutions to this, and some tweaks we can make to our Job DSL to allow us to test much more easily.

The below examples will be based off the code produced by [Getting Started With Jenkins Job DSL Plugin for Standardising Your Pipelines]({{< ref 2021-02-23-getting-started-jobdsl-standardised >}}).

# Multiple Jenkins Servers

If we're fortunate to have the ability to set up a QA Jenkins server, which mirrors the Production server, and is generally deployed into a similar i.e. Cloud environment, this works really nicely.

Because we're using a very similar setup, we can use the same folder hierarchy for the created jobs, which means things look very similar between servers.

For this example, we'll say that Production uses the hostname `jenkins.internal` whereas QA uses `jenkins.test.internal`.

This allows us to modify our `jobs/src/main/groovy/utilities/JobFactory.groovy` to detect when we're running in QA, and if so, allow a branch to be used to configure jobs, instead of the hardcoded `master`:

```diff
diff --git jobs/src/main/groovy/utilities/JobFactory.groovy jobs/src/main/groovy/utilities/JobFactory.groovy
index 81dd0a9..7f6d888 100644
--- jobs/src/main/groovy/utilities/JobFactory.groovy
+++ jobs/src/main/groovy/utilities/JobFactory.groovy
@@ -9,7 +9,7 @@ class JobFactory {
   private static final String HOST = 'git.example.com'
   private static final String PIPELINE_ORG = 'Managed-Pipelines'
   private static final String PIPELINE_REPO_NAME = 'Java'
-  private static final String PIPELINE_REPO_BRANCH = 'master'
+  private static final String DEFAULT_PIPELINE_REPO_BRANCH = 'master'
   private static final String PIPELINE_GIT_ORG_URL = "https://$HOST/$PIPELINE_ORG"
   private static final String PIPELINE_GIT_REPO_URL = "$PIPELINE_GIT_ORG_URL/$PIPELINE_REPO_NAME"
   private static final String SCM_CREDENTIALS_ID = '...'
@@ -25,7 +25,7 @@ class JobFactory {
               remote {
                 url PIPELINE_GIT_REPO_URL
               }
-              branch PIPELINE_REPO_BRANCH
+              branch getPipelineBranch(factory)
             }
             scriptPath 'jobs/seed.Jenkinsfile'
           }
@@ -62,13 +62,13 @@ class JobFactory {
                 userRemoteConfig {
                   name('origin')
                   url(PIPELINE_GIT_REPO_URL)
-                  refspec("+refs/heads/$PIPELINE_REPO_BRANCH:refs/remotes/origin/$PIPELINE_REPO_BRANCH")
+                  refspec("+refs/heads/${getPipelineBranch(factory)}:refs/remotes/origin/${getPipelineBranch(factory)}")
                   credentialsId(SCM_CREDENTIALS_ID)
                 }
               }
               branches {
                 branchSpec {
-                  name(PIPELINE_REPO_BRANCH)
+                  name(getPipelineBranch(factory))
                 }
               }
               browser {}
@@ -80,6 +80,21 @@ class JobFactory {
     }
   }

+  private static String getPipelineBranch(DslFactory factory) {
+    if (isTestEnvironment(factory)) {
+      return getEnvironment(factory, 'SEED_BRANCH')
+    }
+    return DEFAULT_PIPELINE_REPO_BRANCH
+  }
+
+  private static boolean isTestEnvironment(DslFactory factory) {
+    return getEnvironment(factory, 'JENKINS_URL').contains('.test.')
+  }
+
+  private static String getEnvironment(DslFactory factory, String name) {
+    return factory.binding.getVariable(name)
+  }
+
   private final DslFactory factory
   private final String gitOrgName
   private final String gitRepoName
@@ -114,7 +129,7 @@ class JobFactory {
             libraryConfiguration {
               name 'managed-java-pipeline-library'
               implicit false
-              defaultVersion PIPELINE_REPO_BRANCH
+              defaultVersion getPipelineBranch(factory)
               retriever {
                 modernSCM {
                   scm {
@@ -167,13 +182,13 @@ class JobFactory {
                 userRemoteConfig {
                   name('origin')
                   url(PIPELINE_GIT_REPO_URL)
-                  refspec("+refs/heads/$PIPELINE_REPO_BRANCH:refs/remotes/origin/$PIPELINE_REPO_BRANCH")
+                  refspec("+refs/heads/${getPipelineBranch(factory)}:refs/remotes/origin/${getPipelineBranch(factory)}")
                   credentialsId(SCM_CREDENTIALS_ID)
                 }
               }
               branches {
                 branchSpec {
-                  name(PIPELINE_REPO_BRANCH)
+                  name(getPipelineBranch(factory))
                 }
               }
               browser {}
```

Which requires we update our `jobs/seed.Jenkinsfile` to pass the `SEED_BRANCH` variable through:

```diff
diff --git jobs/seed.Jenkinsfile jobs/seed.Jenkinsfile
index 6b1f132..9d35f92 100644
--- jobs/seed.Jenkinsfile
+++ jobs/seed.Jenkinsfile
@@ -7,6 +7,7 @@ node {
   }
   stage('Seed Jenkins') {
     jobDsl targets: 'jobs/src/main/groovy/definitions/**/*.groovy',
-    additionalClasspath: 'jobs/build/libs/*.jar'
+    additionalClasspath: 'jobs/build/libs/*.jar',
+    additionalParameters: [SEED_BRANCH: scm.branches[0].name] // via https://www.jvt.me/posts/2021/03/04/jenkins-pipeline-git-branch/
   }
 }
```

# One Jenkins Server

If we've only got one server, we need to think a little differently by using the folder hierarchy to our advantage.

For instance, let's say that our Jenkins has a top-level folder for `Managed-Pipeline` for the existing Job DSL repo. We'll say, to be extra clear, that we'll create a top-level folder for our QA environment for these jobs which will mean we now have our QA repo in `QA/Managed-Pipeline`, which makes it visually clear that it's a non-Production set of jobs.

This allows us to modify our `jobs/src/main/groovy/utilities/JobFactory.groovy` to detect when we're running in QA, and if so, allow a branch to be used to configure jobs, instead of the hardcoded `master`:

```diff
diff --git jobs/seed.Jenkinsfile jobs/seed.Jenkinsfile
index 6b1f132..9d35f92 100644
--- jobs/seed.Jenkinsfile
+++ jobs/seed.Jenkinsfile
@@ -7,6 +7,7 @@ node {
   }
   stage('Seed Jenkins') {
     jobDsl targets: 'jobs/src/main/groovy/definitions/**/*.groovy',
-    additionalClasspath: 'jobs/build/libs/*.jar'
+    additionalClasspath: 'jobs/build/libs/*.jar',
+    additionalParameters: [SEED_BRANCH: scm.branches[0].name] // via https://www.jvt.me/posts/2021/03/04/jenkins-pipeline-git-branch/
   }
 }
diff --git jobs/src/main/groovy/utilities/JobFactory.groovy jobs/src/main/groovy/utilities/JobFactory.groovy
index 81dd0a9..eaab310 100644
--- jobs/src/main/groovy/utilities/JobFactory.groovy
+++ jobs/src/main/groovy/utilities/JobFactory.groovy
@@ -9,14 +9,14 @@ class JobFactory {
   private static final String HOST = 'git.example.com'
   private static final String PIPELINE_ORG = 'Managed-Pipelines'
   private static final String PIPELINE_REPO_NAME = 'Java'
-  private static final String PIPELINE_REPO_BRANCH = 'master'
+  private static final String DEFAULT_PIPELINE_REPO_BRANCH = 'master'
   private static final String PIPELINE_GIT_ORG_URL = "https://$HOST/$PIPELINE_ORG"
   private static final String PIPELINE_GIT_REPO_URL = "$PIPELINE_GIT_ORG_URL/$PIPELINE_REPO_NAME"
   private static final String SCM_CREDENTIALS_ID = '...'
-  private static final String BASE_BUILD_PATH = 'Managed-Pipeline/Java'
+  private static final String DEFAULT_BASE_BUILD_PATH = 'Managed-Pipeline/Java'

   static WorkflowJob seedJob(DslFactory factory) {
-    factory.pipelineJob("$BASE_BUILD_PATH/_Seed") {
+    factory.pipelineJob("${getBaseBuildPath(factory)}/_Seed") {
       description 'Pipeline to seed the Managed Pipeline jobs for Java'
       definition {
         cpsScm {
@@ -25,7 +25,7 @@ class JobFactory {
               remote {
                 url PIPELINE_GIT_REPO_URL
               }
-              branch PIPELINE_REPO_BRANCH
+              branch getPipelineBranch(factory)
             }
             scriptPath 'jobs/seed.Jenkinsfile'
           }
@@ -35,7 +35,7 @@ class JobFactory {
   }

   static MultibranchWorkflowJob seedJobPrBuilder(DslFactory factory) {
-    factory.multibranchPipelineJob("$BASE_BUILD_PATH/_Seed_PR_Builder") {
+    factory.multibranchPipelineJob("${getBaseBuildPath(factory)}/_Seed_PR_Builder") {
       branchSources {
         /* for example, when using GitHub */
         github {
@@ -62,13 +62,13 @@ class JobFactory {
                 userRemoteConfig {
                   name('origin')
                   url(PIPELINE_GIT_REPO_URL)
-                  refspec("+refs/heads/$PIPELINE_REPO_BRANCH:refs/remotes/origin/$PIPELINE_REPO_BRANCH")
+                  refspec("+refs/heads/${getPipelineBranch(factory)}:refs/remotes/origin/${getPipelineBranch(factory)}")
                   credentialsId(SCM_CREDENTIALS_ID)
                 }
               }
               branches {
                 branchSpec {
-                  name(PIPELINE_REPO_BRANCH)
+                  name(getPipelineBranch(factory))
                 }
               }
               browser {}
@@ -80,6 +80,28 @@ class JobFactory {
     }
   }

+  private static String getBaseBuildPath(DslFactory factory) {
+    if (isTestEnvironment(factory)) {
+      return "QA/$BASE_BUILD_PATH"
+    }
+    return DEFAULT_BASE_BUILD_PATH
+  }
+
+  private static String getPipelineBranch(DslFactory factory) {
+    if (isTestEnvironment(factory)) {
+      return getEnvironment(factory, 'SEED_BRANCH')
+    }
+    return DEFAULT_PIPELINE_REPO_BRANCH
+  }
+
+  private static boolean isTestEnvironment(DslFactory factory) {
+    return getEnvironment(factory, 'JENKINS_URL').contains('.test.')
+  }
+
+  private static String getEnvironment(DslFactory factory, String name) {
+    return factory.binding.getVariable(name)
+  }
+
   private final DslFactory factory
   private final String gitOrgName
   private final String gitRepoName
@@ -97,7 +119,7 @@ class JobFactory {

     this.gitOrgUrl = "https://$HOST/$gitOrgName"
     this.gitRepoUrl = "${this.gitOrgUrl}/$gitRepoName"
-    this.orgBaseBuildPath = "$BASE_BUILD_PATH/$gitOrgName"
+    this.orgBaseBuildPath = "${getBaseBuildPath(factory)}/$gitOrgName"
     this.projectBaseBuildPath = "$orgBaseBuildPath/$gitRepoName"
   }

@@ -114,7 +136,7 @@ class JobFactory {
             libraryConfiguration {
               name 'managed-java-pipeline-library'
               implicit false
-              defaultVersion PIPELINE_REPO_BRANCH
+              defaultVersion getPipelineBranch(factory)
               retriever {
                 modernSCM {
                   scm {
@@ -167,13 +189,13 @@ class JobFactory {
                 userRemoteConfig {
                   name('origin')
                   url(PIPELINE_GIT_REPO_URL)
-                  refspec("+refs/heads/$PIPELINE_REPO_BRANCH:refs/remotes/origin/$PIPELINE_REPO_BRANCH")
+                  refspec("+refs/heads/${getPipelineBranch(factory)}:refs/remotes/origin/${getPipelineBranch(factory)}")
                   credentialsId(SCM_CREDENTIALS_ID)
                 }
               }
               branches {
                 branchSpec {
-                  name(PIPELINE_REPO_BRANCH)
+                  name(getPipelineBranch(factory))
                 }
               }
               browser {}
```

Which requires we update our `jobs/seed.Jenkinsfile` to pass the `SEED_BRANCH` variable through:

```diff
diff --git jobs/seed.Jenkinsfile jobs/seed.Jenkinsfile
index 6b1f132..9d35f92 100644
--- jobs/seed.Jenkinsfile
+++ jobs/seed.Jenkinsfile
@@ -7,6 +7,7 @@ node {
   }
   stage('Seed Jenkins') {
     jobDsl targets: 'jobs/src/main/groovy/definitions/**/*.groovy',
-    additionalClasspath: 'jobs/build/libs/*.jar'
+    additionalClasspath: 'jobs/build/libs/*.jar',
+    additionalParameters: [SEED_BRANCH: scm.branches[0].name] // via https://www.jvt.me/posts/2021/03/04/jenkins-pipeline-git-branch/
   }
 }
```
