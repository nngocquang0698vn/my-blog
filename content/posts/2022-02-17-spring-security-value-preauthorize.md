---
title: "How to interpolate a property inside Spring Security `@PreAuthorize` / `@PostAuthorize`"
description: "How to use the value of a property in a Spring Security authorization statement."
tags:
- blogumentation
- java
- spring
- spring-boot
- spring-security
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-17T16:35:03+0000
slug: "spring-security-value-preauthorize"
syndication:
- "https://brid.gy/publish/twitter"
image: /img/vendor/spring-logo.png
---
If you're using Spring Security to authorize your application's authentication and authorization needs, you may want to extract some of your rules to configuration, rather than code, to allow quicker changes to the rulesets.

For instance, in this very contrived example, we may have an endpoint that can only be accessed by a single user in our system, `bob`.

Our code starts to look like this:

```java
import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/apis")
public class ApiController {

  @GetMapping
  @PreAuthorize("authentication.name == 'bob'")
  public List<String> getAll() {
    return List.of("Api name here", "another");
  }
}
```

Which has the following Integration Test:

```java
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import me.jvt.hacking.application.Application;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(ApiController.class)
@ContextConfiguration(classes = Application.class)
@AutoConfigureMockMvc
class ApiControllerIntegrationTest {
  @Autowired private MockMvc mvc;

  @Test
  @WithMockUser("bob")
  void whenBob() throws Exception {
    mvc.perform(get("/apis")).andExpect(status().isOk());
  }

  @Test
  @WithMockUser("alan")
  void whenNotBob() throws Exception {
    mvc.perform(get("/apis")).andExpect(status().isForbidden());
  }
}
```

But if we were to need to migrate the access away from `bob` and instead to `jessica`, we'd need to introduce code changes, which are slower than a tweak in our `application.properties` i.e.:


```ini
authorization.users.apis-endpoint=bob
```

Unfortunately, Spring Security doesn't allow us to interpolate the value of a property in the `@PreAuthorize` / `@PostAuthorize` annotations, using the Spring Expression Language (SPEL).

Fortunately, Spring Security can delegate to a method provided by a bean in the application context, so we can create a central class for this logic - which is beneficial as it's unit-testable, and can contain other, more complex rules:

```java
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class ApisEndpointAuthorizer {
  private final String validPrincipal;

  public ApisEndpointAuthorizer(@Value("${authorization.users.apis-endpoint") String validPrincipal) {
    this.validPrincipal = validPrincipal; // this could also become a `Set<String>`
  }

  public boolean isAuthorized(String principal) { // this could take the `authentication`, and do other checks, too
    return validPrincipal.equals(principal);
  }
}
```

This allows our controller to reference the bean's method `isAuthorized` like so:

```java
import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/apis")
public class ApiController {

  @GetMapping
  @PreAuthorize("@apisEndpointAuthorizer.isAuthorized(authentication.name)")
  public List<String> getAll() {
    return List.of("Api name here", "another");
  }
}
```

And as we're aiming to mock as much as possible, we'd have our Integration Test like so:

```java
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import me.jvt.hacking.Application;
import me.jvt.hacking.infrastructure.ApisEndpointAuthorizer;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(ApiController.class)
@ContextConfiguration(classes = Application.class)
@AutoConfigureMockMvc
class ApiControllerIntegrationTest {
  @Autowired private MockMvc mvc;

  @MockBean(name = "apisEndpointAuthorizer") // required, as otherwise its name isn't correct
  private ApisEndpointAuthorizer apisEndpointAuthorizer;

  @Test
  @WithMockUser("bob")
  void whenAuthorized() throws Exception {
    when(apisEndpointAuthorizer.isAuthorized(any())).thenReturn(true);

    mvc.perform(get("/apis")).andExpect(status().isOk());
  }

  @Test
  @WithMockUser("alan")
  void whenNotAuthorized() throws Exception {
    when(apisEndpointAuthorizer.isAuthorized(any())).thenReturn(false);

    mvc.perform(get("/apis")).andExpect(status().isForbidden());
  }
}
```

And then we'd have a full integration test:

```java
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@AutoConfigureMockMvc
class ApplicationIntegrationTest {
  @Autowired private MockMvc mvc;

  @Test
  @WithMockUser("bob")
  void whenAuthorized() throws Exception {
    mvc.perform(get("/apis")).andExpect(status().isOk());
  }

  @Test
  @WithMockUser("alan")
  void whenNotAuthorized() throws Exception {
    mvc.perform(get("/apis")).andExpect(status().isForbidden());
  }
}
```
