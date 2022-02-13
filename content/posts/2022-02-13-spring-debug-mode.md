---
title: "Determining if the Spring Boot Application is Running in Debug or Trace Mode"
description: "How to determine if your Spring Boot application is running in debug mode, for instance to selectively enable other features of your application."
tags:
- blogumentation
- java
- spring-boot
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-13T10:01:17+0000
slug: "spring-debug-mode"
syndication:
- "https://brid.gy/publish/twitter"
---
As with any software development process, we can't always build things right the first time, and sometimes we need to up the logging levels, or debug our framework a little more in depth.

When running Spring Boot applications, we may want to set the debug/trace modes to get a bit more information from Spring Boot, and the various libraries bundled with it.

# Debug mode

## Setting debug mode

You can do this by running in debug mode, which is most commonly done by setting the `debug` command-line flag:

```sh
java -jar /path/to/boot.jar --debug
```

Or by specifying in our properties file that we're using debug mode:

```ini
debug=true
```

## Determining debug mode

In the case that we want to work out whether we're in debug mode, for instance to increase logging configuration by adding new beans to the classpath, or i.e. add [a wiretap to our `WebClient`](/posts/2022/02/13/log-webflux-client/).

To do so, we can use the following SPring Expression Language (SPEL) to

```java
import org.springframework.core.env.Environment;
import org.springframework.beans.factory.annotation.Value;

public WebClient webClient(
      @Value("#{environment.getProperty('debug') != null && environment.getProperty('debug') != 'false'}")
        boolean isDebug
      ) {
  if (isDebug) {
    // ...
  }

  // return
}
```

Alternatively, you may want to define a bean for it, so there's only a single means of performing this lookup:

```java
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;

@Bean
public boolean isDebug(
    @Value("#{environment.getProperty('debug') != null && environment.getProperty('debug') != 'false'}")
        boolean isDebug) {
  return isDebug;
}

@Bean
public WebClient webClient(boolean isDebug) {
  if (isDebug) {
    // ...
  }

  // return
}
```

This could also be improved to allow you to enforce that debug mode cannot be turned on production environments.

If you'd like to avoid SPEL, you can also inject the `Environment` itself, and query it manually:

```java
@Bean
public boolean isDebug(Environment environment) {
  String debug = environment.getProperty("debug");
  return null != debug && !debug.equals("false");
}
```

# Trace Mode

You can do this by running in trace mode, which is most commonly done by setting the `trace` command-line flag:

```sh
java -jar /path/to/boot.jar --trace
```

Or by specifying in our properties file that we're using trace mode:

```ini
trace=true
```

## Determining trace mode

In the case that we want to work out whether we're in trace mode, for instance to increase logging configuration by adding new beans to the classpath, or i.e. add [a wiretap to our `WebClient`](/posts/2022/02/13/log-webflux-client/).

To do so, we can use the following SPring Expression Language (SPEL) to

```java
import org.springframework.core.env.Environment;
import org.springframework.beans.factory.annotation.Value;

public WebClient webClient(
      @Value("#{environment.getProperty('trace') != null && environment.getProperty('trace') != 'false'}")
        boolean isTrace
      ) {
  if (isTrace) {
    // ...
  }

  // return
}
```

Alternatively, you may want to define a bean for it, so there's only a single means of performing this lookup:

```java
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;

@Bean
public boolean isTrace(
    @Value("#{environment.getProperty('trace') != null && environment.getProperty('trace') != 'false'}")
        boolean isTrace) {
  return isTrace;
}

@Bean
public WebClient webClient(boolean isTrace) {
  if (isTrace) {
    // ...
  }

  // return
}
```

This could also be improved to allow you to enforce that trace mode cannot be turned on production environments.

If you'd like to avoid SPEL, you can also inject the `Environment` itself, and query it manually:

```java
@Bean
public boolean isTrace(Environment environment) {
  String trace = environment.getProperty("trace");
  return null != trace && !trace.equals("false");
}
```

# Notes

Note that the debug check above only returns true if we're in `debug` mode, not in `trace` mode. You may want to adapt the `isDebug` definition to cater for both, unless there is different processing you wish to do between `debug` and `trace`.
