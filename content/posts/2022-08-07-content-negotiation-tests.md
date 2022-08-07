---
title: "Releasing a set of test cases for Content Negotiation"
description: "Introducing a repo for test cases to validate how you're performing server-driven content negotiation."
date: 2022-08-07T21:13:59+0100
syndication:
- https://brid.gy/publish/twitter
tags:
- "content-negotiation"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "content-negotiation-tests"
---
As I've [written about in the past](https://www.jvt.me/posts/2021/01/05/why-content-negotiation/), I'm a big fan of using [Server-Driven Content Negotiation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Content_negotiation#Server-driven_content_negotiation) for APIs for versioning, but also find it handy for being able to serve different representations of data depending on what the client supports. This is handy to be able to serve an HTML page to a browser doing a form-post, compared to JSON to an API client doing the same call.

However - and something I'm going to write about further [in the future](https://gitlab.com/jamietanna/jvt.me/-/issues/1218) - is that doing it right is hard. Not only in how you implement the negotiation algorithm itself, but also making sure that all parts of your HTTP stack, including things like middleware, are aware of the different representations.

While writing [a Go library for content negotation](https://www.jvt.me/posts/2022/08/05/content-negotiation-go/), I found that the Java library I wrote [early last year](https://www.jvt.me/posts/2021/01/11/content-negotiation-java/) was actually missing some cases and functionality, and needed to be fixed.

Because I want to make sure that I've got a separate record of the expected cases, as well as being able to help others building tools around content negotiation I've ended up creating [a new repo, content-negotiation-test-cases](https://gitlab.com/jamietanna/content-negotiation-test-cases).

I've validated that [my Go library](https://gitlab.com/jamietanna/content-negotiation-go/-/merge_requests/3) and [my Java library](https://gitlab.com/jamietanna/content-negotiation/-/merge_requests/31) are now compliant with these cases for consistency.

I'll be looking to improve test cases, and see if there are clashes with well-known and supported frameworks.
