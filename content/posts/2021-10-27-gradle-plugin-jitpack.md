---
title: "Using JitPack to Install Gradle Plugins from Git Sources"
description: "How to use JitPack to use an unreleased Gradle plugin from a Git repo in your Gralde projects."
tags:
- blogumentation
- gradle
- java
- jitpack
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-10-27T11:37:08+0100
slug: "gradle-plugin-jitpack"
image: https://media.jvt.me/c25b297eaa.png
---
Today, I was trying to release the [Jenkins Job DSL plugin](https://github.com/jenkinsci/job-dsl-plugin/) when I found that I needed to upgrade a couple of plugins to resolve an issue with a Gradle upgrade.

As mentioned in [upstream](https://github.com/eriwen/gradle-css-plugin/issues/58) [issues](https://github.com/eriwen/gradle-js-plugin/issues/177) for the affected plugins, the fix had been made on the primary branch but the plugin had not yet been released.

One option, as mentioned by folks on the issues, is to publish them yourself or vendor them into the project, which can be messy and frustrating.

An alternative is something I found super useful when working with the Spotless project, [called out in their contributing docs](https://github.com/diffplug/spotless/blob/a7f25eb51c6d4006591ea911157e62d0213e320b/CONTRIBUTING.md), which is the [JitPack](https://jitpack.io) service.

JitPack is a service that makes it possible to build JVM libraries from a number of Git hosting tools. This allows us to point Gradle to the JitPack repository for specific dependencies, where JitPack will build an artefact for us for the given Git commit and publish it so we can consume it.

Let's say that your `build.gradle` currently looks like this:

```groovy
plugins {
  // in my opinion, removing `version` makes it more obvious that we're using JitPack, but it can stay too
  id 'com.eriwen.gradle.css' version '2.14.0'
  id 'com.eriwen.gradle.js' version '2.14.1'
}
```

In our `settings.gradle`, we need to add the Maven repository for JitPack, and then specify a `resolutionStrategy` for each of the plugins that we want to pull, ensuring that we specify a version that is either a Git SHA for the commit we want to build, or specify a branch name:

```groovy
pluginManagement {
  repositories {
    gradlePluginPortal()
      maven {
        url 'https://jitpack.io'
      }
  }
  resolutionStrategy {
    eachPlugin {
      if (requested.id.id == 'com.eriwen.gradle.css') {
        useModule('com.github.eriwen:gradle-css-plugin:9fe88d7') // can also be a branch, i.e. `master-SNAPSHOT`
      }
      if (requested.id.id == 'com.eriwen.gradle.js') {
        useModule('com.github.eriwen:gradle-js-plugin:d15f4ae') // can also be a branch, i.e. `master-SNAPSHOT`
      }
    }
  }
}
```

And just like that, you don't need to worry (as much) about plugins not yet being released!
