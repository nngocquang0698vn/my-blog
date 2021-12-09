---
title: "Configure Gradle to Configure Tasks Globally with an initscript"
description: "How to use Gradle's initialization scripts to globally configure tasks across all of your projects."
tags:
- blogumentation
- gradle
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-07-27T13:14:09+0100
slug: "global-gradle-task"
image: https://media.jvt.me/c25b297eaa.png
---
As part of [_Configure Gradle to Allow Listing All Subproject Dependencies_](/posts/2020/07/27/gradle-list-all-dependencies/), I wanted to utilise [Gradle initscripts](https://docs.gradle.org/current/userguide/init_scripts.html) to provide a global task across all my projects.

Unfortunately our setup from [_Running Spotless Automagically with Gradle_](/posts/2020/05/15/gradle-spotless/) doesn't quite work, but I was able to adapt [the general set up from Marcin's article _My Gradle init script_](http://blog.proxerd.pl/article/my-gradle-init-script) which allows us to do this.

We can create a file i.e. `~/.gradle/init.d/hello.gradle`:

```groovy
projectsEvaluated {
  rootProject.allprojects { project ->
    if (!tasks.findByName('hello')) {
      task hello() {
        println('Hey from ' + project.name)
      }
    }
  }
}
```

Which allows us to run `gradle hello` and it'll tell us which project it's executing in.
