---
title: "Use (End-to-End) Tracing or Correlation IDs"
description: "Why you should be requesting, and logging, a unique identifier per request for better supportability."
tags:
- production
- incident-management
- supportability
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-11-22T09:30:30+0000
slug: "correlation-ids"
---
Over the last few years, I've been supporting a lot of production services in a personal and professional capacity.

While supporting them, I've inevitably had to track down problems across various sets of logging and monitoring, and have found that there's one thing that makes the process much, much easier to diagnose - the use of a unique identifier per interaction which is exposed to logging and monitoring.

This unique identifier is one that is constant across a whole interaction in a single (micro)service, and allows for an easy way to get a view of everything happening for that interaction with the service, which depending on how many logs your service produces and how much traffic is received, could quite considerably reduce the overhead of filtering logs.

This unique ID is hopefully shared across the UIs and various services that make up the system being interacted with, with each service replaying it on to the next, so you have a way of viewing all logs that correlate to a single customer interaction end-to-end.

This ID is commonly referred to as a "tracking ID", "tracing ID", "request ID", "correlation ID" or "context ID", but it may be something else that you're familiar with. It's often a UUID, but could be anything with sufficient randomness.

This ID is something I've seen generally made a required header in the service's contract, ensuring that these are definitely being sent, but it's also possible to not enforce it, and generate a fresh one if it's not already being sent to you in a valid format, so you at least have something to diagnose from your side, even if you can't piece it together with the client's view.

A benefit of this pattern, as well, is that it can make [component or system testing much easier](/posts/2021/06/01/better-wiremock-stubbing/), as you know that a specific ID is going to be used and can therefore set up expectations more easily.

You may come up with clients who don't want to perform the work to start sending this header, such as a client we had that was sending it, but it was static and they didn't have the time to prioritise to resolve it. When I explained that each issue that was related to their integration would take _at least_ 2-3 times longer to resolve (and be very costly to everyone involved) - if we even could track things down - they realised that actually they should really be amending their configuration.

Something I've not done before, but have seen others recommend is to make sure that this ID is also returned in HTTP response headers, so it's clear to a consumer of the service, as well as an operator looking through logs.

# Example using Spring Boot

As an example, let's see what this would look like for a Spring filter:

```java
@Component
public class CorrelationIdFilter extends OncePerRequestFilter {
  // UUIDv4, matching either case, but depends on what format you want to use
  private static final Pattern UUID_PATTERN =
      Pattern.compile("([a-fA-F0-9]{8}(-[a-fA-F0-9]{4}){4}[a-fA-F0-9]{8})");

  @Override
  protected void doFilterInternal(
      @NonNull HttpServletRequest request,
      @NonNull HttpServletResponse response,
      @NonNull FilterChain filterChain)
      throws ServletException, IOException {

    String correlationId = request.getHeader("correlation-id");
    if (null == correlationId || !UUID_PATTERN.matcher(correlationId).matches()) {
      // only allow UUIDs, if it's not valid according to our contract, allow it to be rewritten
      // alternatively, we would reject the request with an HTTP 400 Bad Request, as a client
      // hasn't fulfilled the contract
      correlationId = UUID.randomUUID().toString();
    }
    // make sure that the Mapped Diagnostic Context (MDC) has the `correlationId` so it can then
    // be populated in the logs
    try (MDC.MDCCloseable closable = MDC.putCloseable("correlationId", correlationId)) {
      response.addHeader("correlation-id", correlationId); // so the response contains it, too
      filterChain.doFilter(request, response);
    }
  }
}
```

If you were using [a structured logging format](/posts/2021/05/31/spring-boot-structured-logging/)), you'd have a log outputted such as:

```json
{
  "@timestamp": "2021-11-21T18:50:57.467+00:00",
  "@version": 1,
  "level": "WARN",
  "logger_name": "me.jvt.www.api.micropub.exception.MicropubExceptionHandler",
  "mdc": {
    "correlationId": "0dbde4f9-dbcb-49e6-9258-3a377d4696ad"
  },
  "message": "An invalid request was rejected for reason: Query `` is not supported",
  "source_host": "micropub-845978f994-tvpft",
  "thread_name": "http-nio-8080-exec-4"
}
```

Or an unstructured logging format:

```
2021-05-31 14:39:04.872  ERROR 1167226 --- [o-auto-1-exec-1] c.e.s.HelloController : c8633195-2ed1-45fa-ae3d-5afb3ce33c82 An unexpected error occured, cause: ...
```
