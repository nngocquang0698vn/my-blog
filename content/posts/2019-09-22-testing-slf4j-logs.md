---
title: "Testing Your SLF4J Logs"
description: "Looking at how we would unit test our SLF4J logs to gain confidence\
  \ they work, and to catch regressions in the future."
date: "2019-09-22T14:16:56+0100"
tags:
- "blogumentation"
- "testing"
- "java"
- "slf4j"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "testing-slf4j-logs"
image: https://media.jvt.me/adfddc977a.jpeg
---
Logging is a very important part of your application. You can be the best developer and never write a bug, but a service you depend on may go down, or the framework you're using may have an issue, so you need to be able to diagnose it without attaching a debugger to your production server. But if you're not testing that your logging works, you won't be sure until one of these disaster scenarios occur whether it's actually hooked in correctly, as well as not being able to catch if someone accidentally removes a logging line in a refactor.

A very popular logging library in the Java ecosystem is [SLF4J](https://www.slf4j.org/), and we'll look at how we can test we've set things up correctly.

The repository for this article can be found at [<i class="fa fa-gitlab"></i> jamietanna/slf4j-testing](https://gitlab.com/jamietanna/slf4j-testing), and we use [valfirst's slf4j-test](https://github.com/valfirst/slf4j-test).

Note that a previous version of this article referenced [lidalia's slf4j-test](https://projects.lidalia.org.uk/slf4j-test/), but this appears to be no longer maintained.

Let's say that we have this example class that does some processing of data, as well as logging:

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ClassThatLogs {

  private static final Logger LOGGER = LoggerFactory.getLogger(ClassThatLogs.class);

  public void doSomething(boolean logErrors) {
    LOGGER.debug("The boolean passed in has value {}", logErrors);
    if (logErrors) {
      LOGGER.error("this is because there's a boolean=true");
    }
    LOGGER.info("this is happening no matter what");
  }
}
```

We can follow the [Getting Started guide for the legacy project](https://projects.lidalia.org.uk/slf4j-test/) (as it's still sufficient) and add the [slf4j-test dependency](https://mvnrepository.com/artifact/com.github.valfirst/slf4j-test/) to our codebase, then write a test class (in this example using the custom AssertJ bindings provided by the library) to make it easier to assert that the logs are present at the right level:

```java
import static com.github.valfirst.slf4jtest.Assertions.assertThat;
import static com.github.valfirst.slf4jtest.LoggingEvent.debug;
import static com.github.valfirst.slf4jtest.LoggingEvent.error;
import static com.github.valfirst.slf4jtest.LoggingEvent.info;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import com.github.valfirst.slf4jtest.TestLogger;
import com.github.valfirst.slf4jtest.TestLoggerFactory;
import uk.org.lidalia.slf4jext.Level;

class ClassThatLogsTest {

  private final TestLogger logger = TestLoggerFactory.getTestLogger(ClassThatLogs.class);
  private final ClassThatLogs sut = new ClassThatLogs();

  @AfterEach
  void tearDown() {
    logger.clear();
  }

  @Test
  void methodLogsErrorWhenBooleanIsTrue() {
    // given

    // when
    sut.doSomething(true);

    // then
    assertThat(logger).hasLogged(Level.ERROR, "this is because there's a boolean=true");
  }

  @Test
  void methodDoesNotLogErrorWhenBooleanIsFalse() {
    // given

    // when
    sut.doSomething(false);

    // then
    assertThat(logger).hasNotLogged(Level.ERROR, "this is because there's a boolean=true");
  }

  @Test
  void methodLogsInfoRegardless() {
    // given

    // when
    sut.doSomething(false);

    // then
    assertThat(logger).hasLogged(Level.INFO, "this is happening no matter what");
  }

  @Test
  void methodLogsFormatStringsInDebugMode() {
    // given

    // when
    sut.doSomething(false);

    // then
    assertThat(logger).hasLogged(Level.DEBUG, "The boolean passed in has value {}", false);
  }
}
```

We can see that this is fairly straightforward, and allows us to assert clearly on what is being logged.
