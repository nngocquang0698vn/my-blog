---
title: "Running Multiple JDK Versions with the Maven Toolchains Plugin"
description: "How to use the maven-toolchains-plugin to configure multiple JDKs on your machine."
tags:
- blogumentation
- java
- maven
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-08-24T21:52:06+0100
slug: "maven-toolchains"
image: https://media.jvt.me/36b6bd31a0.png
---
When working with Java projects, you may end up working across multiple JDKs. It may be that you use different vendors, such as Oracle or the OpenJDK, or whether you're working with different Java versions.

It can be annoying to constantly change your `JAVA_HOME`, and doesn't work when you may need multiple JDKs in a single project.

Fortunately, the [Maven Toolchain Plugin](https://maven.apache.org/guides/mini/guide-using-toolchains.html) has us covered.

In our top-level `pom.xml` we need to add the plugin, and define which JDKs:

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-toolchains-plugin</artifactId>
  <version>1.1</version>
  <executions>
    <execution>
      <goals>
        <goal>toolchain</goal>
      </goals>
    </execution>
  </executions>
  <configuration>
    <toolchains>
      <jdk>
        <version>1.11</version>
        <vendor>openjdk</vendor>
      </jdk>
    </toolchains>
  </configuration>
</plugin>
```

Then, in our global `~/.m2/toolchains.xml` we provide paths to the toolchains our machine supports. For instance, on Arch Linux, I have the following setup:

```xml
<?xml version="1.0" encoding="UTF8"?>
<toolchains>
  <!-- JDK toolchains -->
  <toolchain>
    <type>jdk</type>
    <provides>
      <version>1.7</version>
      <vendor>openjdk</vendor>
    </provides>
    <configuration>
      <jdkHome>/usr/lib/jvm/java-7-openjdk</jdkHome>
    </configuration>
  </toolchain>
  <toolchain>
    <type>jdk</type>
    <provides>
      <version>1.8</version>
      <vendor>openjdk</vendor>
    </provides>
    <configuration>
      <jdkHome>/usr/lib/jvm/java-8-openjdk</jdkHome>
    </configuration>
  </toolchain>
  <toolchain>
    <type>jdk</type>
    <provides>
      <version>1.11</version>
      <vendor>openjdk</vendor>
    </provides>
    <configuration>
      <jdkHome>/usr/lib/jvm/java-11-openjdk</jdkHome>
    </configuration>
  </toolchain>
</toolchains>
```
