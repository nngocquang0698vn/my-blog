---
title: "Reading a Servlet/Spring Request Body Multiple Times"
description: "How to read the request body more than once using Java Servlet Filters."
tags:
- blogumentation
- java
- spring
- servlet
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-25T19:56:08+0100
slug: "read-servlet-request-body-multiple"
---
I've recently been writing a [`javax.servlet.Filter`](https://javaee.github.io/javaee-spec/javadocs/javax/servlet/Filter.html) to perform validation on a request coming from [Netlify's Deploy Notifications](https://docs.netlify.com/site-deploys/notifications/#outgoing-webhooks) and have needed to read the request body to validate that the request is correct.

However, I've found this a little bit painful, as the Java Servlets provide a `ServletInputStream` that can only be read once, and if you don't, the web server you're using i.e. Spring may reject the incoming request.

This means that your requests will fail with the following/a similar error:

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

To avoid this, we need to cache the `ServletInputStream`, so the web server can read the input, as well as the `Filter`(s) themselves.

For the sake of this example, I'll create an endpoint that echoes the request body, i.e.

```
$ curl localhost:8080/ -d 'hi' -H 'content-type: application/json' -i
HTTP/1.1 200
Content-Type: text/plain;charset=UTF-8
Content-Length: 2
Date: Mon, 25 May 2020 15:42:16 GMT

hi
```

And will have a `Filter` that logs the request body, too.

Complete code can be found at <a href="https://gitlab.com/jamietanna/multiple-read-servlet"><i title="GitLab" class="fa fa-gitlab"></i>&nbsp;jamietanna/multiple-read-servlet</a>.

# Using `ContentCachingRequestWrapper`

On paper, using Spring's [`ContentCachingRequestWrapper`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/util/ContentCachingRequestWrapper.html) _should_ work. It caches content read from the `ServletInputStream`, and allows easy retrieval.

However, it doesn't take into account the need for the `ServletInputStream` to be re-read, which means we still receive the `HttpMessageNotReadableException` exceptions about the request body being missing.

# Creating our own class

Following [arberg's response on _Http Servlet request lose params from POST body after read it once_](https://stackoverflow.com/a/36619972/2257038) and [Marco's response on _HttpServletRequestWrapper, example implementation for setReadListener / isFinished / isReady?_](https://stackoverflow.com/a/30748533/2257038), I've created the `MultiReadHttpServletRequest` class which is available in Maven Central:

```xml
  <groupId>me.jvt.multireadservlet</groupId>
  <artifactId>multiple-read-servlet</artifactId>
  <version>4.0.1</version> <!-- version mirrors the javax.servlet:javax.servlet-api version -->
```

And can be found in <a href="https://gitlab.com/jamietanna/multiple-read-servlet/-/blob/master/src/main/java/me/jvt/multireadservlet/MultiReadHttpServletRequest.java"><code>MultiReadHttpServletRequest.java</code></a>, with example usage in <a href="https://gitlab.com/jamietanna/multiple-read-servlet/-/blob/master/src/test/java/me/jvt/multireadservlet/support/servlet/BodyReadFilter.java"><code>BodyReadFilter.java</code></a>.
