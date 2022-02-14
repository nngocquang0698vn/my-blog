---
title: "Validating UUIDs with Regular Expressions in Java"
description: "How to validate UUIDs and UUIDv4s in Java with a regex."
tags:
- blogumentation
- java
- uuid
- regex
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-14T11:54:26+0000
slug: "java-uuid-regex"
image: https://media.jvt.me/7e70383567.png
---
[Universally Unique Identifier (UUID)](https://en.wikipedia.org/wiki/Universally_unique_identifier) or UUIDs are a great way of providing practical randomness, for instance for [tracking IDs](/posts/2021/11/22/correlation-ids/) or generated database keys.

I've worked with them a fair bit, and each time I end up working with them, I find myself needing to Google for the regular expression that works for Java.

In the spirit of [blogumentation](/posts/2017/06/25/blogumentation/), I thought I'd document it for future me:

```java
/**
 * Regular expression, in {@link String} form, to match a Universally Unique Identifier (UUID), in
 * a case-insensitive fashion.
 */
public static final String UUID_STRING =
    "[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}";
/**
 * Regular expression to match any Universally Unique Identifier (UUID), in a case-insensitive
 * fashion.
 */
public static final Pattern UUID = Pattern.compile(UUID_STRING);
/**
 * Regular expression, in {@link String} form, to match a Version 4 Universally Unique Identifier
 * (UUID), in a case-insensitive fashion.
 */
public static final String UUID_V4_STRING =
    "[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-4[a-fA-F0-9]{3}-[89abAB][a-fA-F0-9]{3}-[a-fA-F0-9]{12}";
/**
 * Regular expression to match a Version 4 Universally Unique Identifier (UUID), in a
 * case-insensitive fashion.
 */
public static final Pattern UUID_V4 = Pattern.compile(UUID_V4_STRING);
```

These are an extract from the Apache-2.0 licensed java library [uuid](https://gitlab.com/jamietanna/uuid/-/blob/v0.2.0/uuid-core/src/main/java/me/jvt/uuid/Patterns.java).
