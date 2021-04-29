---
title: "How to get a field with Reflection in Java"
description: "How to use Java's Reflection to get access to a private of a class."
tags:
- blogumentation
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-04-29T19:16:51+0100
slug: "reflection-get-field"
---
Today, while looking into [server-less Wiremock]({{< ref 2021-04-29-wiremock-serverless >}}), I wanted to retrieve a (private) field from a class.

Interestingly, most of the Stack Overflow posts I found weren't super helpful, but [this reply from Lino](https://stackoverflow.com/questions/55295245/how-to-get-field-value-in-java-reflection/55295256#55295256) helped me track it down:

```java
WireMockServer server = new WireMockServer();
try {
  Field field = WireMockServer.class.getDeclaredField("stubRequestHandler");
  field.setAccessible(true);
  handler = (StubRequestHandler) field.get(server);
  // yay!
} catch (NoSuchFieldException | IllegalAccessException e) {
  throw new RuntimeException(e);
}
```
