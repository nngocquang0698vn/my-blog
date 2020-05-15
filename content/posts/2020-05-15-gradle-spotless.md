---
title: "Running Spotless Automagically with Gradle"
description: "How to set Gradle configuration globally to always run `spotlessApply` in your projects."
tags:
- blogumentation
- gradle
- spotless
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-15T16:54:50+0100
slug: "gradle-spotless"
image: https://media.jvt.me/44d58db1ce.png
---
If you're using Gradle and are using [Spotless](https://github.com/diffplug/spotless) to manage your code style (which I'd strongly recommend) you may find it annoying to manually run Spotless each time you make changes to your codebase.

I've got mine set up so with my Gradle projects, Spotless is enforced after the compilation phase (`JavaCompile`). The alternative, more developer-friendly method would be to have `spotlessApply` always running before `JavaCompile`, which means that you'd always have well-formatted code.

However, this unfortunately means that you're relying on developers to be good. If, for whatever reason, the developer in question didn't run their code locally before pushing their code, you may not notice. The pipeline would run, and would automagically apply Spotless therefore the code would be well-formed when it then runs `spotlessCheck`. But in the actual Merge Request, you'd see inconsistent/bad code style. This isn't great, and can make things a bit painful.

We could, instead, have a slightly different Gradle configuration between local and our pipeline, but that seems like it'd risk things being inconsistent, and eventually drifting.

However, this can be a bit painful, because it means you're going through a regular loop of making sure you run i.e. `./gradlew clean spotlessApply test`.

Today, <span class="h-card"><a class="u-url p-name" href="https://www.testingsyndicate.com/">Jack Gough</a></span> mentioned that you are able to set global Gradle configuration, which allows you to always apply Spotless, if it's configured.

We can create a file i.e. `~/.gradle/init.d/spotless.gradle`:

```groovy
allprojects {
  afterEvaluate {
    def spotless = tasks.findByName('spotlessApply')
    if (spotless) {
      tasks.withType(JavaCompile) {
        finalizedBy(spotless)
      }
    }
  }
}
```

This will apply your Spotless configuration, after the code has successfully compiled, but will run before any other configured tasks like `spotlessCheck`, if that's configured in the project.

And of course we only want to apply this if Spotless is found in the project, otherwise we risk breaking non-Spotless project builds.
