---
title: "How to List Gradle's Buildscript / Plugin Dependencies"
description: "How to list the dependencies that are used by Gradle's plugins as part of its buildscript."
tags:
- blogumentation
- gradle
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-11-04T11:44:42+0000
slug: "gradle-list-all-plugin-dependencies"
image: https://media.jvt.me/c25b297eaa.png
---
Similarly to [_Configure Gradle to Allow Listing All Subproject Dependencies_](/posts/2020/07/27/gradle-list-all-dependencies/), it can be useful to find out the dependencies that are in use by your Gradle plugins.

Fortunately, there is the [`buildEnvironment` Gradle task](https://solidsoft.wordpress.com/2016/06/07/gradle-tricks-display-buildscript-dependencies/) that allows us to list the project's buildscript dependencies (output trimmed for brevity):

```
> Task :buildEnvironment

------------------------------------------------------------
Root project - Spring Security OAuth2 Auto Configuration
------------------------------------------------------------

classpath
+--- io.spring.gradle:spring-build-conventions:0.0.28.RELEASE
|    +--- com.github.ben-manes:gradle-versions-plugin:0.25.0
...
|    +--- gradle.plugin.org.gretty:gretty:2.3.1
|    |    +--- org.gretty:gretty-core:2.3.1
...
|    |    |         \--- org.springframework.boot:spring-boot-dependencies:2.3.0.M4 (*)
|    |    +--- org.springframework.boot:spring-boot-loader-tools:1.5.12.RELEASE -> 2.3.0.M4
|    +--- org.springframework.boot:spring-boot-buildpack-platform:2.3.0.M4
...
|    +--- org.springframework.boot:spring-boot-loader-tools:2.3.0.M4 (*)
|    +--- io.spring.gradle:dependency-management-plugin -> 1.0.9.RELEASE
|    +--- org.apache.commons:commons-compress -> 1.19
|    +--- org.springframework:spring-core -> 5.2.5.RELEASE (*)
|    \--- org.springframework.boot:spring-boot-dependencies:2.3.0.M4 (*)
+--- io.spring.javaformat:spring-javaformat-gradle-plugin:0.0.20 (*)
\--- io.spring.nohttp:nohttp-gradle:0.0.4.RELEASE (*)

(c) - dependency constraint
(*) - dependencies omitted (listed previously)

A web-based, searchable dependency report is available by adding the --scan option.

Deprecated Gradle features were used in this build, making it incompatible with Gradle 7.0.
Use '--warning-mode all' to show the individual deprecation warnings.
See https://docs.gradle.org/6.3/userguide/command_line_interface.html#sec:command_line_warnings

BUILD SUCCESSFUL in 1s
1 actionable task: 1 executed
```
