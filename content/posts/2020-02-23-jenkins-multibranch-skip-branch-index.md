---
title: "Skip Builds On Branch Indexing with Jenkins Multibranch Pipelines"
description: "How to stop Jenkins unnecessarily kicking off builds on Multibranch pipelines when indexing the branches."
tags:
- blogumentation
- jenkins
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-02-23T13:03:45+0000
slug: "jenkins-multibranch-skip-branch-index"
image: /img/vendor/jenkins.png
---
Jenkins has the ability to set up a [multibranch pipeline](https://jenkins.io/doc/book/pipeline/multibranch/) which allows you to run configure building of your branches and Pull/Merge requests using the same configuration, which is very useful.

If you've ever worked with it, you'll likely have needed to hit the `Scan Multibranch Pipeline Now`, which goes through each branch on your repository and will build it if it needs to. Although this can be very useful, it can also be quite frustrating, as if you have 10s of branches, these new builds will swamp the executors on your agents, or depending on how you run your pipelines, end up triggering costly Cloud deployments.

It turns out we can avoid this issue by adding the following into our `Jenkinsfile` for a Declarative pipeline:

```groovy
// execute this before anything else, including requesting any time on an agent
if (currentBuild.getBuildCauses().toString().contains('BranchIndexingCause')) {
  print "INFO: Build skipped due to trigger being Branch Indexing"
  currentBuild.result = 'ABORTED' // optional, gives a better hint to the user that it's been skipped, rather than the default which shows it's successful
  return
}

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
```

Or in our Scripted `Jenkinsfile`:

```groovy
// execute this before anything else, including requesting any time on an agent
if (currentBuild.getBuildCauses().toString().contains('BranchIndexingCause')) {
  print "INFO: Build skipped due to trigger being Branch Indexing"
  currentBuild.result = 'ABORTED' // optional, gives a better hint to the user that it's been skipped, rather than the default which shows it's successful
  return
}

node {
    stages {
        stage('Build') {
                echo 'Building..'
        }
        stage('Test') {
                echo 'Testing..'
        }
        stage('Deploy') {
                echo 'Deploying....'
            }
    }
}
```

Any builds triggered will simply be skipped as `SUCCESS`, not having executed anything:

![Jenkins build console output showing the INFO message, but nothing in the job having executed](https://media.jvt.me/svc4v.png)
