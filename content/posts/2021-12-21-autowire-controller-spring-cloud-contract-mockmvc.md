---
title: "Autowiring your controllers automagically when using MockMVC and Spring Cloud Contract"
description: "How to automagically set up your Spring controllers when using MockMVC with Spring Cloud Contract."
tags:
- blogumentation
- spring
- spring-boot
- spring-cloud-contract
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-21T12:48:26+0000
slug: autowire-controller-spring-cloud-contract-mockmvc
image: /img/vendor/spring-logo.png
---
If you're building Spring (Boot) web APIs, you may be using [Spring Cloud Contract](https://spring.io/projects/spring-cloud-contract) for Consumer Driven Contract testing, to ensure that you're not pushing out breaking changes to your APIs.

In the case you're using MockMVC as your HTTP client layer, you may have a base test class defined similar to the documentation:

```java
// via https://docs.spring.io/spring-cloud-contract/docs/3.1.0/reference/html/getting-started.html#getting-started-first-application-producer
package com.example.contractTest;

import org.junit.Before;

import io.restassured.module.mockmvc.RestAssuredMockMvc;

public class BaseTestClass {

    @Before
    public void setup() {
        RestAssuredMockMvc.standaloneSetup(new FraudController());
    }
}
```

However, you'll note that this requires you adding each controller manually.

You may amend it so you can make each controller `@Autowired` when running under `@SpringBootTest`, so you don't have to construct them all, but it still doesn't really scale nicely in the case you've got quite a few controllers, or that you're adding on extra work each time you want to introduce a new controller.

To make this easier, we can take one of two approaches to automagically wire in all our controllers:

# Using the `WebApplicationContext`

The easiest way of doing this is to hook in an autowired `WebApplicationContext` which will have all the context required for the MockMVC setup:

```java
import io.restassured.module.mockmvc.RestAssuredMockMvc;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.web.context.WebApplicationContext;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@DirtiesContext
public class BaseTestClass {

  @Autowired WebApplicationContext context;

  @BeforeEach
  void setup() {
    RestAssuredMockMvc.webAppContextSetup(context);
  }
}
```

# Manually configuring beans

Alternatively, we can manually find all the beans that are required and hook them in:

```java
import io.restassured.module.mockmvc.RestAssuredMockMvc;
import java.lang.annotation.Annotation;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.web.bind.annotation.RestController;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@DirtiesContext
public class BaseTestClass {

  @Autowired private ApplicationContext context;

  @BeforeEach
  void setup() {
    RestAssuredMockMvc.standaloneSetup(getBeansOfType(RestController.class, context));
    RestAssuredMockMvc.standaloneSetup(getBeansOfType(Controller.class, context));
  }

  private static Object[] getBeansOfType(
      Class<? extends Annotation> annotationType, ApplicationContext context) {
    var beans = context.getBeansWithAnnotation(annotationType);
    var list = beans.values().stream().toList();
    return list.toArray();
  }
}
```
