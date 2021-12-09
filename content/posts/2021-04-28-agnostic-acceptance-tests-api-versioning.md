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
API versioning is very important, because there are going to be cases where you need to change your API, but don't want to break all your consumers, of which my [preference is using content negotiation](/posts/2021/01/05/why-content-negotiation/).

Regardless of how you do it, you're going to have a slightly different API to connect to the service - be that through a different URL, `accept` header, or some other means.

In [_Writing Environment-Agnostic Functional Acceptance Tests_](/posts/2021/01/18/agnostic-acceptance-tests/), I spoke about a way to structure your Cucumber tests to treat them more like the code you'd write in your production application, and I've found it to be a really nice pattern for working with tests.

However, at the time I didn't consider what this would look like for a versioned API.

# Scenarios

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

# Cucumber Hooks

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

# The `ApiVersion`

This API version is then a handy enum to capture the versions in a typed manner

```java
/**
 * A generic way of determining the version of an API's request/response contract for use with the
 * Proxy class, without relying too much on implementation details.
 *
 * <p>This enum should be left with no implementation details, allowing our Proxy class to
 * implement this. Please see below for a further explanation of why.
 */
public enum ApiVersion {
  ANY, ONE, TWO;
}
```

# The Proxy class

And then we have our [proxy class](/posts/2021/01/18/agnostic-acceptance-tests/) updated with the new parameter on methods that support API versioning:

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
    String mediaType = null;
    switch(version) {
      case ANY:
        // may not work if the contract changes (i.e. new headers required)
        mediaType = "application/*.json";
      case ONE:
        if (mediaType != null) {
          mediaType = "application/vnd.me.jvt.api.v1+json";
        }
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

# `ApiVersion` design

Something that's come up when talking to folks about this is the `ApiVersion`'s intent, so I thought I'd discuss the pros/cons of different alternatives, given it's not clear.

To consider this, I had the following requirements in mind:

- How do we keep steps generic, i.e. `Then the response matches the schema definition` without mentioning what version is used?
- How to support different response types (controlled through the `accept` header)?
- How to support different request body types (controlled through the `content-type` header)?
- API Versions don't necessarily just mean presenting a new `accept` / `content-type` - there can be new required/removed querystring parameters, headers, and even the format of the request body can change drastically, so we need to have a solution which works preferably independently to each route's different versioning

### Using `ApiVersion` as a pure enum

This is the above solution, and means:

- Step definitions are able to react accordingly by using a `switch / case` statement over the `ApiVersion` that's provided
- The Proxy class can support whichever response type versions
- The Proxy class can support whichever request type versions
- The Proxy class can support whichever other changes are required

But it also leads to:

- Step definitions are now a little more complex, as they need to do things based on what version is there, but it reads much better to have generic steps than to keep creating new steps / have the `ApiVersion` too configurable

### `ApiVersion` storing `accept` and `content-type` headers

Because we're using server-driven content negotiation for this example, we will want to store the `accept` and `content-type` headers with the version that we're communicating with. This gives us the following:

```java
public enum ApiVersion {
  ANY("application/*+json", "application/*+json"),
  ONE("application/vnd.me.jvt.api.v1+json", "application/vnd.me.jvt.api.v1+json"),
  TWO("application/vnd.me.jvt.api.v2+json", "application/vnd.me.jvt.api.v2+json");

  ApiVersion(String acceptHeader, String contentTypeHeader) {
    // ...
  }

  // constructor and getter omitted for brevity
}
```

This is good because:

- Steps are kept generic, and can validate against the `acceptHeader` and `contentTypeHeader` from the `ApiVersion`
- There's no duplication of these values across the project, so our Proxy class and our steps can refer to constant values for our `accept` / `content-type`s

However:

- This doesn't work when we have a service producing/consuming different types of content - `application/*+json`, `application/*+html`, `application/*+pdf`, etc, as we would then need i.e. `ApiVersion.JSON_ONE`
- If an route still requires a different API contract, your Proxy class will still need to implement something differently - is it worth keeping some logic in the `ApiVersion` and some in the Proxy then?

### Storing more in the `ApiVersion`

As mentioned, because there's more to the versioning of an API than just the `accept` / `content-type`, we may need other parameters for a request, which balloons the size and complexity of `ApiVersion`.

Unfortunately this then ties the `ApiVersion` to knowing how each route's HTTP logic is going to work, which strays from the Proxy class owning the contract, so I don't agree with this approach.

### Providing a factory for the `ApiVersion` to `RequestSpecification` conversion

One thing we could do is to provide a factory class that could convert an `ApiVersion` and return i.e. a `RequestSpecification` for a given route.

At that point though, we're just abstracting away from our Proxy class, which again I don't agree with.
