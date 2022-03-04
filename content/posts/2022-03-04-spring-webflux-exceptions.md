---
title: "Gotcha: checked and unchecked exception handling from Spring WebFlux `WebClient`"
description: "How checked and unchecked exceptions may appear when testing your `WebClient` code."
tags:
- blogumentation
- spring
- spring-boot
- java
- testing
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-03-04T17:06:12+0000
slug: spring-webflux-exceptions
image: https://media.jvt.me/3e88e3081a.png
syndication:
- "https://brid.gy/publish/twitter"
---
As noted in [Replacing Text in Vim with the Output of a Command](/posts/2022/02/01/vim-replace-with-command-execution/), it can be handy to pipe a bit of text into another command.

While working with Spring Webflux, I was writing tests to validate that the right business logic exceptions were being thrown by an HTTP call erroring, such as:

```java
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

class E {
  @Test
  void exampl() {
    assertThatThrownBy(this::process).isInstanceOf(BusinessLogicException.class);
  }

  void process() {
    WebClient webClient = WebClient.builder().build();

    webClient
        .get()
        .uri("http://localhost:4010/")
        .retrieve()
        .onStatus(
            s -> s.equals(HttpStatus.NOT_FOUND), (e) -> Mono.error(new BusinessLogicException()))
        .toBodilessEntity()
        .block();
  }

  private static class BusinessLogicException extends Exception {}
}
```

Unfortunately, this doesn't work - and we see the following error from our failed assertion:

```
Expecting actual throwable to be an instance of:
  uk.gov.api.springboot.infrastructure.fetcher.v1alpha.E.BusinessLogicException
but was:
  reactor.core.Exceptions$ReactiveException: uk.gov.api.springboot.infrastructure.fetcher.v1alpha.E$BusinessLogicException
	at reactor.core.Exceptions.propagate(Exceptions.java:392)
	at reactor.core.publisher.BlockingSingleSubscriber.blockingGet(BlockingSingleSubscriber.java:97)
	at reactor.core.publisher.Mono.block(Mono.java:1707)
	...(64 remaining lines not displayed - this can be changed with Assertions.setMaxStackTraceElementsDisplayed)
```

Notice that there is actually a `BusinessLogicException` in there, but it appears to be wrapped in a `ReactiveException`.

This is because checked exceptions aren't allowed to be thrown on their won, so need to be a `RuntimeException`, which WebFlux does using the `ReactiveException`.

To solve this, we either need to make the following change, to relax our test:

```diff
   @Test
   void example() {
-    assertThatThrownBy(this::process).isInstanceOf(BusinessLogicException.class);
+    assertThatThrownBy(this::process).hasCauseInstanceOf(BusinessLogicException.class);
   }
```

Or to promote our exception to be a `RuntimeException`, so they're not wrapped in a `ReactiveException`:

```diff
-  private static class BusinessLogicException extends Exception {}
+  private static class BusinessLogicException extends RuntimeException {}
```
