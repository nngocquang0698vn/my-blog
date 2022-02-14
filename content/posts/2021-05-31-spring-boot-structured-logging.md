---
title: "Migrating Your Spring Boot Application to use Structured Logging"
description: "How to make your Spring Boot services more supportable by migrating to JSON-emitting structured logging."
tags:
- blogumentation
- spring
- spring-boot
- java
- slf4j
- logs
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-05-31T21:09:17+0100
slug: "spring-boot-structured-logging"
image: /img/vendor/spring-logo.png
---
# Why?

Being able to support production services is pretty important, whether they're personal projects or for high-traffic customer services. Often, logs are the only thing someone has to go off to determine why something went wrong, and a hint for what needs to be done to resolve it.

One of the services I took ownership of late last year was pretty lacking in its ability to provide any actionable information from our logs, and made it pretty hard to diagnose why things were going wrong. Not only has this been greatly improved by adding more information to logs such as tracking IDs and other information provided by the client, but also through restructuring our logs so they were in a slightly more parseable format for our log aggregation platform.

Spring Boot by default uses more human-readable log messages, such as:

```
2021-05-31 14:39:04.872  INFO 1167226 --- [o-auto-1-exec-1] c.e.s.HelloController                    : Hello
```

Although this is straightforward for humans to read, as we're pretty good at doing pattern matching, it's difficult for machines.

As you start adding other information into the mix, such as a tracking UUID and the `x-forwarded-for` header, things get much more difficult to read:

```
2021-05-31 14:39:04.872  ERROR 1167226 --- [o-auto-1-exec-1] c.e.s.HelloController                    : c8633195-2ed1-45fa-ae3d-5afb3ce33c82 [10.x.y.z, 127.0.0.1] An unexpected error occured, cause: ...
```

This also means it's more difficult for humans to easily search through logs, leading to them searching across the logging aggregation platform for the UUID, potentially finding other unrelated log entries, and generally being a not-super-helpful experience.

Additionally, by moving to a structured format, this also allows many log aggregation platforms to set up alerts, so you can set up preemptive notifications based on your logs.

To improve this experience, we can instead introduce a set structure to our logs to make them readable.

My first push for this was to tell fluentd, which we use for parsing logs, how to convert an above log message into named pieces of information.

