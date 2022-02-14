---
title: "Simplifying Spring (Boot) `ExceptionHandler`s with `ResponseStatus` Annotations"
description: "How to use annotations to drive HTTP response codes from a Spring `ExceptionHandler`."
tags:
- blogumentation
- java
- spring-boot
- spring
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-20T14:48:47+0000
slug: "spring-annotation-exceptions"
image: /img/vendor/spring-logo.png
---
Mapping exceptions to HTTP errors in Spring is pretty handily done using the `ExceptionHandler` and `ControllerAdvice` mechanisms. But, if you're using quite a few exceptions that can be mapped to HTTP errors, you may find that you're having a fair bit of overhead for managing common exception cases, and I have seen it before that we may want to simplify the setup.

One option we can use is by combining the `ExceptionHandler` into a single handler for the `Exception` class. Minor caveat to mention that you won't include all Spring-handled exceptions - see [_Globally Logging all Spring (Boot) Exceptions_](/posts/2020/10/29/spring-log-all-exceptions/) for how to add them.

This solution allows us to annotate our exceptions, as such:

```java
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.BAD_REQUEST)
public class BadRequestException extends RuntimeException {
  public BadRequestException(String message) {
    super(message);
  }
}
```

Which can then be mapped using our exception handler:

```java
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Object> handleAllUnmatchedExceptions(Exception ex) {
        ResponseStatus responseStatus =
                AnnotationUtils.findAnnotation(ex.getClass(), ResponseStatus.class);
        if (responseStatus == null || HttpStatus.INTERNAL_SERVER_ERROR.equals(responseStatus.code())) {
          // for instance, we may only want 500s to be an empty body
          return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(ex.getMessage(), responseStatus.code());
    }
}
```

This also works with subclasses, as they inherit the annotations of a parent class.

Note that this is not without tradeoffs - I find it's easier to be explicit about the handlers and routes that things can happen, and it also will make it more difficult for your unit testing. It's also using Reflection which will slow the response down a little bit more than without using `AnnotationUtils`.

Alternatively, [you may want to extend `ResponseStatusException`](/posts/2022/02/12/spring-responsestatusexception/).
