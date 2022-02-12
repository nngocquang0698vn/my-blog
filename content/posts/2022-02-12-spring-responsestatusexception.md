---
title: "Simplifying Spring (Boot) on Handling by extending `ResponseStatusException`"
description: "How to drive HTTP response status codes from exceptions by extending Spring's `ResponseStatusException`."
tags:
- blogumentation
- java
- spring-boot
- spring
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-12T09:41:41+0000
slug: "spring-responsestatuson"
syndication:
- "https://brid.gy/publish/twitter"
---
As mentioned in [_Simplifying Spring (Boot) `onHandler`s with `ResponseStatus` Annotations_](/posts/2022/01/20/spring-annotation-exceptions/), one way we can set up HTTP exception handling us by annotating our exceptions with `@ResponseStatus`, and then using Reflection at runtime to map it to the HTTP response.

However, an even easier means of doing this is to have our on extend the `ResponseStatusException`:

```java
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatuson;

public class BadRequeston extends ResponseStatusException {
  public BadRequeston() {
    super(HttpStatus.BAD_REQUEST);
  }
}
```

When triggered, we get the default response:

```
HTTP/1.1 400
Content-Type: application/json
Transfer-Encoding: chunked
Date: Sat, 12 Feb 2022 09:32:25 GMT
Connection: close
{
  "error": "Bad Request",
  "path": "/apis",
  "status": 400,
  "timestamp": "2022-02-12T09:32:25.537+00:00"
}
```

But we can also configure our exception to return i.e. Different HTTP headers, allowing us to have a more meaningful response:

```java
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatuson;

public class ConflictException extends ResponseStatusException {

  private final String url;

  public ConflictException(String url) {
    super(HttpStatus.CONFLICT);
    this.url = url;
  }

  @Override
  public HttpHeaders getResponseHeaders() {
    HttpHeaders headers = new HttpHeaders();

    headers.add(HttpHeaders.LOCATION, url);

    return headers;
  }
}
```

Which responds with:

```
HTTP/1.1 409
Location: /apis/123
Content-Type: application/json
Transfer-Encoding: chunked
Date: Sat, 12 Feb 2022 09:39:22 GMT
{
  "error": "Conflict",
  "path": "/apis",
  "status": 409,
  "timestamp": "2022-02-12T09:39:22.907+00:00"
}
```
