---
title: "Adding API Versioning to your Environment-Agnostic Functional Acceptance Tests"
description: "How to adapt the Proxy pattern to allow for testing against a versioned API."
tags:
- java
- testing
- testing
- software-testing
- cucumber
- software-quality
- quality-engineering
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-04-28T18:59:12+0100
slug: "agnostic-acceptance-tests-api-versioning"
series: environment-agnostic-acceptance-tests
---
API versioning is very important, because there are going to be cases where you need to change your API, but don't want to break all your consumers, of which my [preference is using content negotiation]({{< ref 2021-01-05-why-content-negotiation >}}).

Regardless of how you do it, you're going to have a slightly different API to connect to the service - be that through a different URL, `accept` header, or some other means.

In [_Writing Environment-Agnostic Functional Acceptance Tests_]({{< ref 2021-01-18-agnostic-acceptance-tests >}}), I spoke about a way to structure your Cucumber tests to treat them more like the code you'd write in your production application, and I've found it to be a really nice pattern for working with tests.

However, at the time I didn't consider what this would look like for a versioned API.

Let's start by thinking about our scenarios, i.e. with `features/product.feature`:

```cucumber
Feature: Happy path product data
  Given something
  When I retrieve the product information
  Then I get an OK response
```

This is great, and doesn't include anything related to versioning. However, given this is something quite key to the functionality of the service, we probably should have something.

We could write something like the below, which embeds that into the step definitions:

```cucumber
Feature: The Product Service returns some product data

  Scenario Outline: Happy path product data
    Given something
    # I don't recommend this! Not super readable for not-as-technical folks
    When I retrieve the product information, using the <version> contract
    Then I get an OK response

  Examples:

    | version   |
    | version 1 |
    | version 2 |
```

However, I don't like this, and feel it doesn't provide the value that someone reading the feature files needs.

I'd recommend splitting out our features into i.e. `features/product/v1.feature`, and add a `@v1` tag to the feature file, but otherwise have nothing version related in the steps:

```cucumber
@v1
Feature: The Product Service returns some product data, using different representations for consumers. This tests version 1.

  Scenario: Happy path product data
    Given something
    When I retrieve the product information
    Then I get an OK response
```

This gives us clear language for our steps, which I find to be pretty good.

We can then extend this for any number of API versions, as well as capturing the fact that a consumer could request any version i.e. `features/product/any-version.feature`:

```cucumber
@any-version
Feature: The Product Service returns some product data, using different representations for consumers. This tests the case where consumers may not pin to a version.

  Scenario: Happy path product data
    Given something
    When I retrieve the product information
    Then I get an OK response
```

To make this work, we should have some Cucumber hooks to set the current `ApiVersion` in our `World`:

```java
// world is an instance of state being shared across a scenario

@Before("@any-version")
public void anyVersionTag() {
  world.setVersion(ApiVersion.ANY);
}

@Before("@v1")
public void version1Tag() {
  world.setVersion(ApiVersion.ONE);
}

@Before("@v2")
public void version2Tag() {
  world.setVersion(ApiVersion.TWO);
}
```

This API version is then a handy enum to capture the versions in a typed manner

```java
public enum ApiVersion {
  ANY, ONE, TWO;
}
```

And then we have our proxy class updated with the new parameter on methods that support API versioning:

```java
public class ProductServiceProxy {

  // ...

  /**
   * Retrieve a product by its identifier.
   *
   * @param productId the product identifier
   * @param version the version of the API resource to retrieve
   * @param filters any {@link Filter}s to apply to the request
   * @return the response from the server
   */
  public Response retrieveProduct(String productId, ApiVersion version, Filter... filters) {
    String mediaType;
    switch(version) {
      case ANY:
        // may not work if the contract changes (i.e. new headers required)
        mediaType = "application/*.json";
      case ONE:
        mediaType = "application/vnd.me.jvt.api.v1+json";
        return prepare(filters)
          .header("Accept", mediaType)
          .header("Tracking-Id", UUID.randomUUID().toString())
          .basePath("/products/" + productId)
          .get();
      case TWO:
        return prepare(filters)
          .header("Accept", "application/vnd.me.jvt.api.v2+json")
          .header("Tracking-Id", UUID.randomUUID().toString())
          .header("Another-Header", "some value")
          .basePath("/products/" + productId)
          .get();
      default:
        throw new IllegalArgumentException("Version " + version + " is not supported");
    }
  }

  // ...
}
```

This now gives us a way to interact with our versioned API, assert things based on that version, and generally work a bit nicer with our Cucumber tests.
