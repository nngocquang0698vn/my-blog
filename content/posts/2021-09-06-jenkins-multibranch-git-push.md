---
title: "Pushing Back to Git In a Jenkins Multibranch Pipeline"
description: "How to push back to a Git repo using a Jenkins multibranch pipeline."
tags:
- blogumentation
- jenkins
- git
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-09-06T10:00:50+0100
slug: "jenkins-multibranch-git-push"
image: /img/vendor/jenkins.png
---
When you're working with Jenkins multibranch pipelines, it's possible that you'd want to push something back to Git after the fact.

This could be that you're pushing a Git tag, or that maybe you're generating new `package-lock.json` files.

If you take a Jenkins multibranch pipeline that looks like this:

```groovy
node {
  checkout scm

  stage('Build') {
    sh 'make'
  }

  if (env.BRANCH_NAME == 'master') {
    stage('Release') {
      sh 'git tag v..'
      sh 'git push --tags'
    }
  }
}
```

We'll find that unfortunately this does not work, even if you're configuring your Multibranch pipeline to be retrieved using Git credentials.

To make this work, we can instead follow [Alan Edwardes' article](https://alanedwardes.com/blog/posts/git-username-password-environment-variables/) and use the [Git credentials helper](https://git-scm.com/docs/gitcredentials):

```groovy
node {
  checkout scm

  stage('Build') {
    sh 'make'
  }

  if (env.BRANCH_NAME == 'master') {
    stage('Release') {
      withCredentials([
        usernamePassword(credentialsId: '...', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')
      ]) {
        sh 'git config credentials.helper "/path/to/helper.sh"'
        sh 'git tag v..'
        sh 'git push --tags'
      }
    }
  }
}
```

This requires that we create a file, `helper.sh`:

```sh
#!/usr/bin/env bash
echo username="$GIT_USERNAME"
echo password="$GIT_PASSWORD"
```

This now allows Git to correctly push to the remote using HTTPS authentication.
