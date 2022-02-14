---
title: "Returning a Value, or a Default, From a Java `Optional`"
description: "How to replace imperative code with a functional style, when returning a default value for a Java `Optional`."
tags:
- blogumentation
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-13T09:53:51+0000
slug: "java-optional-return-or-else"
image: https://media.jvt.me/7e70383567.png
---
Java `Optional`s are great for giving you flexibility over interacting with values that may not be present, and include a means for more safely retrieving values from nullable types.

For instance, you may want to call a method on a maybe-`null` object passed into your method, or return a default value:

```java
private static String getName(Principal nullable) {
  Optional<Principal> maybePrincipal = Optional.ofNullable(nullable);
  if (maybePrincipal.isPresent()) {
    return maybePrincipal.get().getName();
  } else {
    return "<unknown>";
  }
}
```

This is fine, but doesn't follow the functional style that's possible with the `Optional` class.

What you may want to do instead is the following (linebreaks added for visibility):

```java
private static String getName(Principal nullable) {
  Optional<Principal> maybePrincipal = Optional.ofNullable(nullable);
  return maybePrincipal
    .map(Principal::getName)
    .orElse("<unknown>");
}
```
