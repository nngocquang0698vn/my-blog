---
title: "Configure Gradle to Allow Listing All Subproject Dependencies"
description: "How to set Gradle configuration globally to add a task to list all your dependencies."
tags:
- blogumentation
- gradle
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-07-27T13:14:09+0100
slug: "gradle-list-all-dependencies"
image: https://media.jvt.me/c25b297eaa.png
---
Every so often, I need to list the dependency tree for my Gradle projects, which doesn't work out-of-the-box when using subprojects. I [bookmarked](/mf2/2020/05/3clzz/) the great post [_Gradle tricks – display dependencies for all subprojects in multi-project build_](https://solidsoft.wordpress.com/2014/11/13/gradle-tricks-display-dependencies-for-all-subprojects-in-multi-project-build/) as I so regularly come back to it, as it solves the issue for us.

However, I wondered if there was a better way to do this, as I didn't want to commit this task into each project, but I also didn't have to keep locally adding it to each project, and then removing it before committing.

Fortunately, we can follow [_Configure Gradle to Configure Tasks Globally with an initscript_](/posts/2020/07/27/global-gradle-task/) and create a file i.e. `~/.gradle/init.d/allDeps.gradle`:

```groovy
projectsEvaluated {
  rootProject.allprojects {
    if (!tasks.findByName('allDeps')) {
      task allDeps(type: DependencyReportTask) {}
    }
  }
}
```

This will then allow you to run `gradle allDeps` in any of your projects and get your full dependency tree, only if if that task isn't already defined (so we don't overwrite something useful).
