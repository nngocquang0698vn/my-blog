---
title: "Validating a `MockMvc` Response Has No Content Type"
description: "How to validate, in a `MockMvc` test, whether the response has no `content-type` nor a body."
tags:
- blogumentation
- spring
- spring-boot
- testing
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-02T11:54:57+0000
slug: mockmvc-no-content-type
---
If you're writing tests to validate i.e. that an HTTP 406 is returned from your API when failing to negotiate, you should validate that the `content-type` of the response is not set.

In Spring (Boot), this may be achieved using a `MockMvc` test, like so:

```java
import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.Matchers.matchesRegex;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
class NegotiationIntegrationTest {

  @Autowired private MockMvc mockMvc;

  @Test
  void notAcceptableStatusIsReturnedIfNegotiationFails() throws Exception {
    mockMvc
        .perform(get("/endpoint").accept("in/valid").header("correlation-id", "not-valid"))
        .andExpect(status().isNotAcceptable())
        .andExpect(content().string("")) // empty response
        .andExpect(header().doesNotExist("content-type"));
  }
```

Or we can create a custom `ResultMatcher` and validate a little more:

```java
import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.Matchers.matchesRegex;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

  @Test
  void notAcceptableStatusIsReturnedIfNegotiationFails() throws Exception {
    mockMvc
        .perform(get("/endpoint").accept("in/valid").header("correlation-id", "not-valid"))
        .andExpect(status().isNotAcceptable())
        .andExpect(
            result -> {
              assertThat(result.getResponse().getContentType()).isNull();
              assertThat(result.getResponse().getContentLength()).isZero();
              assertThat(result.getResponse().getContentAsString()).isEmpty();
            });
  }
```

We need to do this because the `content().contentType()` call does not allows us to provide a `null` value.
