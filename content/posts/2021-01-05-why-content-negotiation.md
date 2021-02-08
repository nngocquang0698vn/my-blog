---
title: "Why I Consistently Reach for Server-Driven Content Negotiation (For Versioning)"
description: "Why I use server-driven content negotiation for APIs to allow for versioning and allowing different representations of APIs."
tags:
- api
- content-negotiation
- rest
- web
- versioning
- version-pinning
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-01-05T11:35:46+0000
slug: "why-content-negotiation"
syndication:
- https://news.ycombinator.com/item?id=25644616
- https://news.ycombinator.com/item?id=25644692
- https://lobste.rs/s/ja3t7r/why_i_consistently_reach_for_server
---
I've recently started work on a service where we're not yet happy with the response body for the endpoints, so we're using an interim solution instead of trying to get a "perfect" end state straight away.

At the point that we've decided on the end state for the contract, we'll be in an awkward position. By changing the contract of the endpoints, we'll introduce a breaking change for consumers, as we'll be restructuring the format that they're expecting.

If we don't have a way to manage this, it could mean we have several co-dependent deployments to ensure that we're all on the new version at the same time, and it's likely that we'll have a period of time where there are some errors while we're waiting for the consumer to update, which is really not great for anyone, not least because this is a problem that's already been solved!

This is handled through API versioning, and is something <span class="h-card"><a class="u-url" href="https://apisyouwonthate.com/">APIs You Won't Hate</a></span> has [written about before](https://apisyouwonthate.com/blog/api-versioning-has-no-right-way) and is a great read.

