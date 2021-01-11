---
title: "Inexactly Comparing `MediaType`s with Spring"
description: "How to compare Spring's `MediaType` by ignoring charset or parameters."
tags:
- blogumentation
- spring
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-12-12T17:28:20+0000
slug: "compare-spring-mediatype"
---
When we're interacting with a `HttpServletRequest` and we want to do something based on the `Accept` / `Content-Type` header, for instance within a `HandlerMethodArgumentResolver`, we would lean on Spring's `MediaType` class to parse the string value.

But the issue is that this doesn't always work for what we want it to.

For instance, if you're expecting `application/json`, but receive a request with `application/json;charset=UTF-8` or `application/json;v=1` will not match.

Update 2021-01-11: Although the below may be helpful, it is unnecessary as `MediaType` provides the [`isCompatibleWith` method](https://www.javadoc.io/doc/org.springframework/spring-web/latest/org/springframework/http/MediaType.html) for this exact reason!

The solution I've used is the below, to provide us a straightforward way to ignore parameters from the equality check:

```java
private boolean compareMediaType(MediaType lhs, MediaType rhs) {
  if (null == lhs || null == rhs) {
    return false;
  }

  return lhs.getType().equals(rhs.getType()) && lhs.getSubtype().equals(rhs.getSubtype());
}
```
