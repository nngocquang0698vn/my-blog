---
title: "Setting Your Maven Project Versions"
description: "How to set the versions of all Maven `pom.xml`s within a Maven project."
tags:
- blogumentation
- maven
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-10-20T14:39:07+0100
slug: "maven-set-version"
---
If you're looking to manually set the versions of a Maven project's versions, i.e. as part of a release, it can be a pain if you've got a large project with lots of version numbers.

Fortunately there is the [maven-versions-plugin](https://www.mojohaus.org/versions-maven-plugin/) which we can use to i.e. to bump the whole project to `0.2-SNAPSHOT`:

```sh
mvn versions:set -DnewVersion=0.2.0-SNAPSHOT
```
