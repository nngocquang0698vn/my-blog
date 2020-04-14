---
title: "Inheriting the Environment Variables from the Jenkins Host in Docker"
description: "How to pass environment variables from your Jenkins host to your Docker containers."
tags:
- blogumentation
- docker
- jenkins
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-04-14T13:09:20+0100
slug: "inherit-environment-docker-host-jenkins"
image: https://media.jvt.me/b0bf1d8c2f.png
---
If you're running your Jenkins builds in (Docker) containers - which I would recommend - you may have noticed that not all of your environment variables are passed through to the container from the host.

Fortunately this is straightforward to do, but has a slight implementation difference depending on how your pipeline is set up.

We'll use the contrived example of passing through the `AWS_REGION` and `HOSTNAME` environment variables to the container.

# Declarative Pipeline

If you're using a declarative pipeline you'll likely have something like:

```groovy
pipeline {
  agent {
    docker {
      image 'alpine'
    }
  }
  stages {
    stage('Environment Variables') {
      steps {
        sh 'env'
      }
    }
  }
}
```

And to pass the variables, we can pass the following argument:

```diff
 pipeline {
   agent {
     docker {
       image 'alpine'
+      args '-e AWS_REGION=$AWS_REGION -e HOSTNAME=$HOSTNAME'
     }
   }
   stages {
     stage('Environment Variables') {
       steps {
         sh 'env'
       }
     }
   }
 }
```

Note the single quotes, which **must** be done, otherwise Jenkins will attempt to resolve it as part of the `WorkflowScript` it's running, which will either not exist, or not be correct. Single quotes allows it to be interpolated at the right time, and pull the variables correctly.

# Scripted Pipeline

If you're using a scripted pipeline you'll likely have something like:

```groovy
docker.image('alpine').inside {
  stage('Environment Variables') {
    sh 'env'
  }
}
```

And to pass the variables, we can pass the following argument:

```diff
-docker.image('alpine').inside {
+docker.image('alpine').inside('-e AWS_REGION=$AWS_REGION -e HOSTNAME=$HOSTNAME') {
   stage('Environment Variables') {
     sh 'env'
   }
 }
```

Note the single quotes, which **must** be done, otherwise Jenkins will attempt to resolve it as part of the `WorkflowScript` it's running, which will either not exist, or not be correct. Single quotes allows it to be interpolated at the right time, and pull the variables correctly.
