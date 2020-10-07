---
title: "Resolving Gradle Error `Unexpected Parent Dependency` in IntelliJ"
description: "How to resolve the error `Unexpected Parent Dependency` when building Gradle projects in IntelliJ."
tags:
- blogumentation
- gradle
- intellij
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-09-29T19:52:36+0100
slug: "gradle-unexpected-parent-dependency"
image: https://media.jvt.me/c25b297eaa.png
---
Today I was doing some Spring Boot updates, and found that updating past `2.3.1.RELEASE` resulted in the following error when trying to build in IntelliJ:

```
Could not resolve all dependencies for configuration
':....CompileClasspath'.
Problems reading data from Binary store in /private/var/folders/dn/hq_q2hxn7_d48fzc6hh0y9rw0000gp/T/gradle1100970711465945564.bin offset 4480 exists? true
Unexpected parent dependency id 70. Seen ids: [256, 257, 2, 262, 266, 271, 274, 275, 278, 285, 286, 287, 290, 35, 36, 37, 293, 38, 39, 40, 41, 42, 298, 43...
```

Looking into this further, it appears that this [is an upstream issue with Gradle v6.5.x](https://github.com/gradle/gradle/issues/13639), and that the solution is released in Gradle v6.6.
