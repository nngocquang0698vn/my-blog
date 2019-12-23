---
title: "Gotcha: Running both JUnit4 and JUnit5 Together with Maven"
description: "How to make sure your JUnit4 and JUnit5 Maven tests work within the same project."
tags:
- blogumentation
- java
- maven
- junit
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-23T21:57:33+0000
slug: "junit4-junit5-gotcha-together-maven"
---
About a month ago, and earlier today, I found an issue with partially upgrading my Java projects from JUnit4 to JUnit5. I was in a halfway house between upgrading all my tests to JUnit5, so still had some JUnit4 tests, but found that my Gradle build wasn't running the new JUnit5 tests.

It turns out that to use the new JUnit test runner, you need to explicitly set it up - it makes sense when you think about it!

My solution to getting this working with Maven was via [the maven-surefire-plugin documentation for JUnit5](https://maven.apache.org/surefire/maven-surefire-plugin/examples/junit-platform.html), and adding the following to my `pom.xml`

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-surefire-plugin</artifactId>
      <version>3.0.0-M4</version>
      <dependencies>
        <dependency>
          <groupId>org.junit.jupiter</groupId>
          <artifactId>junit-jupiter-engine</artifactId>
          <version>5.3.2</version>
        </dependency>
      </dependencies>
    </plugin>
  </plugins>
</build>
```

With this in place both my JUnit5 and legacy JUnit4 tests were running correctly!
