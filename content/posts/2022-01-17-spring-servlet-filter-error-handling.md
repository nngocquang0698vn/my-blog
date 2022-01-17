---
title: "Error Handling in (Spring) Servlet Filters"
description: "How to return HTTP errors when a Java Servlet fails with Spring (Boot)."
tags:
- blogumentation
- java
- spring-boot
- spring
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-17T17:14:26+0000
slug: "spring-servlet-filter-error-handling"
---
If you're using Java Servlet `Filter`s, you've likely come to the situation where you need to fail the request, for instance if there's a mandatory parameter missing, or the request is otherwise deemed to be invalid.

Let's say that for instance you're using a filter for [tracking the `correlation-id` header](/posts/2021/11/22/correlation-ids/):

```java
@Component
public class CorrelationIdFilter extends OncePerRequestFilter {
  @Override
  protected void doFilterInternal(
      @NonNull HttpServletRequest request,
      @NonNull HttpServletResponse response,
      @NonNull FilterChain filterChain)
      throws ServletException, IOException {

    String correlationId = request.getHeader("correlation-id");
    if (null == correlationId || !Patterns.UUID_V4.matcher(correlationId).matches()) {
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

You may want to reach for something like this:

```java
    if (null == correlationId || !Patterns.UUID_V4.matcher(correlationId).matches()) {
      throw new CorrelationIdMalformedException();
    }
```

Which can then have a corresponding exception handler:

```java
@ControllerAdvice
public class GlobalExceptionHandler {

  @ExceptionHandler(CorrelationIdMalformedException.class)
  protected ResponseEntity<ErrorResponse> handleCorrelationIdMalformedException(
      CorrelationIdMalformedException ex, WebRequest request) {
    // i.e.
    ErrorResponse errorResponse = new ErrorResponse();
    errorResponse.setError(ErrorResponse.Error.INVALID_REQUEST);
    errorResponse.setErrorDescription(ex.getMessage());
    return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
  }
}
```

Unfortunately this is a common pitfall, and as noted in [this conversation on StackOverflow](https://stackoverflow.com/questions/34595605/how-to-manage-exceptions-thrown-in-filters-in-spring#comment71342317_34598356) is not possible because the Servlet `Filter` executes before Spring's own `DispatchServlet`, so we don't have the ability to do this.

Instead, we need to use the Servlet API to return the error, for instance using our handy new method `handleInvalidCorrelationId`:

```java
@Component
public class CorrelationIdFilter extends OncePerRequestFilter {

  private final ObjectMapper objectMapper;

  public CorrelationIdFilter(ObjectMapper objectMapper) {
    this.objectMapper = objectMapper;
  }

  @Override
  protected void doFilterInternal(
      HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
      throws ServletException, IOException {
    String uuid = request.getHeader("correlation-id");
    if (uuid == null) {
      uuid = UUID.randomUUID().toString();
    }
    if (!uuid.matches(Patterns.UUID_STRING)) {
      handleInvalidCorrelationId(response);
      return; // make sure you have this set!
    }
    try {
      filterChain.doFilter(request, response);
    } finally {
      response.addHeader("correlation-id", uuid);
    }
  }

  private void handleInvalidCorrelationId(HttpServletResponse response) throws IOException {
    ErrorResponse errorResponse = new ErrorResponse();
    errorResponse.setError(ErrorResponse.Error.INVALID_REQUEST);
    errorResponse.setErrorDescription("The correlation-id is not a valid UUID.");

    response.setHeader("content-type", "application/json");
    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    response.getWriter().write(objectMapper.writeValueAsString(errorResponse));
  }
}
```

This will reject the request correctly, and allow us to specify the response's headers and body correctly.
