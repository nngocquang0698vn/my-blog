---
title: "Announcing `uuid`, a Java Library for UUID Validation"
description: "Releasing a new library that can be used to validate UUIDs in Java."
tags:
- java
- uuid
- jsr380
- bean-validation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-14T11:54:26+0000
slug: "java-uuid-library"
image: https://media.jvt.me/7e70383567.png
---
As noted in [_Validating UUIDs with Regular Expressions in Java_](/posts/2022/01/14/java-uuid-regex/), I work with UUIDs a fair bit, for various means of random identifiers.

While working at Capital One, we got to the point that we were duplicating the regex in quite a few places, so I added to the team's 10% self-directed development time the act of creating a library that could be shared between services, as we had a pretty good community internally of building and maintaining common libraries.

I'm not sure if it's been implemented yet, but I've decided to build my own Open Source version, which can be found at [uuid](https://gitlab.com/jamietanna/uuid/) and on Maven Central under the group `me.jvt.uuid`, as I want to use it within my own projects, both in and out of work.

As well as producing a `uuid-core` module which includes the `Pattern` and `String`s that define the regular expression, there's also a `uuid-validation-javax` library that implements bean validation using `javax-validation`, and allows you to annotate your data types i.e.:

```java
import me.jvt.uuid.validation.Uuid;

public class DataClass {
  @Uuid public String uuid;
}
```

I am also planning on [releasing a module that targets `jakarta-validation`](https://gitlab.com/jamietanna/uuid/-/issues/2).

If there's anything else you can think of that may be useful, please add it to the issue tracker!
