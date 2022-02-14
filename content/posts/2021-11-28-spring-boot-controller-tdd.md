---
title: "Shift Your Testing Left with Spring Boot Controllers"
description: "How to break down your tests for Spring Boot controllers, which could be used when performing Test Driven Development."
tags:
- java
- testing
- tdd
- spring-boot
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-11-28T17:31:29+0000
slug: "spring-boot-controller-tdd"
series: writing-better-tests
image: /img/vendor/spring-logo.png
---
If you're building Spring Boot apps, you'll hopefully have some test coverage of the web layer of your application.

It could be that you test the full Component/Application, in which case you'll be spinning up the full application and testing using something like a `WebClient` or Rest Assured, or you may be using a lower level Integration test, such as using `MockMvc`.

The problem with either of these test types is that they're quite slow - even when using a test slice such as a `WebMvcTest` - and if we have complex logic, or want to perform more exhaustive tests, we will start to really feel the pain of slow tests.

Slow tests - or feedback loops in general - mean that folks working on codebases wait longer, (unnecessarily) losing time, and will likely opt to run their tests less often than they should be.

Unit tests are generally a solution to this - doing something pretty quickly, for a smaller scale of objects/classes interacting. Something I've not seen much of in the past is folks writing unit tests for their web controllers.

When I first saw this in use, I was definitely condescending about it and laughed to myself about it, thinking "what was the point"? But after reading through the test cases, and having experienced the benefits, I've found it to be a really nice pattern.

This can work really nicely when using Test Driven Development (TDD) but can also be applied to pre-written code that you're wanting to break down and shift left from a Unit Integration test to a Unit Test.

# Overview

We'll use an example of building a REST(ful) API that has an endpoint `/apis`, which returns data about APIs that is returned from the service layer.

