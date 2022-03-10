---
title: "How to fix `Failed to load ApplicationContext` in Spring (Boot) applications"
description: "Some common issues with Spring dependency injection and how to fix them."
tags:
- blogumentation
- spring
- spring-boot
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-03-10T16:04:55+0000
slug: spring-failed-applicationcontext
image: https://media.jvt.me/3e88e3081a.png
syndication:
- "https://brid.gy/publish/twitter"
---
When building Spring (Boot) applications, it's almost inevitable to be hit with the reliable `Failed to load ApplicationContext` exception.

This occurs when the Spring Dependency Injection (DI) framework is unable to wire together beans (dependencies for classes).

As noted in [_Testing that your Spring Boot Application Context is Correctly Configured_](/posts/2021/06/25/spring-context-test/), one way of catching this, at least before it hits production, is by making sure that you have a test to cover this.

But even with that test, you will still have cases where dependencies are not wired up correctly, and you need to resolve it.

Unfortunately I can't solve this _exactly_ for you, as there's very likely to be some context in your stacktrace that, tied to the way your application works, but we can use a few examples to hopefully provide a bit more of an idea of how to work it out for yourself.

The following stacktraces are examples, and won't match exactly what you have. I've also modified them a bit for brevity and broken long lines down so they're hopefully more readable.

# Example project

