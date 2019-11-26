---
title: "Using OpenSSL Behind a (Corporate) Proxy"
description: "How to use OpenSSL commands when behind a proxy server."
tags:
- blogumentation
- openssl
- proxy
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-08-06T12:51:11+0100
slug: "openssl-proxy"
---
When at work, I'm behind a corporate proxy, which requires all my traffic to the outside world needing to pass through the proxy for various security reasons.

However, if I'm trying to i.e. use OpenSSL to get the public certificate for a website using the steps in my article [_Extracting SSL/TLS Certificate Chains Using OpenSSL_]({{< ref "2017-04-28-extract-tls-certificate" >}}), I've found that the requests I send sending are just timing out.

I found that this is because OpenSSL doesn't go via the proxy unless you explicitly tell it with an explicit `-proxy`:

```sh
openssl s_client -showcerts -connect "jvt.me:443" -proxy proxy.example.com:8888 ...
```

**EDIT**: Thanks to [this comment from Charles MERLEN](https://commentpara.de/comment/494.htm), there doesn't need to be a scheme on the proxy connection above (i.e. `http://`).

With that set, my connections then start to go through OK again.
