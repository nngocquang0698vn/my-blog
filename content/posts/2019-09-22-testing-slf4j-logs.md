---
title: "Testing Your SLF4J Logs"
description: "Looking at how we would unit test our SLF4J logs to gain confidence they work, and to catch regressions in the future."
tags:
- blogumentation
- testing
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-22T14:16:56+0100
slug: "testing-slf4j-logs"
---
Logging is a very important part of your application. You can be the best developer and never write a bug, but a service you depend on may go down, or the framework you're using may have an issue, so you need to be able to diagnose it without attaching a debugger to your production server. But if you're not testing that your logging works, you won't be sure until one of these disaster scenarios occur whether it's actually hooked in correctly, as well as not being able to catch if someone accidentally removes a logging line in a refactor.

A very popular logging library in the Java ecosystem is [SLF4J](https://www.slf4j.org/), and we'll look at how we can test we've set things up correctly.

The repository for this article can be found at [<i class="fa fa-gitlab"></i> jamietanna/slf4j-testing](https://gitlab.com/jamietanna/slf4j-testing), and the examples are based on [davidxxx's response on Stack Overflow](https://stackoverflow.com/a/52229629).

Let's say that we have this example class that does some processing of data, as well as logging:

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ClassThatLogs {

  private static final Logger LOGGER = LoggerFactory.getLogger(ClassThatLogs.class);

  public void doSomething(boolean doSomethingElse) {
    LOGGER.debug("The boolean passed in has value {}", logErrors);
    // do some stuff
    LOGGER.info("this is logging something else");
    // do some other stuff
  }
}
```

To test that these logs are send correctly, we're able to hook into the underlying Logback code and get a `ListAppender` object, which contains all the log events for a given `Logger`. Note that it's best to this into separate utility class so we can re-use the code around the project, instead of having these lines duplicated across test classes.

```java
import ch.qos.logback.classic.Logger;
import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.read.ListAppender;
import org.slf4j.LoggerFactory;

public class LoggerTestUtil {
  public static ListAppender<ILoggingEvent> getListAppenderForClass(Class clazz) {
    Logger logger = (Logger) LoggerFactory.getLogger(clazz);

    ListAppender<ILoggingEvent> loggingEventListAppender = new ListAppender<>();
    loggingEventListAppender.start();

    logger.addAppender(loggingEventListAppender);

    return loggingEventListAppender;
  }
}
```

Now we have a straightforward setup, and can take advantage of AssertJ to make it easier to assert that the logs are present at the right level:

```java
import static org.assertj.core.api.Java6Assertions.assertThat;

import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.read.ListAppender;
import org.assertj.core.groups.Tuple;
import org.junit.Before;
import org.junit.Test;

public class ClassThatLogsTest {

  private ListAppender<ILoggingEvent> loggingEventListAppender;
  private ClassThatLogs sut;

  @Before
  public void setup() {
    loggingEventListAppender = LoggerTestUtil.getListAppenderForClass(ClassThatLogs.class);

    sut = new ClassThatLogs();
  }

  // other tests

  @Test
  public void methodLogsInfoRegardless() {
    // given

    // when
    sut.doSomething(false);

    // then
    assertThat(loggingEventListAppender.list)
        .extracting(ILoggingEvent::getMessage, ILoggingEvent::getLevel)
        .contains(Tuple.tuple("this is logging something else", Level.INFO));
  }

  @Test
  public void methodLogsFormatStringsInDebugMode() {
    // given

    // when
    sut.doSomething(false);

    // then
    assertThat(loggingEventListAppender.list)
        .extracting(ILoggingEvent::getMessage, ILoggingEvent::getFormattedMessage,
            ILoggingEvent::getLevel)
        .contains(Tuple
            .tuple("The boolean passed in has value {}", "The boolean passed in has value false",
                Level.DEBUG));
  }
}
```

Notice that when we are using a format string we have two checks on the log message - `getMessage` returns the raw message (including format placeholders), but `getFormattedMessage` returns the expanded log message.

As <span class="h-card"><a class="u-url" href="https://www.testingsyndicate.com/">Jack Gough</a></span> pointed out, there is also the library [slf4j-test](https://projects.lidalia.org.uk/slf4j-test/). I had originally not put this as the source repository does not seem to have a license - it appears the license is somewhere on the website, because I found [a Pull Request raised to add that the license to the repo](https://github.com/Mahoney/slf4j-test/pull/23). The project seems dormant as there have been no updates in over 4 years, and there are PRs open since 2016, so use at your own risk!
