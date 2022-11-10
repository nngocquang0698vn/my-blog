---
title: "Performing `AND` conditionals in HAProxy"
description: "How to string multiple conditions together in HAProxy to perform an\
  \ `AND`."
date: "2022-11-10T12:52:16+0000"
syndication:
- "https://twitter.com/JamieTanna/status/1590691703375249409"
tags:
- "blogumentation"
- "haproxy"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/5f67159543.png"
slug: "haproxy-and-conditional"
---
Today I've been playing around with some HAProxy rules, and I wanted to only allow access to a given host if the request was to a specific route.

Trying to search for "how to write `and` in HAProxy" was surprisingly difficult, and odd as there was mention of it in some places, but it didn't get parsed correctly.

As it didn't seem initially straightforward, I thought I'd document that you can specify multiple conditions, and they're implicitly AND'd.

For instance:

```
# to route to the backend `the_host`, which is found at http://host.local
acl host_the_host hdr(host) -i host.local
acl host_the_host_allow_webhook path_beg,url_dec -i /webhook
use_backend host.local if host_the_host host_the_host_allow_webhook
                                       ^ this is implicitly an and between these two ACLs
```
