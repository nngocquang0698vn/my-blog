---
title: "Determining the (Git) Branch of the Jenkins Pipeline Job"
description: "How to find out what branch the currently executing script has been checked out from."
tags:
- blogumentation
- jenkins
- git
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-03-04T09:01:41+0000
slug: "jenkins-pipeline-git-branch"
image: /img/vendor/jenkins.png
---
When running Jenkins' Multibranch pipelines, you get a handy environment variable `GIT_BRANCH` which tells you what the current branch is, so you can do different things in your pipeline.

However, when you're using a Pipeline Job, that's not possible, as the environment variable isn't set.

Fortunately, this is available to the Groovy sandbox, and as [Mad Physicist mentions on StackOverflow](https://stackoverflow.com/a/43786068), we can reference it using:

```groovy
scm.branches[0].name
```

This allows us to see which branch was used to check out the script that is currently executing.
