---
title: "Publishing + Consuming Artefacts in the Local Maven Repository with Gradle"
description: "How to use Gradle to publish and consume artefacts build on your local machine."
tags:
- blogumentation
- java
- gradle
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-10-07T20:51:06+0100
slug: "gradle-maven-local"
image: https://media.jvt.me/c25b297eaa.png
---
When you're working on shared libraries, it's quite likely that you'll want to test the new version of the library, before publishing it. This can generally be avoided if we have a snapshots repo, but still helps.

When using Gradle, we need to make sure that we have the `maven-publish` plugin added, which will then provide us the `publishToMavenLocal` task, which we can run as following:

```sh
./gradlew publishToMavenLocal
```

This then publishes to our local maven repository:

```
find ~/.m2/repository/me/jvt/hacking/library
~/.m2/repository/me/jvt/hacking/library
~/.m2/repository/me/jvt/hacking/library/0.1.0
~/.m2/repository/me/jvt/hacking/library/0.1.0/library-0.1.0.jar
~/.m2/repository/me/jvt/hacking/library/0.1.0/library-0.1.0.pom
~/.m2/repository/me/jvt/hacking/library/0.1.0/library-0.1.0.module
~/.m2/repository/me/jvt/hacking/library/maven-metadata-local.xml
```

Once the library is published, how can we consume it? We add the dependency [as with other dependencies](https://docs.gradle.org/6.0/userguide/dependency_management_for_java_projects.html) but add `mavenLocal()`:

```diff
 repositories {
   mavenCentral()
+  mavenLocal()
 }
```

I never check in these changes, because I've been burned by having this enabled on a project before. Maven pulls from the local Maven repository by default, so when I was running on a shared build platform, it led to inconsistent failing builds between my local machine and remotely as the version that's available may not be the version that's been tested and released. It similarly runs the risk that someone may have overwritten a version of the library that you're expecting to be correct, i.e. Apache commons.
