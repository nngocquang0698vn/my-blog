---
title: Showing response headers with `curl -i`
description: Showing just response headers when `curl`ing a resource, using `curl -i`.
categories:
- blogumentation
- curl
tags:
- blogumentation
- curl
date: 2018-10-19
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: curl-i-response-headers
---
Sometimes you want to `curl` a resource, while also receiving the response headers. In the past, I would reach for `curl -v`:

```
$ curl -v https://google.com
* Rebuilt URL to: https://google.com/
*   Trying 216.58.210.46...
* TCP_NODELAY set
* Connected to google.com (216.58.210.46) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: none
} [5 bytes data]
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
} [512 bytes data]
* TLSv1.3 (IN), TLS handshake, Server hello (2):
{ [100 bytes data]
* TLSv1.2 (IN), TLS handshake, Certificate (11):
{ [3128 bytes data]
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
{ [114 bytes data]
* TLSv1.2 (IN), TLS handshake, Server finished (14):
{ [4 bytes data]
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
} [37 bytes data]
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
} [1 bytes data]
* TLSv1.2 (OUT), TLS handshake, Finished (20):
} [16 bytes data]
* TLSv1.2 (IN), TLS handshake, Finished (20):
{ [16 bytes data]
* SSL connection using TLSv1.2 / ECDHE-ECDSA-CHACHA20-POLY1305
* ALPN, server accepted to use h2
* Server certificate:
*  subject: C=US; ST=California; L=Mountain View; O=Google LLC; CN=*.google.com
*  start date: Oct  2 07:29:00 2018 GMT
*  expire date: Dec 25 07:29:00 2018 GMT
*  subjectAltName: host "google.com" matched cert's "google.com"
*  issuer: C=US; O=Google Trust Services; CN=Google Internet Authority G3
*  SSL certificate verify ok.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
} [5 bytes data]
* Using Stream ID: 1 (easy handle 0x5636153b7a60)
} [5 bytes data]
> GET / HTTP/2
> Host: google.com
> User-Agent: curl/7.61.1
> Accept: */*
>
{ [5 bytes data]
* Connection state changed (MAX_CONCURRENT_STREAMS == 100)!
} [5 bytes data]
< HTTP/2 301
< location: https://www.google.com/
< content-type: text/html; charset=UTF-8
< date: Fri, 19 Oct 2018 11:22:01 GMT
< expires: Sun, 18 Nov 2018 11:22:01 GMT
< cache-control: public, max-age=2592000
< server: gws
< content-length: 220
< x-xss-protection: 1; mode=block
< x-frame-options: SAMEORIGIN
< alt-svc: quic=":443"; ma=2592000; v="44,43,39,35"
<
{ [5 bytes data]
* Connection #0 to host google.com left intact
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="https://www.google.com/">here</A>.
</BODY></HTML>
```

However, we can see that this isn't actually as easy to visually parse, and it has both request and response headers, as well as a few other bits of verbose logging information.

We can instead use `curl  --include` (`curl -i` for short) which shows just response headers:

```
$ curl -i https://google.com
HTTP/2 301
location: https://www.google.com/
content-type: text/html; charset=UTF-8
date: Fri, 19 Oct 2018 11:21:36 GMT
expires: Sun, 18 Nov 2018 11:21:36 GMT
cache-control: public, max-age=2592000
server: gws
content-length: 220
x-xss-protection: 1; mode=block
x-frame-options: SAMEORIGIN
alt-svc: quic=":443"; ma=2592000; v="44,43,39,35"

<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="https://www.google.com/">here</A>.
</BODY></HTML>
```

This makes the output a little clearer and gives us just the response headers, as we wanted.
