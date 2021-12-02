---
title: "Reducing Risk of Supply Chain Attacks with Reproducible Builds in Gradle"
description: "How to enable Gradle's reproducible builds functionality to allow others to verify your released libraries don't contain uncommitted, malicious code."
date: 2021-12-02T17:05:18+0000
tags:
- "blogumentation"
- "java"
- "gradle"
- "security"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: gradle-reproducible-builds
---
It's becoming [more and more common](https://securityintelligence.com/articles/supply-chain-attacks-open-source-vulnerabilities/) for Free and Open Source dependencies to become poisoned by attackers.It's (fortunately) not solved by using only Proprietary software, as the [SolarWinds breach last year](https://www.sans.org/blog/what-you-need-to-know-about-the-solarwinds-supply-chain-attack/) taught us.

However, by using Free and Open Source tooling, we have the ability to independently verify that a built package is byte-for-byte the exact same between the maintainer's machine and your own.

As authors of libraries, we should be striving to provide this functionality for our consumers, by making sure our build and packaging processes apply [practices shared by the Reproducible Builds community](https://reproducible-builds.org/).

Gradle has supported this since version 3.4, and [the documentation describes how to set it up](https://docs.gradle.org/7.3/userguide/working_with_files.html#sec:reproducible_archives), which I have echoed below, as well as adding a Kotlin example.

# `build.gradle`

If you're using the Groovy buildscript, you'll need the following:

```groovy
allprojects {
 tasks.withType(AbstractArchiveTask).configureEach {
    preserveFileTimestamps = false
    reproducibleFileOrder = true
  }
}
```

# `build.gradle.kts`

Or if you're using a Kotlin buildscript, you can use the following:

```kotlin
allprojects {
  tasks.withType<AbstractArchiveTask>() {
    isPreserveFileTimestamps = false
    isReproducibleFileOrder = true
  }
}
```
