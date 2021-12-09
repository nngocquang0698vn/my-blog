---
title: "Avoiding `NoClassDefFoundError` errors when using slf4j-test with Logback and Maven"
description: "How to exclude Logback from the classpath when testing your logs using slf4j-test and Maven."
tags:
- blogumentation
- testing
- java
- slf4j
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-05-29T15:44:55+0100
slug: slf4j-test-logback-maven
---
As I wrote about in [Testing Your SLF4J Logs](/posts/2019/09/22/testing-slf4j-logs/), the [slf4j-test](https://projects.lidalia.org.uk/slf4j-test/), library is awesome for allowing us to add tests for our logs.

But today I hit a couple of `NoClassDefFoundError`s today when setting this up with Logback on a Spring Boot project today, and it was a unobvious how to solve this - so I thought I'd share what fixed it.

Starting with the maven-surefire-plugin configuration as:

```xml
<!-- ... -->
<plugin>
  <artifactId>maven-surefire-plugin</artifactId>
  <version>2.22.2</version>
</plugin>
<!-- ... -->
```

Left me with the usual warnings in my logs, as slf4j-test needs to be the only implementation:

```
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/home/jamie/.m2/repository/ch/qos/logback/logback-classic/1.2.3/logback-classic-1.2.3.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/home/jamie/.m2/repository/uk/org/lidalia/slf4j-test/1.2.0/slf4j-test-1.2.0.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [ch.qos.logback.classic.util.ContextSelectorStaticBinder]
```

I then tried to exclude the logback package from my configuration, and ended up with one of two exceptions:

```
java.lang.NoClassDefFoundError: ch/qos/logback/classic/turbo/TurboFilter
Caused by: java.lang.ClassNotFoundException: ch.qos.logback.classic.turbo.TurboFilter
```

Or:

```
java.lang.NoClassDefFoundError: ch/qos/logback/core/joran/spi/JoranException
Caused by: java.lang.ClassNotFoundException: ch.qos.logback.core.joran.spi.JoranException
```

It turns out the fix was to exclude _both_ packages:

```xml
<!-- ... -->
<plugin>
  <artifactId>maven-surefire-plugin</artifactId>
  <version>2.22.2</version>
  <classpathDependencyExcludes>
    <classpathDependencyExcludes>ch.qos.logback:logback-core</classpathDependencyExcludes>
    <classpathDependencyExcludes>ch.qos.logback:logback-classic</classpathDependencyExcludes>
  </classpathDependencyExcludes>
</plugin>
<!-- ... -->
```

And then our tests run correctly!

One caveat of this is I've not yet found a way of getting it working so I can use [logstash-logback-encoder](https://mvnrepository.com/artifact/net.logstash.logback/logstash-logback-encoder). This could be related to a [Spring Boot defect](https://github.com/spring-projects/spring-boot/issues/26711).
