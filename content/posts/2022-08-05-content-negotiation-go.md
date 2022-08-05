---
title: "Releasing a Go library for content-type negotiation"
description: "Introducing a new Go library for performing server-driven content negotiation."
date: "2022-08-05T09:28:10+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1555473139957645313"
tags:
- "go"
- "content-negotiation"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "content-negotiation-go"
---
As I've [written about in the past](https://www.jvt.me/posts/2021/01/05/why-content-negotiation/), I'm a big fan of using [Server-Driven Content Negotiation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Content_negotiation#Server-driven_content_negotiation) for APIs for versioning, but also find it handy for being able to serve different representations of data depending on what the client supports. This is handy to be able to serve an HTML page to a browser doing a form-post, compared to JSON to an API client doing the same call.

As I'm starting to work on a service that would do this in Go, I realised that I would need to be able to correctly perform content negotiation. Fortunately, [I've already done this for Java](https://www.jvt.me/posts/2021/01/11/content-negotiation-java/) so I thought I'd make a stab at building my own.

Just before I did, I thought I'd check to see if there's any prior art, and discovered [this feature request to Go to add content negotation](https://github.com/golang/go/issues/19307), and found a couple of implementations, but due to their license, found that it wouldn't be widely usable, so alas, I ended up writing [gitlab.com/jamietanna/content-negotiation-go](https://gitlab.com/jamietanna/content-negotiation-go).

I'd seen that the Go standard library had support for [parsing media types](https://pkg.go.dev/mime#ParseMediaType) which is probably the hardest part, but it turns out it didn't do quite enough for me, so I ended up needing to write some convenience methods for some of the other requirements.

While doing this, I realised that my Java library was actually missing some key functionality with how it negotiates, so I've ended up releasing a fix for that, too. Because of how difficult it can be, especially around finding the right combinations to ensure you've thought of all the options, I'll be [releasing a set of test cases](https://gitlab.com/jamietanna/jvt.me/-/issues/1250), likely in JSON format, that can be used to ensure that your implementations are correct.

My library should now cover all the primary use cases for content negotiation, and I'll be working to get it ready for a v1 release, as well as seeing if some of it can actually go upstream into the language!
