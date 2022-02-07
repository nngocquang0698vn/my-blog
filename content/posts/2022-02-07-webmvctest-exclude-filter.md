---
title: "Excluding `Filter`s When using `WebMvcTest`"
description: "How to exclude specific `Filter`s from running when performing `WebMvcTest`s."
tags:
- blogumentation
- java
- spring
- spring-boot
- testing
- tdd
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-07T10:55:12+0000
slug: webmvctest-exclude-filter
syndication:
- "https://brid.gy/publish/twitter"
---
As noted in my article [Shift Your Testing Left with Spring Boot Controllers](/posts/2021/11/28/spring-boot-controller-tdd/#integration-tests), the aim of writing `WebMvcTest`s is to verify that Spring annotations are set on the class, and that it actually responds as a controller.

Although it's an integration test, we should try and keep our test slice as thin as possible.

For instance, we may have `Filter`s running in the background, which may be requiring that [we have a `correlation-id` sent in each request](/posts/2021/11/22/correlation-ids/), which is adding additional complexity in our requests.

Let's say that our test class is being set up with the following annotation:

```java
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;

@WebMvcTest(MetadataController.class)
```

We'd now be able to tweak this to:

```java
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;

@WebMvcTest(
    value = MetadataController.class,
    excludeFilters =
        @ComponentScan.Filter(
            type = FilterType.ASSIGNABLE_TYPE,
            classes = CorrelationIdFilter.class))
```

And our tests would no longer be using the `CorrelationIdFilter`.
