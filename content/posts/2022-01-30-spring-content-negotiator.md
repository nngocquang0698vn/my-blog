---
title: "Announcing `spring-content-negotiator`, a Java Library for Content Negotiation with Spring"
description: "Releasing a new library that can support content negotiation in Spring (Boot) applications, i.e. in `Filter`s or `ExceptionHandlers`."
tags:
- spring
- spring-boot
- spring-content-negotiator
- content-negotiation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-30T08:35:22+0000
slug: spring-content-negotiator
---
I recently wrote about cases in Spring (Boot) applications where we aren't as easily able to perform content-negotiation, as it's not an easy annotation away for different representations:

- [_Content Negotiation with `ControllerAdvice` and `ExceptionHandlers` in Spring (Boot)_](/posts/2022/01/18/spring-negotiate-exception-handler/)
- [_Content Negotiation with Servlet `Filter` in Spring (Boot)_](/posts/2022/01/18/spring-negotiate-servlet-filter/)

I provided sample code for how to do this, but as there's a bit of boilerplate that's needed to get it working, I've now released this as its own library, [spring-content-negotiator](https://gitlab.com/jamietanna/spring-content-negotiator), which simplifies setup.

It's available on Maven Central under the group `me.jvt.spring`, as well as [example code](https://gitlab.com/jamietanna/spring-content-negotiator/-/tree/main/src/test/java/me/jvt/spring/examples) for how to integrate with it.
