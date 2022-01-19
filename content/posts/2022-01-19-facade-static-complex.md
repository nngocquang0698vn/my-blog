---
title: "Using the Facade Pattern to More Easily Test `static` or Complex Classes"
description: "How to use the Facade design pattern to more easily test classes that are more complex than our tests need to understand."
tags:
- java
- testing
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-19T13:40:56+0000
slug: "facade-static-complex"
series: writing-better-tests
---
Something that came up recently with some cross-organisation colleagues is how to better test a complex interface, such as the AWS SDK in a unit test.

It's something I've come up against before, both with complex clients like AWS SDK's `S3Client`, but also with libraries like RestAssured or SLF4J's `MDC`. And each time, the [Facade design pattern](https://refactoring.guru/design-patterns/facade) comes up as being a nice solution.

Let's say that we want to write a unit test to verify that the following API request is sent using Rest Assured:

```java
import java.util.UUID;

import static io.restassured.RestAssured.given;

public class ApiClient {
  public Object doCall() {
    return RestAssured.given()
      .header("correlation-id", UUID.randomUUID().toString())
      .get("http://example.com/api");
  }
}
```

Unfortunately we'll notice that `given()` is a `static` method which we cannot test - at least without something evil like PowerMock, which we should _really_ avoid where possible.

One of the easiest ways to solve this - which I use every time I start to work with Rest Assured - is to create a `RequestSpecificationFactory`, which is a facade around RestAssured's `given` method:

```java
import static io.restassured.RestAssured.given;

import io.restassured.specification.RequestSpecification;

public class RequestSpecificationFactory {

  public RequestSpecification newRequestSpecification() {
    return given();
  }
}
```

There are other things we can do here, like be able to apply common configuration, or allow constructing the `RequestSpecificationFactory` with a set of `Filter`s to apply to each method, but the key thing here is that we create a class that extracts the `static` calls, or calls that may require a lot of setup, or cannot be easily unit tested, and we make it injectable:

```java
import java.util.UUID;

public class ApiClient {

  private final RequestSpecificationFactory factory;

  public ApiClient() {
    this(new RequestSpecificationFactory());
  }

  /*
    Test only, but could alternatively be for all use cases, and we require a
    <code>RequestSpecificationFactory</code> to be injected
  */
  ApiClient(RequestSpecificationFactory factory) {
    this.factory = factory;
  }

  public Object doCall() {
    return factory
        .newRequestSpecification()
        .header("correlation-id", UUID.randomUUID().toString())
        .get("http://example.com/api");
  }
}
```

Now we can provide this `RequestSpecificationFactory` instance to be injected via the constructor, allowing for easy unit testing, as well as giving us the ability to i.e. use the same instance of the `RequestSpecificationFactory` everywhere.
