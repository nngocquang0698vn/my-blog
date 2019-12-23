---
title: "Gotcha: Running both JUnit4 and JUnit5 Together with Gradle"
description: "How to make sure your JUnit4 and JUnit5 Gradle tests work within the same project."
tags:
- blogumentation
- java
- gradle
- junit
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-23T21:57:33+0000
slug: "junit4-junit5-gotcha-together-gradle"
---
About a month ago, and earlier today, I found an issue with partially upgrading my Java projects from JUnit4 to JUnit5. I was in a halfway house between upgrading all my tests to JUnit5, so still had some JUnit4 tests, but found that my Gradle build wasn't running the new JUnit5 tests.

It turns out that to use the new JUnit test runner, you need to explicitly set it up - it makes sense when you think about it!

To get this working with Gradle, we need to pull in the `junit-vintage-engine` (via [_Executing legacy tests with JUnit Vintage_](https://docs.gradle.org/current/userguide/java_testing.html#executing_legacy_tests_with_junit_vintage)) by updating our `build.gradle` as such:

```groovy
test {
    useJUnitPlatform()
}

dependencies {
    testImplementation 'org.junit.jupiter:junit-jupiter-api:5.1.0'
    testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.1.0'
    testCompileOnly 'junit:junit:4.12'
    testRuntimeOnly 'org.junit.vintage:junit-vintage-engine:5.1.0'
}
```

With this in place both my new JUnit5 and legacy JUnit4 tests were running correctly!
