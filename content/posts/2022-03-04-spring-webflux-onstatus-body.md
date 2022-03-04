---
title: "Accessing the response body with Spring WebFlux `WebClient` with `onStatus`"
description: "How to access the body of an (error) response when using `WebClient`'s `onStatus` method."
tags:
- blogumentation
- spring
- spring-boot
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-03-04T16:55:25+0000
slug: spring-webflux-onstatus-body
image: https://media.jvt.me/3e88e3081a.png
syndication:
- "https://brid.gy/publish/twitter"
---
While [writing some integration tests for a `WebClient`](https://www.jvt.me/posts/2022/02/07/webclient-integration-test/) today, I wanted to take advantage of the `onStatus` method to perform some operational logging using the response body, _before_ I mapped it to a particular exception.

I found it really quite difficult to do, as I wanted to use `.block()`, but found it didn't work, and other means I'd tried just ended up not executing.

I found that the following ended up working:

```java
import org.junit.jupiter.api.Test;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.client.WebClient;

class Example {
  @Test
  void example() {
    WebClient webClient = WebClient.builder().build();

    webClient
        .get()
        .uri("http://localhost:4010/")
        .retrieve()
        .onStatus(
            s -> s.equals(HttpStatus.NOT_FOUND),
            (e) ->
                e.bodyToMono(ErrorResponse.class)
                    .handle(
                        (body, handler) -> {
                          LoggerFactory.getLogger(getClass()).warn("HTTP 404 returned: {}", body);
                          handler.error(new BusinessLogicException());
                        }))
        .toBodilessEntity()
        .block();
  }

  private static class BusinessLogicException extends Exception {}

  private record ErrorResponse(String type, String title, long status, String detail) {}
}
```

This use of `handle` allows it to process asynchronously, giving us the chance to interact with the parsed response body.
