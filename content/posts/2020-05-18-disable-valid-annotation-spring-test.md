---
title: "Disabling `@Valid` Annotation in a Spring Integration Test"
description: "How to disable `@Valid` validation in Spring Integration Tests."
tags:
- blogumentation
- java
- spring
- spring-boot
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-18T19:44:52+0100
slug: "disable-valid-annotation-spring-test"
---
Today I was writing some Spring integration tests to validate some new endpoints had a `Filter` applied correctly, but I was fighting with the endpoint methods requiring the request to be valid.

This was because the request body was annotated with `@Valid` (but is true for other [JSR380](https://jcp.org/en/jsr/detail?id=380) annotations) which Spring Boot then adds validation for - [_Validation in Spring Boot_ on Baeldung](https://www.baeldung.com/spring-boot-bean-validation) has some good information about it.

I didn't really want each request I was sending to require full validation, as the requests required a lot of setup, and that wasn't really what I was trying to test at this point.

Thanks to my colleague James, I now have a way around that!

Spring Boot 2.x.x uses a `LocalValidatorFactoryBean` to orchestrate the validation of these, which means if you provide the following `MockBean`, you can remove its validation:

```java
@MockBean private LocalValidatorFactoryBean validator;
```

Leaving it without any test setup will disable any validation that may be performed for `@Valid` annotations as there is no implementation behind it to perform validation. But if you want to do anything extra, you can set it up as needed.