The below code snippets are taken from the example project, which is available [on GitLab](https://gitlab.com/jamietanna/spring-boot-controller-tdd).

Before we start, we'll assume that you've got a [Spring Integration Test for validating your context is configured correctly](/posts/2021/06/25/spring-context-test/), for instance with a test class called `ApplicationIntegrationTest`.

# Unit Test

First, let's start by creating a unit test for our controller, which validates that our service layer's data gets mapped correctly to the API's response data:

```java
package me.jvt.hacking.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

import java.util.Set;
import me.jvt.hacking.model.Api;
import me.jvt.hacking.model.ApiResponseContainer;
import me.jvt.hacking.service.ApiService;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;

class ApiControllerTest {
  @Mock private ApiService service;

  @InjectMocks private ApiController controller;

  @Nested
  class GetAll {
    /*
    This is a scaffolding test that can be removed when we have really implemented it
     */
    @Test
    void itReturnsContainer() {
      ApiResponseContainer actual = controller.getAll();

      assertThat(actual).isNotNull();
    }

    @Test
    void itReturnsInContainer() {
      Api api = new Api("The name", "https://example.foo/bar");
      when(service.findAll()).thenReturn(Set.of(api));

      ApiResponseContainer actual = controller.getAll();

      assertThat(actual.getApis()).contains(api);
    }
  }
}
```

As well as two model classes:

<details>

<summary>Model class implementations</summary>

```java
package me.jvt.hacking.model;

public record Api(String name, String url) {}
```

```java
package me.jvt.hacking.model;

import java.util.Set;

public class ApiResponseContainer {
  private final Set<Api> apis;

  public ApiResponseContainer(Api... apis) {
    this.apis = Set.of(apis);
  }

  public ApiResponseContainer(Set<Api> apis) {
    this.apis = Set.copyOf(apis);
  }

  public Set<Api> getApis() {
    return apis;
  }
}
```

</details>

Finally, we can then implement our controller's base implementation:

```java
package me.jvt.hacking.controller;

import java.util.Set;
import me.jvt.hacking.model.Api;
import me.jvt.hacking.model.ApiResponseContainer;
import me.jvt.hacking.service.ApiService;

public class ApiController {

  private final ApiService service;

  public ApiController(ApiService service) {
    this.service = service;
  }

  public ApiResponseContainer getAll() {
    Set<Api> apis = service.findAll();
    return new ApiResponseContainer(apis);
  }
}
```

This can then be a nice atomic commit, as we've got all of our tests passing.

# Integration Tests

Now we've got a good basis for how our endpoint fundamentally works, we can add the web layer.

This requires we test-drive the annotations by checking that the annotations are actually set:

```java
package me.jvt.hacking.integration;

import static org.hamcrest.Matchers.*;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import java.util.Set;
import me.jvt.hacking.controller.ApiController;
import me.jvt.hacking.model.Api;
import me.jvt.hacking.service.ApiService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;

@WebMvcTest(ApiController.class)
@AutoConfigureMockMvc
class ApiControllerIntegrationTest {
  @Autowired private MockMvc mvc;

  @MockBean private ApiService service;

  @Nested
  class GetAll {

    private ResultActions resultActions;

    @BeforeEach
    void setup() throws Exception {
      Api api0 = new Api("Contacts API", "https://example.com/contacts");
      Api api1 = new Api("Publishing API", "https://example.com/publishing");
      when(service.findAll()).thenReturn(Set.of(api0, api1));

      resultActions = mvc.perform(get("/apis"));
    }

    @Test
    void returns200() throws Exception {
      resultActions.andExpect(status().isOk());
    }

    @Test
    void returnsJson() throws Exception {
      resultActions.andExpect(header().string("content-type", "application/json"));
    }

    @Test
    void containsItems() throws Exception {
      resultActions.andExpect(jsonPath("$.apis").isArray());
    }

    @Test
    void containsApiData() throws Exception {
      resultActions
          .andExpect(
              jsonPath("$.apis[*].name")
                  .value(containsInAnyOrder("Contacts API", "Publishing API")))
          .andExpect(
              jsonPath("$.apis[*].url")
                  .value(
                      containsInAnyOrder(
                          "https://example.com/contacts", "https://example.com/publishing")));
    }
  }
}
```

To get this test passing, all we need to do is add the annotations to our controller:

```diff
diff --git src/main/java/me/jvt/hacking/controller/ApiController.java src/main/java/me/jvt/hacking/controller/ApiController.java
index 4afdce0..78a32df 100644
--- src/main/java/me/jvt/hacking/controller/ApiController.java
+++ src/main/java/me/jvt/hacking/controller/ApiController.java
@@ -4,7 +4,12 @@ import java.util.Set;
 import me.jvt.hacking.model.Api;
 import me.jvt.hacking.model.ApiResponseContainer;
 import me.jvt.hacking.service.ApiService;
+import org.springframework.web.bind.annotation.GetMapping;
+import org.springframework.web.bind.annotation.RequestMapping;
+import org.springframework.web.bind.annotation.RestController;

+@RestController
+@RequestMapping("/apis")
 public class ApiController {

   private final ApiService service;
@@ -13,6 +18,7 @@ public class ApiController {
     this.service = service;
   }

+  @GetMapping
   public ApiResponseContainer getAll() {
     Set<Api> apis = service.findAll();
     return new ApiResponseContainer(apis);
```

Now we may find that `ApplicationIntegrationTest` is failing to run, because the `ApiService` cannot be injected by Spring.

To start off with, we can create a straightforward no-op implementation:

```java
package me.jvt.hacking.service;

import java.util.Collections;
import java.util.Set;
import me.jvt.hacking.model.Api;
import org.springframework.stereotype.Component;

@Component
public class NoopApiService implements ApiService {
  @Override
  public Set<Api> findAll() {
    return Collections.emptySet();
  }
}
```

This gives us enough to get the build passing, and then we're not implementing too much in a single commit.

# What's next?

Next, we'd go on to implement the service fully, managing the logic for the slice, perhaps with a `NoopApiRepository`.

We could also start to test drive in validation of the incoming request's contract, for instance requiring a [tracking ID](/posts/2021/11/22/correlation-ids/).

# Conclusion

This has given us a worked example of iterating to create a new controller for your Spring Boot application, with small slices of functionality, with speedy tests!

Hopefully this will also help with looking at how we'd be able to break down an existing test suite, where we have our Integration test focussing purely on any Spring annotations, or anything related to the web layer.
