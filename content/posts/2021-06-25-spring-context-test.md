---
title: "Testing that your Spring Boot Application Context is Correctly Configured"
description: "How to improve the tests you've got to validate that Spring Boot's context is set up correctly."
tags:
- java
- spring-boot
- testing
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-06-25T09:09:35+0100
slug: "spring-context-test"
series: writing-better-tests
image: /img/vendor/spring-logo.png
---
Working with Spring/Spring Boot apps, you've very likely landed with the dreaded:

```
java.lang.IllegalStateException: Failed to load ApplicationContext
```

It's bad enough when your tests aren't set up, but I've had this after waiting ~2 hours to get a change released to a production environment, only to find we'd missed some config for a specific profile.

Because of this, the first test I write when I start a new Spring Boot project, or pick up an existing one that doesn't have this test, is:

```java
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
// you could use `@ActiveProfiles`, too
class ApplicationIntegrationTest {

  @Test
  void contextLoads() {
    // empty test that would fail if our Spring configuration does not load correctly
  }
}
```

This validates that Spring's context is configured correctly for our application, and makes sure we've got things like bean/property definitions.

However, this test isn't perfect! Although, yes, the test will fail before it executes if the context isn't set, we can get the test passing incorrectly by putting it into the wrong package, or removing the Spring Boot configuration:

```diff
 import org.junit.jupiter.api.Test;
 import org.junit.jupiter.api.extension.ExtendWith;
-import org.springframework.boot.test.context.SpringBootTest;

-@SpringBootTest
 class ApplicationIntegrationTest {

   @Test
   void contextLoads() {
     // empty test that would fail if our Spring configuration does not load correctly
   }
 }
```

These allow the empty test case to continue to pass, silently, while our application is broken.

Instead, we can improve what we've got to the following test case:

```java
import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;

@SpringBootTest
class ApplicationIntegrationTest {
  @Test
  void contextLoads(ApplicationContext context) {
    assertThat(context).isNotNull();
  }
}
```

This ensures that we've got the context, and it's been set up successfully. In the cases above where we omit the `@SpringBootTest`, this test will fail!

(Using JUnit5, the `ApplicationContext` is injected automagically, but we could replace this with an `@Autowired` field, too.)

We can also validate that specific beans are instantiated, for instance checking that there's a bean for class `IndieAuthController`:

```java
@Test
void hasIndieAuthControllerConfigured(ApplicationContext context) {
  assertThat(context.getBean(AccessTokenVerifier.class)).isNotNull();
}
```

Or for a specific bean's name (i.e via `@Qualifier`):

```java
@Test
void hasIndieAuthControllerConfigured(ApplicationContext context) {
  assertThat(context.getBean("accessTokenVerifier")).isNotNull();
}
```
