---
title: "Setting up a Staging Server for my Micropub Endpoint"
description: "Setting up a Micropub server that I can use to test changes before it publishes content to this site."
tags:
- www.jvt.me
- indieweb
- micropub
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-26T16:38:40+0000
slug: "micropub-staging-server"
image: /img/vendor/micropub-rocks-icon.png
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
---
Since [setting up a micropub server for www.jvt.me in August]({{< ref "2019-08-26-setting-up-micropub" >}}), I've been using it more and more to be able to publish content to my site.

One of the perks of [Micropub](https://indieweb.org/Micropub) is that it's a [standardised API for creating content, which is currently a W3C Recommendation](https://www.w3.org/TR/micropub/#respecDocument) with a lot of clients using it.

While writing it, I've been practicing Test Driven Development to ensure that the codebase is well-tested and well-designed, and that I've got adequate coverage of the code I've actually written.

However, the issue with writing tests is that it's based on assumptions of how I expect a client to be written with the spec in mind. And because these are assumptions, it's possible (and as I've found quite likely) to get it wrong. So although I may think I've implemented it correctly, I may have missed an edge case that a Micropub client expects to work.

This means that I need to actually use a Micropub client to validate that my own implementation is correct, and up until now that's meant it's against my production Micropub endpoint, which will then go and create content in this site.

That's not ideal as it leads to some potentially incorrect, if not irrelevant, content, and has meant I either need to `git revert` changes that I don't like, or manually correct the incorrect content.

Instead I wanted to set up the ability to use a staging server, such that I could verify if a post will be created correctly, before actually doing this, as it would give me the confidence I needed.

As of today, that's now possible. I've set up a staging site, [www.staging.jvt.me](https://www.staging.jvt.me/) which points to a staging version of my Micropub endpoint.

I've done this in quite a nice way, if I do say so myself.

Firstly, I use exactly the same codebase for my Micropub server between production and staging, with only two differences:

- the profile URL that is allowed to publish to my site - `www.jvt.me` vs `www.staging.jvt.me`
- staging does not store the post in my site's Git repo

By keeping the same codebase, I can ensure that I'm using the same set of functionality that is used with my production endpoint, in terms of security requirements and validation.

Because I do not want to store the data anywhere, I need to provide some sort of feedback to the Micropub client. I want to be able to eyeball whether the content that is to be stored in my site is correct, so I want to be able to view it in some form, but ideally without it being stored anywhere.

For instance, let's take the following form-encoded Micropub request:

```
h=entry&
content=Micropub+test+of+creating+an+h-entry+with+one+category.+This+post+should+have+one+category,+test1&
category=test1
```

This will be converted to the following JSON body for my site's representation of a post:

```json
{
    "kind": "notes",
    "slug": null,
    "client_id": "https://micropub.rocks/",
    "date": "2019-12-26T17:01:48.536+01:00",
    "h": "h-entry",
    "properties": {
        "published": [
            "2019-12-26T17:01:48.536+01:00"
        ],
        "category": [
            "test1"
        ],
        "content": [
            {
                "html": "",
                "value": "Micropub test of creating an h-entry with one category. This post should have one category, test1"
            }
        ],
        "syndication": [
            "https://brid.gy/publish/twitter"
        ]
    },
    "tags": [
        "test1"
    ]
}
```

It is this JSON representation that I want to be able to view, so what I've decided to do is to Base64 encode the JSON body:

```
eyJraW5kIjoibm90ZXMiLCJzbHVnIjpudWxsLCJjbGllbnRfaWQiOiJodHRwczovL21pY3JvcHViLnJvY2tzLyIsImRhdGUiOiIyMDE5LTEyLTI2VDE3OjAxOjQ4LjUzNiswMTowMCIsImgiOiJoLWVudHJ5IiwicHJvcGVydGllcyI6eyJwdWJsaXNoZWQiOlsiMjAxOS0xMi0yNlQxNzowMTo0OC41MzYrMDE6MDAiXSwiY2F0ZWdvcnkiOlsidGVzdDEiXSwiY29udGVudCI6W3siaHRtbCI6IiIsInZhbHVlIjoiTWljcm9wdWIgdGVzdCBvZiBjcmVhdGluZyBhbiBoLWVudHJ5IHdpdGggb25lIGNhdGVnb3J5LiBUaGlzIHBvc3Qgc2hvdWxkIGhhdmUgb25lIGNhdGVnb3J5LCB0ZXN0MSJ9XSwic3luZGljYXRpb24iOlsiaHR0cHM6Ly9icmlkLmd5L3B1Ymxpc2gvdHdpdHRlciJdfSwidGFncyI6WyJ0ZXN0MSJdfQ==
```

And then return it in the `Location` header to be returned to the Micropub client:

```
HTTP/2 202
cache-control: no-cache, no-store, max-age=0, must-revalidate
date: Thu, 26 Dec 2019 15:53:51 GMT
expires: 0
location: https://www.staging.jvt.me/post#eyJraW5kIjoibm90ZXMiLCJzbHVnIjpudWxsLCJjbGllbnRfaWQiOiJodHRwczovL21pY3JvcHViLnJvY2tzLyIsImRhdGUiOiIyMDE5LTEyLTI2VDE3OjAxOjQ4LjUzNiswMTowMCIsImgiOiJoLWVudHJ5IiwicHJvcGVydGllcyI6eyJwdWJsaXNoZWQiOlsiMjAxOS0xMi0yNlQxNzowMTo0OC41MzYrMDE6MDAiXSwiY2F0ZWdvcnkiOlsidGVzdDEiXSwiY29udGVudCI6W3siaHRtbCI6IiIsInZhbHVlIjoiTWljcm9wdWIgdGVzdCBvZiBjcmVhdGluZyBhbiBoLWVudHJ5IHdpdGggb25lIGNhdGVnb3J5LiBUaGlzIHBvc3Qgc2hvdWxkIGhhdmUgb25lIGNhdGVnb3J5LCB0ZXN0MSJ9XSwic3luZGljYXRpb24iOlsiaHR0cHM6Ly9icmlkLmd5L3B1Ymxpc2gvdHdpdHRlciJdfSwidGFncyI6WyJ0ZXN0MSJdfQ==
pragma: no-cache
server: Caddy
x-content-type-options: nosniff
x-frame-options: DENY
x-xss-protection: 1; mode=block
content-length: 0
```

When this is redirected to `/post`, it is intercepted by some client-side JavaScript and pretty-prints the JSON object to make it easier to read.

You can [follow the link for a demo](https://www.staging.jvt.me/post#eyJraW5kIjoibm90ZXMiLCJzbHVnIjpudWxsLCJjbGllbnRfaWQiOiJodHRwczovL21pY3JvcHViLnJvY2tzLyIsImRhdGUiOiIyMDE5LTEyLTI2VDE3OjAxOjQ4LjUzNiswMTowMCIsImgiOiJoLWVudHJ5IiwicHJvcGVydGllcyI6eyJwdWJsaXNoZWQiOlsiMjAxOS0xMi0yNlQxNzowMTo0OC41MzYrMDE6MDAiXSwiY2F0ZWdvcnkiOlsidGVzdDEiXSwiY29udGVudCI6W3siaHRtbCI6IiIsInZhbHVlIjoiTWljcm9wdWIgdGVzdCBvZiBjcmVhdGluZyBhbiBoLWVudHJ5IHdpdGggb25lIGNhdGVnb3J5LiBUaGlzIHBvc3Qgc2hvdWxkIGhhdmUgb25lIGNhdGVnb3J5LCB0ZXN0MSJ9XSwic3luZGljYXRpb24iOlsiaHR0cHM6Ly9icmlkLmd5L3B1Ymxpc2gvdHdpdHRlciJdfSwidGFncyI6WyJ0ZXN0MSJdfQ==).

I'm very much looking forward to being able to test out new changes to my Micropub endpoint in a safer way, as well as getting it fully verified for compliance through [the Micropub test suite](https://micropub.rocks).