These examples have been taken from [an example Spring Boot app](https://gitlab.com/jamietanna/spring-boot-controller-tdd) which has been modified to cause these errors.

You can find the classes of relevance below:

<details>

<summary><code>ApiController.java</code></summary>

```java
import java.util.Set;
import java.util.stream.Collectors;
import me.jvt.hacking.domain.service.ApiService;
import me.jvt.hacking.infrastructure.models.Api;
import me.jvt.hacking.infrastructure.models.ApiResponseContainer;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/apis")
public class ApiController {

  private final ApiService service;

  public ApiController(ApiService service) {
    this.service = service;
  }

  @GetMapping
  public ApiResponseContainer getAll() {
    Set<Api> apis =
        service.findAll().stream()
            .map(ApiController::toApiResponseObject)
            .collect(Collectors.toSet());
    return new ApiResponseContainer(apis);
  }

  private static Api toApiResponseObject(me.jvt.hacking.domain.model.Api a) {
    return new Api(a.name(), a.url());
  }
}
```

</details>

<details>

<summary><code>SpringConfiguration.java</code></summary>

```java
import me.jvt.hacking.domain.service.ApiService;
import me.jvt.hacking.domain.service.NoopApiService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SpringConfiguration {
  @Bean
  public ApiService apiService() {
    return new NoopApiService();
  }
}
```

</details>

<details>

<summary><code>NoopApiService.java</code></summary>


```java
import java.util.Collections;
import java.util.Set;
import me.jvt.hacking.domain.model.Api;

public class NoopApiService implements ApiService {

  @Override
  public Set<Api> findAll() {
    return Collections.emptySet();
  }
}
```
</details>

# Missing bean definition

One common issue is where we have a Spring bean that hasn't been defined, but needs to be because another class depends on it.

## Stacktrace

```
Failed to load ApplicationContext
java.lang.IllegalStateException: Failed to load ApplicationContext
Caused by: org.springframework.beans.factory.UnsatisfiedDependencyException:
  Error creating bean with name 'apiController' defined in file
    [.../build/classes/java/main/me/jvt/hacking/infrastructure/controller/ApiController.class]:
  Unsatisfied dependency expressed through constructor parameter 0;
  nested exception is org.springframework.beans.factory.NoSuchBeanDefinitionException:
      No qualifying bean of type 'me.jvt.hacking.domain.service.ApiService' available:
      expected at least 1 bean which qualifies as autowire candidate.
      Dependency annotations: {}
	... 85 more
Caused by: org.springframework.beans.factory.NoSuchBeanDefinitionException:
  No qualifying bean of type 'me.jvt.hacking.domain.service.ApiService' available:
  expected at least 1 bean which qualifies as autowire candidate. Dependency annotations: {}
	... 103 more
```

## Cause

This was created by the following in the `SpringConfiguration` class:

```java
@Configuration
public class SpringConfiguration {}
```

In this case, we need to make sure an `ApiService` is configured, either by adding the Bean configuration to a `@Configuration` class (which is the current state of the `SpringConfiguration`, shown at the top of the post), or by using Component Scanning on the `NoopApiService`:

```diff
 import java.util.Collections;
 import java.util.Set;
 import me.jvt.hacking.domain.model.Api;
+import org.springframework.stereotype.Component;

+@Component
 public class NoopApiService implements ApiService {

   @Override
```

# Too many beans defined

Another common issue is when we've got multiple beans defined, and Spring can't work out how to inject them.

## Stacktrace

```
Failed to load ApplicationContext
java.lang.IllegalStateException: Failed to load ApplicationContext
  Caused by: org.springframework.beans.factory.UnsatisfiedDependencyException:
  Error creating bean with name 'apiController' defined in file [.../build/classes/java/main/me/jvt/hacking/infrastructure/controller/ApiController.class]:
  Unsatisfied dependency expressed through constructor parameter 0;
  nested exception is org.springframework.beans.factory.NoUniqueBeanDefinitionException:
  No qualifying bean of type 'me.jvt.hacking.domain.service.ApiService' available:
  expected single matching bean but found 2:
    noopApiService,apiService
    ... 85 more
Caused by: org.springframework.beans.factory.NoUniqueBeanDefinitionException:
  No qualifying bean of type 'me.jvt.hacking.domain.service.ApiService' available:
  expected single matching bean but found 2: noopApiService,apiService
    ... 103 more
```

## Cause

This can be caused by us either having two beans defined like so, or i.e. a mix of `@Component`s and `@Bean`s.

```java
import me.jvt.hacking.domain.service.ApiService;
import me.jvt.hacking.domain.service.NoopApiService;
import me.jvt.hacking.domain.service.RealApiService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SpringConfiguration {
  @Bean
  public ApiService apiService() {
    return new NoopApiService();
  }

  @Bean
  public ApiService another() {
    return new RealApiService();
  }
}
```

Sometimes, this is an indicator of an error in the application, and _not_ needing two of the same thing.

However, this could also be a case of using two classes in the same inheritance hierarchy, such as [Jackson's `ObjectMapper` and `YAMLMapper`](https://www.jvt.me/posts/2022/01/10/jackson-yaml-json/), in which case we _do_ need two of these.

For instance, we would modify our bean definition in this case like so:

```java
@Configuration
public class SpringConfiguration {
  // ...

  /*
  this uses the bean with name `apiService`, which in our case is the `NoopApiService`
   */
  @Bean
  public ApiController apiController(ApiService apiService) {
    return new ApiController(apiService);
  }
}
```

Alternatively, we can be explicit if we don't want to let it rely on the variable name:

```java
import org.springframework.beans.factory.annotation.Qualifier;

@Configuration
public class SpringConfiguration {
  // ...

  @Bean
  public ApiController apiController(@Qualifier("apiService") ApiService service) {
    return new ApiController(service);
  }
}
```

Or we could make it clear that a single bean is the default (and allow consumers who want a specific bean to use one of the other options above):

```java
import org.springframework.beans.factory.annotation.Primary;

@Configuration
public class SpringConfiguration {

  @Bean
  @Primary
  public ApiService another() {
    return new RealApiService();
  }
  // ...

  @Bean
  public ApiController apiController(ApiService service) {
    return new ApiController(service);
  }
}
```

# Missing default value for a property

Another common issue is referencing a Spring property in your bean definition, but then forgetting to add a default value.

## Stacktrace

```
Failed to load ApplicationContext
java.lang.IllegalStateException: Failed to load ApplicationContext
Caused by: org.springframework.beans.factory.UnsatisfiedDependencyException:
  Error creating bean with name 'apiController' defined in file
    [.../build/classes/java/main/me/jvt/hacking/infrastructure/controller/ApiController.class]:
  Unsatisfied dependency expressed through constructor parameter 0;
  nested exception is org.springframework.beans.factory.BeanCreationException:
    Error creating bean with name 'apiService' defined in class path resource [me/jvt/hacking/application/SpringConfiguration.class]:
    Unexpected exception during bean creation;
    nested exception is java.lang.IllegalArgumentException:
      Could not resolve placeholder 'example.property' in value "${example.property}"
	...
Caused by: org.springframework.beans.factory.BeanCreationException:
  Error creating bean with name 'apiService' defined in class path resource [me/jvt/hacking/application/SpringConfiguration.class]:
  Unexpected exception during bean creation;
  nested exception is java.lang.IllegalArgumentException: Could not resolve placeholder 'example.property' in value "${example.property}"
	...
Caused by: java.lang.IllegalArgumentException:
  Could not resolve placeholder 'example.property' in value "${example.property}"
	...
```

## Cause

In this case, we've got the following class:

```java
import me.jvt.hacking.domain.service.ApiService;
import me.jvt.hacking.domain.service.NoopApiService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SpringConfiguration {
  @Bean
  public ApiService apiService(@Value("${example.property}") String property) {
    return new NoopApiService(property);
  }
}
```

But we won't have provided a default anywhere, whether that's in an `application.properties`, `application-production.properties`, `application.yml`, environment variable, or on the command-line when running the JAR.

The first solution is to make sure that anywhere that sets configuration, as mentioned above, has the default set.

Alternatively, if this is something we can reasonably default, we could make the following change:

```diff
 import me.jvt.hacking.domain.service.ApiService;
 import me.jvt.hacking.domain.service.NoopApiService;
 import org.springframework.beans.factory.annotation.Value;
 import org.springframework.context.annotation.Bean;
 import org.springframework.context.annotation.Configuration;

 @Configuration
 public class SpringConfiguration {
   @Bean
-  public ApiService apiService(@Value("${example.property}") String property) {
+  public ApiService apiService(@Value("${example.property:default}") String property) {
     return new NoopApiService(property);
   }
 }
```
