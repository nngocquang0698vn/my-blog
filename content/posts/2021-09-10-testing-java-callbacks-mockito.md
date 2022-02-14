---
title: "Testing Java Callbacks with Mockito"
description: "How to test invoking a real callback in a Java project, as a unit test."
tags:
- java
- mockito
- blogumentation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-09-10T16:04:31+0100
slug: "testing-java-callbacks-mockito"
image: https://media.jvt.me/35891268eb.png
---
If you're working with Java code that works with callbacks, you may be having some difficulty with mocking the response.

I had this problem recently when working with the Wiremock project, in which there was a class implementing the `RequestHandler` interface:

```java
public interface RequestHandler {
	void handle(Request request, HttpResponder httpResponder);
}
```

This method call expects the `HttpResponder` to be a callback that can return the `Response` to the caller:

```
public interface HttpResponder {
    void respond(Request request, Response response);
}
```

I had control over the `RequestHandler`, but didn't want to inject in a factory or something that may add unnecessary complexity, but fortunately Mockito's `doAnswer` came to the rescue:

```java
Request request = mock(Request.class);
Response response = mock(Response.class);
// setup

doAnswer((i) -> {
    HttpResponder responder = i.getArgument(1, HttpResponder.class);
    responder.respond(request, response);
    return null;
}).when(handler()).handle(any(), any());
```

This allows us to retrieve the real implementation of a `HttpResponder` that's passed into the method, then invoke it with the arguments we want to inject in.
