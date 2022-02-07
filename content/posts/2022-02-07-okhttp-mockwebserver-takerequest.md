---
title: "Capturing HTTP Requests with okhttp's `MockWebServer.takeRequest`"
description: "How to use `MockWebServer`'s `takeRequest` method to verify that HTTP request(s) are sent correctly."
tags:
- blogumentation
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-07T10:44:19+0000
slug: okhttp-mockwebserver-takerequest
syndication:
- "https://brid.gy/publish/twitter"
---
I came across okhttp's `MockWebServer` as part of [Integration Testing Your Spring `WebClient`s with okhttp's `MockWebServer`](/posts/2022/02/07/webclient-integration-test/), and wanted to verify that HTTP requests made by my HTTP clients were well-formed.

To do this, there's the `takeRequest` method, which on my first read, I expected to need to be called at the same time as the HTTP request was outgoing.

It turns out that the way to do this, is instead to call it _after_ an HTTP request is sent, using it purely for verification means:

```java
@Test
void test() throws InterruptedException {
  MockWebServer server = new MockWebServer();
  // required to be set, otherwise `takeRequest` will never return anything
  server.enqueue(new MockResponse());

  RestAssured.given().get(server.url("/products").toString());

  RecordedRequest request = server.takeRequest(1, TimeUnit.SECONDS);
  assertThat(request).isNotNull();
  assertThat(request.getPath()).isEqualTo("/products");
}
```

**Note** the need for enqueueing a `MockResponse`, as without it the tests will fail.