My preferred route of handling versioning is to use [Server-Driven Content Negotiation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Content_negotiation#Server-driven_content_negotiation), which allows a client to use the `Accept` header (among others) to request a type of content, meaning they can choose which version of the resource is presented to them.

# What is Server-Driven Content Negotiation?

Server-driven Content Negotiation allows a consumer to send the HTTP Header `Accept`, letting the consumer tell the server what format they want the resource to be presented as.

For instance, a straightforward request for a JSON API could be:

```
GET /api
Accept: application/json
```

Which says to the service, "give me only JSON". If the server does not support JSON, it should return either an HTTP 406 Not Acceptable, or an HTTP 415 Unsupported Media-Type (if a POST request using `content-type` negotiation), depending on how it feels.

If an `Accept` header is not provided, the API can infer a default type, or could reject the request with a 406/415.

# Content Negotiation for Versioning

Now, the reason I wrote this article is that I'm a big fan of content negotiation for versioning. This means that we can request the exact version of an API using the following (example) vendor extension:

```
GET /api
Accept: application/vnd.me.jvt.api.v1+json
```

By adding this versioning into our API's contracts, it allows us to ensure that everything is versioned, right at the start.

This is great as a producer, because we can know that consumers won't be pulling whatever is the newest version. And for a consumer, it's also great because you can say that as long as you're sending a specific version, you will only get that specific version. This allows producers to release new versions of the contract without breaking consumers, and allows consumers the opportunity to upgrade to the versions in their own time.

This also means that we wouldn't provide a "default" version, so anything that isn't strictly matching the versioning would be rejected. This has the added benefit of meaning that no one should be able to "accidentally" pick up a version of the API that they're not expecting by using no `Accept`, or sending a wildcard.

The best part about following something standardised is that web frameworks everywhere (should) support it, as well as Layer 7 routers (such as AWS' Application Load Balancer), at least at a minimal level.

Another great thing, is that by doing it based on these headers, we can route to different infrastructure, for instance if we wanted to have a Lambda function per version we supported.

# Content Negotiation for Different Representations

However, Content Negotiation isn't just usable with versioning, as its initial raison d'etre was to allow a client to request different formats from a server, for instance:

```
GET /page
Accept: audio/*; q=0.2, audio/basic
```

This allows the browser to tell the server that they prefer the use of `audio/basic`, but if that's not supported, they're willing to compromise and accept anything that's under the `audio` type.

It also allows requesting different representations of the same data, for instance you could request an XML format for an API, if the server supports it:

```
GET /api
Accept: application/xml
```

This has also helped recently with my [Micropub](https://micropub.spec.indieweb.org/) server, which I used to manage content on my site. When creating/updating a piece of content on my site, the Micropub server responds with an HTTP 201 Created with a `Location` header pointing to the new entry.

This is great for when interacting via a server, but with [my personal editor]({{< ref 2020-06-28-personal-micropub-client >}}) for the site, I perform all these interactions through the browser. In this case, the browser doesn't show the `Location` header, nor follow the URL like it would with a HTTP 302 Found.

However, I can take advantage of content negotiation and as detailed in [this proposal for the Micropub standard](https://github.com/indieweb/micropub-extensions/issues/28#issuecomment-713132934), allows for negotiation based on whether the consumer is a browser or an API:

```
% curl https://www-api.staging.jvt.me/micropub -i -H 'Authorization: Bearer ...' -d h=entry -d "content=It's been a great Sunday for #Morph"
HTTP/1.1 202 Accepted
Cache-Control: no-cache, no-store, max-age=0, must-revalidate
Content-Length: 0
Date: Tue, 20 Oct 2020 20:44:57 GMT
Expires: 0
Location: https://www.staging.jvt.me/post#ewogICJkYXRlIiA6ICIyMDIwLTEwLTIwVDIwOjQ0OjU3LjkwNloiLAogICJkZWxldGVkIiA6IGZhbHNlLAogICJoIiA6ICJoLWVudHJ5IiwKICAicHJvcGVydGllcyIgOiB7CiAgICAic3luZGljYXRpb24iIDogWyAiaHR0cHM6Ly9icmlkLmd5L3B1Ymxpc2gvdHdpdHRlciIgXSwKICAgICJwdWJsaXNoZWQiIDogWyAiMjAyMC0xMC0yMFQyMDo0NDo1Ny45MDZaIiBdLAogICAgImNhdGVnb3J5IiA6IFsgIm1vcnBoIiBdLAogICAgImNvbnRlbnQiIDogWyB7CiAgICAgICJodG1sIiA6ICIiLAogICAgICAidmFsdWUiIDogIkl0J3MgYmVlbiBhIGdyZWF0IFN1bmRheSBmb3IgPGEgaHJlZj1cIi90YWdzL21vcnBoL1wiPiNNb3JwaDwvYT4iCiAgICB9IF0KICB9LAogICJraW5kIiA6ICJub3RlcyIsCiAgInNsdWciIDogIjIwMjAvMTAvMHFqMWgiLAogICJ0YWdzIiA6IFsgIm1vcnBoIiBdLAogICJjbGllbnRfaWQiIDogImh0dHBzOi8vcXVpbGwucDNrLmlvLyIKfQ==
Pragma: no-cache
Server: Caddy
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-Xss-Protection: 1; mode=block
```

And when negotiation occurs:

```
% curl https://www-api.staging.jvt.me/micropub -i -H 'Authorization: Bearer ...' -d h=entry -d "content=It's been a great Sunday for #Morph"  -H 'accept: text/html'
HTTP/1.1 200 OK
Cache-Control: no-cache, no-store, max-age=0, must-revalidate
Content-Length: 1446
Content-Type: text/html;charset=UTF-8
Date: Tue, 20 Oct 2020 20:45:06 GMT
Expires: 0
Pragma: no-cache
Server: Caddy
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-Xss-Protection: 1; mode=block

<html><body><p>The post has been created at <a href="https://www.staging.jvt.me/post#ewogICJkYXRlIiA6ICIyMDIwLTEwLTIwVDIwOjQ1OjA2LjUxNFoiLAogICJkZWxldGVkIiA6IGZhbHNlLAogICJoIiA6ICJoLWVudHJ5IiwKICAicHJvcGVydGllcyIgOiB7CiAgICAic3luZGljYXRpb24iIDogWyAiaHR0cHM6Ly9icmlkLmd5L3B1Ymxpc2gvdHdpdHRlciIgXSwKICAgICJwdWJsaXNoZWQiIDogWyAiMjAyMC0xMC0yMFQyMDo0NTowNi41MTRaIiBdLAogICAgImNhdGVnb3J5IiA6IFsgIm1vcnBoIiBdLAogICAgImNvbnRlbnQiIDogWyB7CiAgICAgICJodG1sIiA6ICIiLAogICAgICAidmFsdWUiIDogIkl0J3MgYmVlbiBhIGdyZWF0IFN1bmRheSBmb3IgPGEgaHJlZj1cIi90YWdzL21vcnBoL1wiPiNNb3JwaDwvYT4iCiAgICB9IF0KICB9LAogICJraW5kIiA6ICJub3RlcyIsCiAgInNsdWciIDogIjIwMjAvMTAvcWpkcXkiLAogICJ0YWdzIiA6IFsgIm1vcnBoIiBdLAogICJjbGllbnRfaWQiIDogImh0dHBzOi8vcXVpbGwucDNrLmlvLyIKfQ==">https://www.staging.jvt.me/post#ewogICJkYXRlIiA6ICIyMDIwLTEwLTIwVDIwOjQ1OjA2LjUxNFoiLAogICJkZWxldGVkIiA6IGZhbHNlLAogICJoIiA6ICJoLWVudHJ5IiwKICAicHJvcGVydGllcyIgOiB7CiAgICAic3luZGljYXRpb24iIDogWyAiaHR0cHM6Ly9icmlkLmd5L3B1Ymxpc2gvdHdpdHRlciIgXSwKICAgICJwdWJsaXNoZWQiIDogWyAiMjAyMC0xMC0yMFQyMDo0NTowNi41MTRaIiBdLAogICAgImNhdGVnb3J5IiA6IFsgIm1vcnBoIiBdLAogICAgImNvbnRlbnQiIDogWyB7CiAgICAgICJodG1sIiA6ICIiLAogICAgICAidmFsdWUiIDogIkl0J3MgYmVlbiBhIGdyZWF0IFN1bmRheSBmb3IgPGEgaHJlZj1cIi90YWdzL21vcnBoL1wiPiNNb3JwaDwvYT4iCiAgICB9IF0KICB9LAogICJraW5kIiA6ICJub3RlcyIsCiAgInNsdWciIDogIjIwMjAvMTAvcWpkcXkiLAogICJ0YWdzIiA6IFsgIm1vcnBoIiBdLAogICJjbGllbnRfaWQiIDogImh0dHBzOi8vcXVpbGwucDNrLmlvLyIKfQ==</a>.</p></body></html>
```

This makes it a much nicer experience, and allows you to target different consumers with different experiences.
