---
title: "Releasing Two Lightweight Libraries for Server-Driven Content Negotiation"
description: "Introducing two new Java libraries for performing server-driven content negotiation."
tags:
- java
- media-type
- content-negotiation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-01-11T15:52:01+0000
slug: "content-negotiation-java"
---
In [Why I Consistently Reach for Server-Driven Content Negotiation (For Versioning)]({{< ref 2021-01-05-why-content-negotiation >}}), I spoke about how useful server-driven content-negotiation can be for versioning or for multiple representations of data for your RESTful APIs.

But if you're building serverless projects, or projects without a heavy web layer, it may be quite difficult for you to do this, as you need to hand-roll it.

(As an aside, this is more for when you have a larger serverless project, which handles multiple routes / representations, which isn't always going to be true, depending on how far you stray from functions-as-a-service)

I've just released two libraries to Maven Central to make this easer - [media-type](https://gitlab.com/jamietanna/media-type) and [content-negotiation](https://gitlab.com/jamietanna/content-negotiation), which provide the ability to perform this negotiation in a straighforward way.

It's been a bit annoying that there's not a lightweight alternative for at least the `MediaType` class, as many libraries/frameworks have a nice implementation, but it's not available standalone - I've taken the best parts of lots of designs to get to my implementation.

Although they're at a 0.1.0 release for now, they fulfill a number of requirements for my own usage, and after a bit of use in production, I'll look to stabilise the API with a v1 release.

This allows you, as a consumer, to write the following code to parse the request and resolve your `MediaType`, if applicable.

```java
// setup
ContentTypeNegotiator negotiator = new ContentTypeNegotiator(
    Arrays.asList(MediaType.APPLICATION_JSON, MediaType.TEXT_PLAIN));
AcceptHeaderParser parser = new AcceptHeaderParser();

// each request
try {
  MediaType resolved = negotiator.negotiate(parser.parse("application/*"));
  // do something with the resolved `MediaType`, i.e. present your response as that format
} catch (NotAcceptableException e) {
  // handle, i.e. returning a 406 Not Acceptable
}
```

This handles quality value negotiation, allowing a consumer to say that they don't necessarily want a given version.