For my service, this ended up being a 255 character long regex, with 9 named capture groups for various important pieces of information. It took a while to get to the right regex, and then took a bit longer to walk my colleagues through it, as [regexes aren't exactly known for their readability](https://xkcd.com/1171/). And because code is more often read than written, this leads to a difficult maintenance burden over time, requiring the next person to want to add more information to our logs having to understand what's there before they can add a new field.

Fortunately, there are better ways! We can use something that's a little better structured than free-form text, like JSON.

There are different ways to achieve this, which I'll outline below, but each of them lead to us having a log event that can be more easily searched and filtered due to its structure, and each have a good way of [exposing data from the Mapped Diagnostic Context](http://logback.qos.ch/manual/mdc.html).

I'd recommend going for JSON logs by default, especially as it [may become a default for Spring Boot 3](https://github.com/spring-projects/spring-boot/issues/5479).

Note that you may not want this for i.e. unit/unit integration testing, as you may want to be able to read the log messages more easily. To do this, you'd want to configure it differently for those by setting up a different configuration in i.e. `src/test/resources/spring-logback.xml`, which uses the pattern-based layout, not a JSON formatted layout.

A sample project can be found in [<i class="fa fa-gitlab"></i> jamietanna/spring-boot-structured-logging](https://gitlab.com/jamietanna/spring-boot-structured-logging/), with examples for all the logging implementations below.

# Using Logback

Logback is the default logging implementation for Spring Boot, so it's likely that you're using it.

There's a [great article on innoq](https://www.innoq.com/en/blog/structured-logging/) about setting up structured logging with [logstash-logback-encoder](https://github.com/logstash/logstash-logback-encoder), which produces great JSON log messages.

Firstly, we need to [add the logstash-logback-encoder dependency](https://mvnrepository.com/artifact/net.logstash.logback/logstash-logback-encoder), then update our `logback-spring.xml`:

```xml
<configuration>
  <appender name="jsonConsoleAppender" class="ch.qos.logback.core.ConsoleAppender">
    <encoder class="net.logstash.logback.encoder.LogstashEncoder"/>
  </appender>
  <root level="INFO">
    <appender-ref ref="jsonConsoleAppender"/>
  </root>
</configuration>
```

This produces logs of the format:

```json
{
  "@timestamp": "2021-05-31T18:03:49.135+01:00",
  "@version": "1",
  "level": "INFO",
  "level_value": 20000,
  "logger_name": "com.example.springboot.HelloController",
  "message": "Hello",
  "thread_name": "Test worker"
}
```


Anything in the MDC appears as a top-level key-value pair i.e. `acceptHeader`:

```json
{
  "@timestamp": "2021-05-31T18:03:49.135+01:00",
  "@version": "1",
  "acceptHeader": "application/json",
  "level": "INFO",
  "level_value": 20000,
  "logger_name": "com.example.springboot.HelloController",
  "message": "Hello",
  "thread_name": "Test worker"
}
```

As mentioned in [a post I wrote over the weekend](/posts/2021/05/29/slf4j-test-logback-maven/), it can be difficult getting this working if you want to [unit test your logs](/posts/2019/09/22/testing-slf4j-logs/), if you're using custom fields from the library.

# Using Log4j2

Alternatively, you may be using Log4j2 as your logging implementation.

Fortunately, since v2.14.1 of Log4j, which is available by default from [v2.5.0 of spring-boot-starter-log4j2](https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-log4j2/2.5.0), JSON formatted logs can be done out-of-the-box.

If you're using an older version of Spring Boot, you'll need to update your log4j2 to bring this in.

Then, you'll need to add the [dependency on log4j-layout-template-json](https://mvnrepository.com/artifact/org.apache.logging.log4j/log4j-layout-template-json/2.14.1).

## `JsonLayout`

Log4j includes a default JSON format with the `JsonLayout` directive, which we can configure in our `log4j2-spring.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN">
  <Appenders>
    <Console name="Console" target="SYSTEM_OUT" follow="true">
      <JsonLayout>
        <KeyValuePair key="HOME_DIR" value="$${env:HOME}"/> <!-- add custom fields if needbe -->
      </JsonLayout>
    </Console>
  </Appenders>
  <Loggers>
    <Root level="info">
      <AppenderRef ref="Console" />
    </Root>
  </Loggers>
</Configuration>
```

This produces the following:

```json
{
  "instant" : {
    "epochSecond" : 1622458991,
    "nanoOfSecond" : 608000000
  },
  "thread" : "Test worker",
  "level" : "INFO",
  "loggerName" : "com.example.springboot.HelloController",
  "message" : "Hello",
  "endOfBatch" : false,
  "loggerFqcn" : "org.apache.logging.slf4j.Log4jLogger",
  "threadId" : 19,
  "threadPriority" : 5,
  "HOME_DIR" : "/home/jamie"
}
```

Or an example with data in the MDC:

```json
{
  "instant" : {
    "epochSecond" : 1622490016,
    "nanoOfSecond" : 316000000
  },
  "thread" : "Test worker",
  "level" : "INFO",
  "loggerName" : "com.example.springboot.HelloController",
  "message" : "Hello",
  "endOfBatch" : false,
  "loggerFqcn" : "org.apache.logging.slf4j.Log4jLogger",
  "threadId" : 19,
  "threadPriority" : 5,
  "HOME_DIR" : "/home/jamie"
}
```

## `JsonTemplateLayout`

The great thing about Log4j's implementation of this is it allows you to fully customise the format of the JSON logs through something from the classpath.

For instance, you can use the `JsonTemplateLayout` to point to a file on the classpath. I find the `LogstashJsonEventLayoutV1` to be quite a good format, which we can configure in our `log4j2-spring.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN">
    <Appenders>
        <Console name="Console" target="SYSTEM_OUT" follow="true">
          <JsonTemplateLayout eventTemplateUri="classpath:LogstashJsonEventLayoutV1.json">
            <EventTemplateAdditionalField key="HOME_DIR" value="${env:HOME}"/> <!-- add custom fields if needbe -->
          </JsonTemplateLayout>
        </Console>
    </Appenders>
  <Loggers>
    <Root level="info">
      <AppenderRef ref="Console" />
    </Root>
  </Loggers>
</Configuration>
```

With the `LogstashJsonEventLayoutV1` formatted version, we get:

```json
{
  "@timestamp": "2021-05-31T12:04:22.222+01:00",
  "@version": 1,
  "level": "INFO",
  "logger_name": "com.example.springboot.HelloController",
  "message": "Hello",
  "source_host": "TheColonel",
  "thread_name": "Test worker",
  "HOME_DIR": "/home/jamie"
}
```

Or if there's anything in the MDC:

```json
{
  "@timestamp": "2021-05-31T12:06:57.101+01:00",
  "@version": 1,
  "level": "INFO",
  "logger_name": "com.example.springboot.HelloController",
  "mdc": {
    "acceptHeader": "application/json"
  },
  "message": "Hello",
  "source_host": "TheColonel",
  "thread_name": "Test worker",
  "HOME_DIR": "/home/jamie"
}
```

The best thing about `JsonTemplateLayout` is that it allows you to easily standardise the log formatting across your services - especially if you decide to go a different direction than is provided by default in Log4j.
