---
title: "Content Negotiation with Servlet `Filter` in Spring (Boot)"
description: "How to perform content-negotiation in a Servlet `Filter`, to serve the correct representation of error to a consumer, based on the `Accept` header."
tags:
- blogumentation
- java
- spring-boot
- spring
- content-negotiation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-18T12:01:36+0000
slug: "spring-negotiate-servlet-filter"
image: /img/vendor/spring-logo.png
---
Update 2022-01-29: You may be interested in using [spring-content-negotiator](https://www.jvt.me/posts/2022/01/30/spring-content-negotiator/) to make this simpler!

As noted in [_Content Negotiation with `ControllerAdvice` and `ExceptionHandler`s in Spring (Boot)_](/posts/2022/01/18/spring-negotiate-exception-handler/), content negotiation is useful for providing different representations of formats for clients.

(I'd recommend a read of that article before this one to understand a bit more of the context for what is recommended below.)

However, you may also want to be doing this when [handling errors in `Filter`s](/posts/2022/01/17/spring-servlet-filter-error-handling/), which doesn't work as nicely.

**Note** that this will only work with Spring, as this depends on Spring classes.

Let's assume that we have the following filter that performs error handling:

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

    response.setContentType("application/json");
    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    response.getWriter().write(objectMapper.writeValueAsString(errorResponse));
  }
}
```

But we know that we may receive two types of API call, one that requests `application/json`, and one that requires `text/plain`, and we need to return the appropriate error response.

We can instead rewrite the `Filter` to perform content-negotiation and return the right representation:

```java
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import me.jvt.contentnegotiation.ContentTypeNegotiator;
import me.jvt.contentnegotiation.NotAcceptableException;
import me.jvt.uuid.Patterns;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.HttpMediaTypeNotAcceptableException;
import org.springframework.web.accept.ContentNegotiationManager;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.servlet.handler.DispatcherServletWebRequest;
import uk.gov.api.models.metadata.ErrorResponse;

@Component
public class CorrelationIdFilter extends OncePerRequestFilter {

  private final ObjectMapper objectMapper;
  private final ContentNegotiationManager contentNegotiationManager;

  public CorrelationIdFilter(
      ObjectMapper objectMapper, ContentNegotiationManager contentNegotiationManager) {
    this.objectMapper = objectMapper;
    this.contentNegotiationManager = contentNegotiationManager;
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
      handleInvalidCorrelationId(request, response);
      return; // make sure you have this set!
    }
    try {
      filterChain.doFilter(request, response);
    } finally {
      response.addHeader("correlation-id", uuid);
    }
  }

  private void handleInvalidCorrelationId(HttpServletRequest request, HttpServletResponse response)
      throws IOException {
    ContentTypeNegotiator negotiator = negotiator("application/json", "text/plain");
    MediaType resolved;
    try {
      resolved = resolve(request, negotiator);
    } catch (HttpMediaTypeNotAcceptableException ex) {
      response.setStatus(HttpServletResponse.SC_NOT_ACCEPTABLE);
      return;
    }
    if (MediaType.valueOf("application/json").isCompatibleWith(resolved)) {
      ErrorResponse errorResponse = new ErrorResponse();
      errorResponse.setError(ErrorResponse.Error.INVALID_REQUEST);
      errorResponse.setErrorDescription("The correlation-id is not a valid UUID.");

      response.setContentType(resolved.toString());
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      response.getWriter().write(objectMapper.writeValueAsString(errorResponse));
    } else if (MediaType.valueOf("text/plain").isCompatibleWith(resolved)) {
      response.setContentType(resolved.toString());
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      response.getWriter().write("The correlation-id is not a valid UUID.");
    } else {
      throw new IllegalStateException("MediaType " + resolved + " not handled");
    }
  }

  private MediaType resolve(HttpServletRequest request, ContentTypeNegotiator negotiator)
      throws HttpMediaTypeNotAcceptableException {
    List<MediaType> mediaTypes =
        contentNegotiationManager.resolveMediaTypes(new DispatcherServletWebRequest(request));
    List<me.jvt.http.mediatype.MediaType> converted =
        mediaTypes.stream().map(me.jvt.http.mediatype.MediaType::from).collect(Collectors.toList());
    try {
      me.jvt.http.mediatype.MediaType negotiated = negotiator.negotiate(converted);
      return MediaType.valueOf(negotiated.toString());
    } catch (NotAcceptableException e) {
      throw new HttpMediaTypeNotAcceptableException(e.getMessage());
    }
  }

  private static List<me.jvt.http.mediatype.MediaType> supported(String... mediaTypes) {
    return Arrays.stream(mediaTypes)
        .map(me.jvt.http.mediatype.MediaType::valueOf)
        .collect(Collectors.toList());
  }

  private static ContentTypeNegotiator negotiator(String... mediaTypes) {
    return new ContentTypeNegotiator(supported(mediaTypes));
  }
}
```

Which we can see working below:

```sh
% curl localhost:8080/apis -i -H 'Correlation-ID: 12' -H "accept: text/p
lain"
HTTP/1.1 400
Content-Type: text/plain;charset=ISO-8859-1
Content-Length: 39
Date: Tue, 18 Jan 2022 11:58:34 GMT
Connection: close

The correlation-id is not a valid UUID

% curl localhost:8080/apis -i -H 'Correlation-ID: 12' -H "accept: application/json"
HTTP/1.1 400
Content-Type: application/json;charset=ISO-8859-1
Content-Length: 89
Date: Tue, 18 Jan 2022 11:59:00 GMT
Connection: close

{"error":"invalid_request","error-description":"The correlation-id is not a valid UUID."}
```
