---
title: "Globally Logging all Spring (Boot) Exceptions"
description: "How to log whenever an exception triggers on an exception handler with Spring."
tags:
- blogumentation
- spring
- spring-boot
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-10-29T22:26:19+0000
slug: "spring-log-all-exceptions"
image: /img/vendor/spring-logo.png
---
There are several ways to [set up exception handling in a Spring project](https://www.baeldung.com/exception-handling-for-rest-with-spring), so you can map a Java `Exception` to an HTTP response.

But regardless of how you set it up, it's likely that operationally, you'd want to understand when users are going through common error flows. This may lead you to a class like this, with various exception handlers:

```java
import java.util.Set;
import java.util.stream.Collectors;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import me.jvt.hacking.exception.ErrorResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@ControllerAdvice
public class ExceptionHandler extends ResponseEntityExceptionHandler {

  private static final Logger LOGGER = LoggerFactory.getLogger(MicropubExceptionHandler.class);

  @ExceptionHandler(ConstraintViolationException.class)
  public final ResponseEntity<ErrorResponse> constraintViolationException(
      ConstraintViolationException constraintViolationException) {
    Set<String> messages =
        constraintViolationException.getConstraintViolations().stream()
            .map(ConstraintViolation::getMessage)
            .collect(Collectors.toSet());

    ErrorResponse errorResponse = new ErrorResponse();
    errorResponse.setError("invalid_request");
    errorResponse.setErrorDescription(String.format("Validation failed on the request: %s", String.join(" | ", messages)));

    LOGGER.warn("An invalid request was rejected for reason: {}", message);
    return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
  }

  // other handlers
}
```

This is really useful, and helps map given exception(s) to a given HTTP response, and at the same time logs it for further diagnosis. But this can be improved two ways - firstly, we can take advantage of the base class's [`handleExceptionInternal` method](https://docs.spring.io/spring-framework/docs/5.3.0/javadoc-api/org/springframework/web/servlet/mvc/method/annotation/ResponseEntityExceptionHandler.html#handleExceptionInternal-java.lang.Exception-java.lang.Object-org.springframework.http.HttpHeaders-org.springframework.http.HttpStatus-org.springframework.web.context.request.WebRequest-) which provides a common way to map your exceptions to HTTP responses.

The great thing about this is that it's already in use by the built-in exceptions handled by [`ResponseEntityExceptionHandler` method](https://docs.spring.io/spring-framework/docs/5.3.0/javadoc-api/org/springframework/web/servlet/mvc/method/annotation/ResponseEntityExceptionHandler.html), so you're consistent with how Spring is doing it.

Therefore it's recommended that you modify your own code to do this, too:

```java
import java.util.Set;
import java.util.stream.Collectors;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import me.jvt.hacking.exception.ErrorResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@ControllerAdvice
public class ExceptionHandler extends ResponseEntityExceptionHandler {

  private static final Logger LOGGER = LoggerFactory.getLogger(MicropubExceptionHandler.class);

  @ExceptionHandler(ConstraintViolationException.class)
  public final ResponseEntity<Object> constraintViolationException(
      ConstraintViolationException constraintViolationException, WebRequest request) {
    Set<String> messages =
        constraintViolationException.getConstraintViolations().stream()
            .map(ConstraintViolation::getMessage)
            .collect(Collectors.toSet());
    String message = String.format("Validation failed on the request: %s", String.join(" | ", messages));
    ErrorResponse errorResponse = new ErrorResponse();
    errorResponse.setError("invalid_request");
    errorResponse.setErrorDescription(message);

    LOGGER.warn("An invalid request was rejected for reason: {}", message);
    return handleExceptionInternal(
        constraintViolationException,
        errorResponse,
        new HttpHeaders(),
        HttpStatus.BAD_REQUEST,
        request);
  }

  // other handlers
}
```

This is great, but we still need to set up our logging each time, which can be a bit annoying. But even worse is the fact that even with this approach, we can't add logging for built-in exceptions like `HttpMessageNotReadableException`.

Hopefully you can see where this is going - because we're using `handleExceptionInternal`, we can override our implementation in our `ExceptionHandler` to perform logging based on the HTTP status code that's expected:

```java
import java.util.Set;
import java.util.stream.Collectors;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import me.jvt.hacking.exception.ErrorResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@ControllerAdvice
public class ExceptionHandler extends ResponseEntityExceptionHandler {

  private static final Logger LOGGER = LoggerFactory.getLogger(MicropubExceptionHandler.class);

  @Override
  protected ResponseEntity<Object> handleExceptionInternal(
      @NonNull Exception ex,
      @Nullable Object body,
      @NonNull HttpHeaders headers,
      HttpStatus status,
      @NonNull WebRequest request) {
    if (status.is5xxServerError()) {
      LOGGER.error("An exception occured, which will cause a {} response", status, ex);
    } else if (status.is4xxClientError()){
      LOGGER.warn("An exception occured, which will cause a {} response", status, ex);
    } else {
      LOGGER.debug("An exception occured, which will cause a {} response", status, ex);
    }
    return super.handleExceptionInternal(ex, body, headers, status, request);
  }

  // handlers
}
```

This then gives us logging, everywhere, because we're now always delegating to `handleExceptionInternal`, and getting handy logs.
