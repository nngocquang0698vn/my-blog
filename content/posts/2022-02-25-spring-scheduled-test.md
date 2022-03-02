---
title: 'Testing `@Scheduled` annotations with Spring (Boot)'
description: "How to test your Spring (Boot) scheduling without waiting for hours."
tags:
- blogumentation
- spring
- spring-boot
- tdd
date: 2022-02-25T09:15:46+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: spring-scheduled-test
image: https://media.jvt.me/3e88e3081a.png
syndication:
- "https://brid.gy/publish/twitter"
---
If you're writing a Spring (Boot) application that performs actions periodically, it's likely that you may be using the `@Scheduled` annotation.

Unfortunately, there's no test slice or mocking/stubbing that we can do to make it possible to test these out-of-the-box, and instead need to execute it for real.

Let's say that we want to test that a method is called once an hour:

```java
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class ScheduleHandler {

  @Scheduled(fixedRate = 3_600_000)
  public void onSchedule() {
    // do something
  }
}
```

I hope I don't surprise you, dear reader, by saying I don't want to have a test running for an hour.

So what can we do? Well, similar to the way that we make it easier to test individual components in our codebase, we'd want to employ dependency injection.

We can instead inject the schedule rate with a new property i.e. `fetch-rate`:

```diff
 import org.springframework.scheduling.annotation.Scheduled;
 import org.springframework.stereotype.Component;

 @Component
 public class ScheduleHandler {

-  @Scheduled(fixedRate = 3_600_000)
+  @Scheduled(fixedRateString = "${fetch-rate:3600000}")
   public void onSchedule() {
     // do something
   }
 }
```

This then allows us to write the following test:

```java
import static org.awaitility.Awaitility.await;
import static org.mockito.Mockito.atLeast;
import static org.mockito.Mockito.verify;

import java.time.Duration;
import java.time.temporal.ChronoUnit;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.SpyBean;
import uk.gov.api.springboot.infrastructure.ScheduleHandler;

@SpringBootTest(properties = "fetch-rate=50")
class ApplicationTest {
  @SpyBean private ScheduleHandler scheduleHandler;

  @Test
  void scheduleIsTriggered() {
    await()
        .atMost(Duration.of(200, ChronoUnit.MILLIS))
        .untilAsserted(() -> verify(scheduleHandler, atLeast(1)).onSchedule());
  }
}
```

Notice that we're using [awaitility](https://mvnrepository.com/artifact/org.awaitility/awaitility/4.1.1) for this as a handy DSL, but an alternative using `Thread.sleep`s would work, too.

Instead of placing the `fetch-rate` property in the `@SpringBootTest` annotation, we could also create the file `src/test/resources/application-test.properties`:

```ini
fetch-rate=50
```

This can also work with other expressions, such as the Spring `cron`-like:

```java
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class ScheduleHandler {

  @Scheduled(cron = "${fetch-rate:0 * * * * MON-FRI}")
  public void onSchedule() {
    // do something
  }
}
```

Which can be tested like so:

```java
import static org.awaitility.Awaitility.await;
import static org.mockito.Mockito.atLeast;
import static org.mockito.Mockito.verify;

import java.time.Duration;
import java.time.temporal.ChronoUnit;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.SpyBean;
import uk.gov.api.springboot.infrastructure.ScheduleHandler;

@SpringBootTest(properties = "fetch-rate=* * * * * *")
class ApplicationTest {
  @SpyBean private ScheduleHandler scheduleHandler;

  @Test
  void scheduleIsTriggered() {
    await()
        .atMost(Duration.of(1500, ChronoUnit.MILLIS))
        .untilAsserted(() -> verify(scheduleHandler, atLeast(1)).onSchedule());
  }
}
```
