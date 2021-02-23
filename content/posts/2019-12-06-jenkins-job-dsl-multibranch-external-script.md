---
title: "Configuring a Jenkins Multibranch Pipeline to Use an External Script with Job DSL"
description: "How to set up a Multibranch Pipeline to use an external Git repo for running your Jenkins script."
tags:
- blogumentation
- jenkins
- job-dsl
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-06T23:49:07+0000
slug: "jenkins-job-dsl-multibranch-external-script"
image: /img/vendor/jenkins.png
---
I've recently started working with the [Jenkins Job DSL plugin](https://github.com/jenkinsci/job-dsl-plugin) to manage all my Jenkins jobs' configuration as code.

For this move to Job DSL, I wanted to get it set up to allow me to configure a Multibranch pipeline for a given Git repository, but to use Jenkins pipeline configured elsewhere, so I could reduce some repeated code.

# Using the remote-file plugin

If you want to have a Jenkinsfile pulled from an external repo, the [Remote Jenkinsfile Provider plugin](https://plugins.jenkins.io/remote-file/) has your back.

We can add the following configuration to our Job DSL:

```groovy
multibranchPipelineJob('example') {
  branchSources {
    git {
      // ...
    }
  }
  factory {
    remoteJenkinsFileWorkflowBranchProjectFactory {
      remoteJenkinsFile(scriptPath)
      localMarker('') /* everything is valid */
      remoteJenkinsFileSCM {
        gitSCM {
          userRemoteConfigs	{
            userRemoteConfig {
              name('origin')
              url('https://git.host/pipelines.git')
              refspec("+refs/heads/master:refs/remotes/origin/master")
              credentialsId(SCM_CREDENTIALS_ID)
            }
          }
          branches {
            branchSpec {
              name('master')
            }
          }
          browser {} // required, but doesn't require configuration
          gitTool('/usr/bin/env git') // or wherever makes sense
        }
      }
    }
  }
}
```
When the job is then seeded, we get our Multibranch pipeline configured to run a script from an external repo - awesome!

# On CloudBees Jenkins Enterprise

Update 2021-02-23: as I was writing [Getting Started With Jenkins Job DSL Plugin for Standardising Your Pipelines]({{< ref 2021-02-23-getting-started-jobdsl-standardised >}}), I found that the solution below only works when using CloudBees Jenkins Enterprise, which was quite an infuriating evening of using the Open Source Jenkins and trying to track down a plugin that allows for "Custom Script".

So the problem that has prompted this blog post is that while it is possible to configure in the Jenkins UI, it doesn't seem to be possible through the bindings for Job DSL's [`multibranchPipelineJob`](https://jenkinsci.github.io/job-dsl-plugin/#path/multibranchPipelineJob), at least as of v1.76.

Fortunately, Job DSL has the `configure` block, which allows the tweaking of the generated XML, so although there aren't native bindings, we're able to set it ourselves:

```groovy
multibranchPipelineJob('example') {
  branchSources {
    git {
      // ...
    }
  }
  configure {
    def factory = it / factory(class: 'com.cloudbees.workflow.multibranch.CustomBranchProjectFactory')
    factory << definition(class:'org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition') {
      scm(class: 'hudson.plugins.git.GitSCM') {
        userRemoteConfigs {
          'hudson.plugins.git.UserRemoteConfig' {
            url ( 'https://git.host/pipelines.git')
          }
        }
        branches {
          'hudson.plugins.git.BranchSpec' {
            name('master')
          }
        }
      }
      scriptPath('pipelines/maven.groovy')
    }
  }
}
```

When the job is then seeded, we get our Multibranch pipeline configured to run a script from an external repo - awesome!

Note that I was able to determine the above by configuring the changes manually in the Jenkins UI, and then [viewing the job's config as XML]({{< ref "2019-11-29-jenkins-config-xml" >}}) to then reverse-engineer the above `configure` block.
