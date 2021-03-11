---
title: "Speeding Up Gradle Executions with Parallelisation"
description: "How to make your Gradle builds faster, by taking advantage of parallelisation."
tags:
- blogumentation
- java
- testing
- gradle
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-03-11T09:32:25+0000
slug: "gradle-speed-parallel"
image: https://media.jvt.me/c25b297eaa.png
---
This is another shamelessly stolen tip from <span class="h-card"><a class="u-url" href="https://www.testingsyndicate.com/">Jack Gough</a></span>, thanks for sharing with me!

Waiting for builds to run is [well documented](https://xkcd.com/303/) as a cause for developers' poor productivity, but there are things we can do to make our lives easier, and parallelise where possible.

# Running Gradle in Parallel

One of the [easier improvements, according to Gradle's docs](https://docs.gradle.org/current/userguide/performance.html#easy_improvements), is that we can look at executing Gradle in parallel across all projects/subprojects.

Although this may not gain you much benefit right now if you're only using a single project, it's worthwhile adding to the `gradle.properties` file in the root of your project:

```ini
org.gradle.parallel=true
```

# Running JUnit5 in Parallel

Another win when using JUnit5 is to set up [parallel execution](https://junit.org/junit5/docs/current/user-guide/#writing-tests-parallel-execution).

We can configure this in our `build.gradle` when setting up our tests, i.e.:

```groovy
test {
    useJUnitPlatform()
    systemProperties([
        // Configuration parameters to execute top-level classes in parallel but methods in same thread
        'junit.jupiter.execution.parallel.enabled': 'true',
        'junit.jupiter.execution.parallel.mode.default': 'same_thread',
        'junit.jupiter.execution.parallel.mode.classes.default': 'concurrent',
    ])
}
```

This will then apply it over each test run in our project, allowing us to significantly speed up our builds.

## Beware: Thread-specific issues

However, we may hit issues where our tests don't expect to be running across multiple threads. To avoid these, we can look at the root cause.

I've seen this more commonly when using [slf4j-test for testing your SLF4J logs]({{< ref 2019-09-22-testing-slf4j-logs >}})]({{< ref 2019-09-22-testing-slf4j-logs >}}), where we need to make sure we use the right thread-safe option, so we don't clear / retrieve logs from different threads:

```diff
-TestLoggerFactory.clearAll()
+TestLoggerFactory.clear()
```

```diff
-TestLoggerFactory.getAllLoggingEvents()
+TestLoggerFactory.getLoggingEvents()
```

If it's too much difficulty, we can always fall back to the `@Isolated` annotation on the test class.
