---
title: "Content Negotiation with `ControllerAdvice` and `ExceptionHandler`s in Spring (Boot)"
description: "How to perform content-negotiation in a Spring `ExceptionHandler`, to serve the correct representation of error to a consumer, based on the `Accept` header."
tags:
- blogumentation
- java
- spring-boot
- spring
- content-negotiation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-18T09:03:52+0000
slug: "spring-negotiate-exception-handler"
---
Update 2022-01-29: You may be interested in using [spring-content-negotiator](https://gitlab.com/jamietanna/spring-content-negotiator) to make this simpler!

I [really like content-negotiation](/posts/2021/01/05/why-content-negotiation/), and have found it to be really useful for both versioning, and i.e. providing HTML error pages instead of JSON when viewed in a web browser.

Spring handles this well with the ability to mark up your controllers with the media types that are consumed/produced by the endpoint:

```java
@GetMapping(produces = {"application/vnd.me.jvt+json"})
public ApiResponseContainer getAll() {
  Set<Api> apis = service.findAll();
  return new ApiResponseContainer(apis);
}

@PatchMapping(consumes = {"application/json-patch+json"}, produces = {"text/plain"})
// ...
```

And this allows us to negotiate, by default, using the `accept` header:

```sh
% curl localhost:8080/apis -H 'accept: application/vnd.me.jvt+json' -i
HTTP/1.1 200
Content-Type: application/vnd.me.jvt+json
Transfer-Encoding: chunked
Date: Tue, 18 Jan 2022 08:42:33 GMT

{"apis":[]}

# and when it fails
% curl localhost:8080/apis -H 'accept: text/plain' -i
HTTP/1.1 406
Content-Length: 0
Date: Tue, 18 Jan 2022 08:42:26 GMT
```

When an API endpoint, something in the service layer, or anywhere else in our Spring (Boot) application throws an exception, a common means of handling this is with a global `ControllerAdvice`, which allows us to write something like:

```java
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;

@ControllerAdvice
public class GlobalExceptionHandler {

  @ExceptionHandler(IllegalArgumentException.class)
  public ResponseEntity<VendoredJsonObject> handleIllegalArgumentException(
      IllegalArgumentException e, WebRequest request) {
    return new ResponseEntity<>(new VendoredJsonObject(e.getMessage()), HttpStatus.BAD_REQUEST);
  }

  public static class VendoredJsonObject {
    private final String error;

    public VendoredJsonObject(String error) {
      this.error = error;
    }

    public String getError() {
      return error;
    }
  }
}
```

This makes it much easier to handle our error cases, by having a central place to manage the exception-to-HTTP pipeline.

But notice that this method is currently returning a `VendoredJsonObject`, assuming that it's what the caller requires. If you've got multiple versions of your API models, or want to represent a different response for `text/plain` than anything in the `application/*+json` family, how would you do this?

Right now, there's no way inbuilt to Spring, unfortunately. It's been [discussed on the issue tracker](https://github.com/spring-projects/spring-framework/issues/21927) at least once, but no luck so far.

[I've requested that the algorithm that Spring uses to perform this negotiation is made public](https://github.com/spring-projects/spring-framework/issues/27944) (in so much that it's usable by consumers of the spring-web project) but until then, I fortunately have a solution that works.

While working on Java Lambdas, [one of the things we learned](/posts/2021/11/17/java-serverless-learnings/) was that writing HTTP compliant libraries is hard, and that trying to do content-negotiation isn't a straightforward task, especially if you're trying to use it for versioning, and may encounter non-obvious `accept` header strings, so a client can request multiple versions of the API.

[I ended up writing a very lightweight library for this](/posts/2021/01/11/content-negotiation-java/) to make this easier, as well as giving me a chance to learn about it a little more.

While investigating the problem for Spring, I found that I could actually use my library to perform this content-negotiation, albeit with a few tweaks.

You can get it by pulling the dependency in as part of your project, for example with Maven:

```xml
<dependency>
    <groupId>me.jvt.http</groupId>
    <artifactId>content-negotiation</artifactId>
    <version>1.1.0</version>
</dependency>
```

Or with Gradle:

```groovy
implementation 'me.jvt.http:content-negotiation:1.1.0'
```

As of the v1.1.0 release of this project, you can now convert Spring's `MediaType`s to the type that the library supports, and perform content negotiation, allowing you to write the following:

```java
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import me.jvt.contentnegotiation.ContentTypeNegotiator;
import me.jvt.contentnegotiation.NotAcceptableException;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.HttpMediaTypeNotAcceptableException;
import org.springframework.web.accept.ContentNegotiationManager;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.context.request.WebRequest;

@ControllerAdvice
public class GlobalExceptionHandler {

  private final ContentNegotiationManager contentNegotiationManager;

  public GlobalExceptionHandler(ContentNegotiationManager contentNegotiationManager) {
    this.contentNegotiationManager = contentNegotiationManager;
  }

  @ExceptionHandler(IllegalArgumentException.class)
  public ResponseEntity<Object> handleIllegalArgumentException(
      IllegalArgumentException e, WebRequest request) {
    ContentTypeNegotiator negotiator = negotiator("application/vnd.me.jvt+json", "text/plain");
    MediaType resolved;
    try {
      resolved = resolve(request, negotiator);
    } catch (HttpMediaTypeNotAcceptableException ex) {
      return new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
    }
    if (MediaType.valueOf("application/vnd.me.jvt+json").isCompatibleWith(resolved)) {
      return new ResponseEntity<>(new VendoredJsonObject(e.getMessage()), HttpStatus.BAD_REQUEST);
    } else if (MediaType.valueOf("text/plain").isCompatibleWith(resolved)) {
      return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
    } else {
      throw new IllegalStateException("MediaType " + resolved + " not handled");
    }
  }

  private MediaType resolve(WebRequest request, ContentTypeNegotiator negotiator)
      throws HttpMediaTypeNotAcceptableException {
    List<MediaType> mediaTypes =
        contentNegotiationManager.resolveMediaTypes((NativeWebRequest) request);
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

  public static class VendoredJsonObject {
    private final String error;

    public VendoredJsonObject(String error) {
      this.error = error;
    }

    public String getError() {
      return error;
    }
  }
}
```

We can see here that we've got some helper methods to simplify the creation of the `ContentTypeNegotiator`, which performs the actual content-negotiation based on a set of supported media types that the exception handler method should support. These helpers also perform manipulation from a Spring `MediaType` to the library's `MediaType`.

Notice that it's not _as_ pretty as it would be if we could use an annotation-based markup, or if we didn't need to return a different object for each data representation.

We can now see the negotiation in effect:

```sh
% curl localhost:8080/apis -H 'accept: application/vnd.me.jvt+json' -i
HTTP/1.1 200
Content-Type: application/vnd.me.jvt+json
Transfer-Encoding: chunked
Date: Tue, 18 Jan 2022 08:58:21 GMT

{"apis":[]}

# and when it fails
% curl localhost:8080/apis -H 'accept: text/plain' -i
HTTP/1.1 406
Content-Length: 0
Date: Tue, 18 Jan 2022 08:58:24 GMT
```

Notice that although we've allowed `text/plain` to be acceptable by the `handleIllegalArgumentException` method, we're getting a 406 back. This is because Spring is still checking that the `/apis` endpoint supports the representation we're negotiating, which means we only need to worry about the right representations being returned.
