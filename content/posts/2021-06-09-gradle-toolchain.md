---
title: "Running Multiple JDK Versions with the Gradle Toolchains Configuration"
description: "How to use the Gradle's `toolchain` configuration to configure multiple JDKs on your machine."
tags:
- blogumentation
- java
- gradle
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-06-09T09:04:09+0100
slug: "gradle-toolchain"
image: https://media.jvt.me/c25b297eaa.png
---
When working with Java projects, you may end up working across multiple JDKs. It may be that you use different vendors, such as Oracle or the OpenJDK, or whether you're working with different Java versions.

It can be annoying to constantly change your `JAVA_HOME`, and doesn't work when you may need multiple JDKs in a single project.

Similar to the [Maven Toolchains Plugin](/posts/2020/08/24/maven-toolchains/), [from Gradle 6.7](https://blog.gradle.org/java-toolchains) there is toolchains support.

This allows you, in your `build.gradle` to add:

```groovy
plugins {
  id 'java'
}

java {
  // NOTE: this is very important to make sure it's applied alongside any other
  // `java` configuration, such as `javadoc`
  toolchain {
    // if you're not yet on a newer JDK
    languageVersion.set(JavaLanguageVersion.of(8))
    // or if you're using a newer JDK
    languageVersion.set(JavaLanguageVersion.of(17))
  }
}
```

The [Toolchains for JVM projects documentation](https://docs.gradle.org/7.0.2/userguide/toolchains.html) displays more information, such as specifying a vendor's JDK.

This is super helpful, and unlike the Maven configuration, Gradle does a bit more behind the scenes for us to detect what JDKs are available, and if any are missing, it'll attempt to download them!

You can see what Gradle autodetects using `gradle -q javaToolchains`:

```
$ gradle -q javaToolchains
 + Options
     | Auto-detection:     Enabled
     | Auto-download:      Enabled

 + OpenJDK 1.8.0_292
     | Location:           /usr/lib/jvm/java-8-openjdk
     | Language Version:   8
     | Vendor:             Oracle
     | Is JDK:             true
     | Detected by:        Current JVM

 + OpenJDK 11.0.11
     | Location:           /usr/lib/jvm/java-11-openjdk
     | Language Version:   11
     | Vendor:             Oracle
     | Is JDK:             true
     | Detected by:        Common Linux Locations
```
