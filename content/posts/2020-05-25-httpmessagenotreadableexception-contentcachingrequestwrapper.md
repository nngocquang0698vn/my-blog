---
title: "How to avoid `HttpMessageNotReadableException` when using `ContentCachingRequestWrapper` with Java Servlet Filters"
description: "How to avoid receiving `Required request body is missing` errors when using a `ContentCachingRequestWrapper`."
tags:
- blogumentation
- java
- spring
- servlet
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-25T19:56:08+0100
slug: "httpmessagenotreadableexception-contentcachingrequestwrapper"
---
If you're using a [`ContentCachingRequestWrapper`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/util/ContentCachingRequestWrapper.html) from Spring, you may be confused to find errors, similar to the below, from your application:

```
HTTP/1.1 400
Content-Type: application/json
Transfer-Encoding: chunked
Date: Mon, 25 May 2020 15:45:29 GMT
Connection: close
{
    "timestamp": "2020-05-25T15:45:33.739+0000",
    "status": 400,
    "error": "Bad Request",
    "message": "Required request body is missing: public org.springframework.http.ResponseEntity<java.lang.String> me.jvt.hacking.controller.Controller.echo(java.lang.String)",
    "path": "/"
}
```

This appears to be because the `ContentCachingRequestWrapper` doesn't cache the raw `ServletInputStream`, which is then consumed further down the line by Spring when trying to use `@RequestBody`.

The solution is detailed in my article [_Reading a Servlet/Spring Request Body Multiple Times_]({{< ref 2020-05-25-read-servlet-request-body-multiple >}}), and involves _not_ using the `ContentCachingRequestWrapper`, but instead using a custom class that can cache the `ServletInputStream`.
