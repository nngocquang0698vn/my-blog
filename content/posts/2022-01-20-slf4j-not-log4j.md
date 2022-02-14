---
title: "Use SLF4J, not Log4J, as Your Logging Interface"
description: "Why we should be using the interface API for logging, rather than the underlying implementation's API."
tags:
- java
- logs
- slf4j
- log4j
- logback
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-20T09:33:16+0000
slug: "slf4j-not-log4j"
image: https://media.jvt.me/adfddc977a.jpeg
---
I recently noticed that some of my colleagues were using Log4J as their logging interface with code such as:

```java
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

class ClassNameHere {
  private static final Logger LOG = LogManager.getLogger(ClassNameHere.class);

  // ...
}
```

Whereas I'd expected us to be using SLF4J's interface:

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

class ClassNameHere {
  private static final Logger LOG = LoggerFactory.getLogger(ClassNameHere.class);

  // ...
}

```

In my previous company, we almost entirely used the SLF4J interface, so I found it surprising that folks would not be doing this everywhere - while remembering that my previous company is only a tiny subset of Java developers worldwide - and chatted with one of the Senior engineers on the project about it.

I wanted to make sure that my point of view was improved by learning from their context, and it was helpful to understand their team's point of view, and some of the reasoning. However, it did solidify my point of view that I prefer the use of SLF4J over the real implementation of the API, whether that is Log4J, Logback, or some other logging library.

One comment, which I've heard a fair bit when discussing this in the past is "but I'm not going to change the underlying library that often, so why would I use SLF4J's API instead of Log4J?" and it's an interesting point.

In my experience, I've done a migrations across a dozen Spring Boot services, for a few reasons - [when trialing Structured Logging in Spring Boot](/posts/2021/05/31/spring-boot-structured-logging/), so I could see what the different libraries supported, but most importantly for [testing my logs with slf4j-test](/posts/2019/09/22/testing-slf4j-logs/).

In the slf4j-test case, we need to use SLF4J as the interface, because we would want our tests to be executing against the slf4j-test stubbed implementation, which allows us to unit test, rather than the "real" implementation of Log4J, or whichever library we're using.

We also need to consider the reason we use interfaces in general is to hide some of the underlying details, so it's easier to interact with. For this project using Log4J, the team are needing to understand how Log4J handles additional context for messages using `ThreadContext`, as its underlying implementation of SLF4J's `MDC`. Although there are some [really interesting things it can give you](https://logging.apache.org/log4j/2.x/manual/thread-context.html), I'd argue it's unnecessary overhead.

In these logging libraries' use cases, it's unlikely you're using too much of the underlying library and can instead switch to SLF4J pretty easily, as well as being able to reap the benefits of using great libraries like slf4j-test.

This may not be super persuasive, but thought I'd at least share my point of view.
