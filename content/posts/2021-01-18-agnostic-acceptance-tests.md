---
title: "Writing Environment-Agnostic Functional Acceptance Tests"
description: "How to structure your (Java) functional acceptance tests to make it easier to add environment-specific configuration."
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
date: 2021-01-18T12:03:16+0000
slug: "agnostic-acceptance-tests"
---
Functional Acceptance Tests are a great way of validating - on top of all the other testing we do - that the service(s) we're testing are performing their required business needs.

Over the last few years, I've worked with several set of tests, with various needs; I've worked with a monolithic Identity Service that requires testing of OAuth2, authentication, and other custom functionality, all within the same codebase; I've worked on microservices that are consumed by internal services; microservices that are consumed by external partners; I've built system tests that need to exercise our PSD2 platform and validate the whole end-to-end journey a third party (and customer) would perform. I've also done this as both a Software Quality Engineer and a Software Development Engineer, with differing levels of ownership and motivation for the tests I'm writing.

Over these years, I've picked up on a pattern I've found to be pretty helpful when structuring our tests, and making it possible to more easily make changes to your test suites, be it extending the number of features and endpoints you're validating, or changing which environments you target your tests against.

This requires a bit of rework of how your tests are currently written or how you plan to write them in the future, but I promise, it will be worth the small tweaks!

Another driver for this is that it focusses our efforts on trying to deliver our Functional Acceptance Tests with the same level of quality, and code approach, as we would in the code that ships to production, which means that our codebase is thought about in the same way, rather that deprioritising the code quality in the not-production code.

# Class Structure Is Key

Something I quite like is using our class structure to think about the discrete things that a service needs to do, which makes it easier to reason about the service and how we want to interact with it.

With the below examples, we're going to assume a service, called the Product Service, with two endpoints:

- `/health`
- `/products/<productId>`

With this in mind, we create two new classes:

- a `ProductServiceProxy` class which will model all interactions with the Product Service, implement the required contract for the service, and perform the actual HTTP call
- a `RequestSupplier` interface, which is syntactic sugar around Java's `Supplier`, and gives us a common way to produce `RequestSpecification`s for our proxy

(Note that in the examples below I'll be using Rest Assured as my HTTP library of choice, but you can swap out the HTTP layer for whichever library work for you!)

```java
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import java.util.UUID;

/**
 * A proxy for interactions with the Product Service by implementing the service's core contract,
 * and allowing other tweaks through {@link RequestSupplier}s.
 */
public class ProductServiceProxy {

  private RequestSupplier builder;
  private String baseUri;

  public ProductServiceProxy(RequestSupplier supplier, String baseUri) {
    this.builder = supplier;
    this.baseUri = baseUri;
  }

  /**
   * Retrieve the health status of the service.
   *
   * @return the response from the server
   */
  public Response healthcheck() {
    return prepare().basePath("/health").get();
  }

  /**
   * Retrieve a product by its identifier.
   *
   * @param productId the product identifier
   * @return the response from the server
   */
  public Response retrieveProduct(String productId) {
    return prepare()
        .header("Tracking-Id", UUID.randomUUID().toString())
        .basePath("/products/" + productId)
        .get();
  }

  private RequestSpecification prepare() {
    return builder.get().baseUri(baseUri);
  }
}
```

```java
import io.restassured.specification.RequestSpecification;

import java.util.function.Supplier;

/**
 * A {@link Supplier} to prepare a given {@link RequestSpecification} for use by a proxy class.
 *
 * <p>Prepares the request, by simply being a facade for {@link io.restassured.RestAssured}.given(),
 * or being a decorating delegate to provide extra configuration, such as request OAuth2/API Key
 * authentication, tweaking HTTPS validation, or Mutual TLS.
 */
public interface RequestSupplier extends Supplier<RequestSpecification> {
  /**
   * Build a new {@link RequestSpecification}.
   *
   * @return a {@link RequestSpecification}, with optional configuration applied to it.
   */
  RequestSpecification get();
}
```

For now, we focus on creating a single implementation, the `BaseRequestSupplier`, which is a facade around Rest Assured:

```java
import static io.restassured.RestAssured.given;

import io.restassured.specification.RequestSpecification;

/**
 * Implementation of {@link RequestSupplier} that is a facade for Rest Assured.
 *
 * <p>This should be the base implementation for chains of {@link RequestSupplier}s.
 */
public class BaseRequestSupplier implements RequestSupplier {
  @Override
  public RequestSpecification get() {
    return given();
  }
}
```

This provides us a straightforward pattern to modify the `RequestSpecification`s that we're using to interact with our service, allowing us to use the [decorator](https://refactoring.guru/design-patterns/decorator) and [hide delegate](https://refactoring.guru/hide-delegate) patterns produce a pre-configured `RequestSpecification` for how we're communicating with the service.

## More complex examples

With the Identity Service example I mentioned before, this gets a little bit more difficult, because there are a tonne of interactions that happen, across various different domains.

For instance, OAuth2 as a domain includes various types of interactions - client registration, OAuth2 or OpenID configuration, handling different grant types, token introspection, token revocation, and the list goes on. This required a tonne of methods to allow calling the service, and due to the number of other domains included, it didn't make sense to keep it in the same class.

Instead, we broke it out into multiple proxy classes by domain i.e. `OAuth2Proxy` `AuthenticationProxy`, `HealthCheckProxy`. This allows us to more easily see when we're invoking the class what domain we're entering, as well as giving us a cleaner class that is easier to read, test, and use!

# Making Environment-Specific Changes

Something I've seen in a few codebases up until this point are performing environment-specific changes in the Cucumber step definitions, instead of leaving it to be something configured outside of this (i.e. via constructor configuration or dependency injection). For instance, using the following contrived example:

```java
@When("^I retrieve the product information$")
public void retrieveTheProduct() {
  if (this.environment.equals("LOCAL")) {
    response = doGet("/products/1234");
  } else if (this.environment.equals("DEV")) {
    response = doGetWithApiKey("/products/234"); // this method is the same as `doGet` but just adds a parameter
  } else if (this.environment.equals("QA")) {
    response = doGetWithApiKey("/products/11111");
  }
}
```

Because this is often in each step definition, it makes it pretty difficult to work with longer term, and makes it hard to discover what each environment is doing differently, and can just be difficult to read.

We can refactor this much more easily by using our proxy and `RequestSupplier` pattern, which has built the groundwork to then use the [decorator pattern](https://refactoring.guru/design-patterns/decorator) like so:

```java
import io.restassured.specification.RequestSpecification;

/**
 * A {@link RequestSupplier} to authenticate requests with an API key, for use with an API gateway.
 */
public class ApiKeyRequestSupplier implements RequestSupplier {

  private final RequestSupplier delegate;
  private final String apiKey;

  /**
   * Construct a new {@link ApiKeyRequestSupplier}.
   *
   * @param delegate the {@link RequestSupplier} to delegate the work to
   * @param apiKey the api key to add to the request
   */
  public ApiKeyRequestSupplier(RequestSupplier delegate, String apiKey) {
    this.delegate = delegate;
    this.apiKey = apiKey;
  }

  @Override
  public RequestSpecification get() {
    return delegate.get().header("Api-Key", apiKey);
  }
}
```

This allows us to now chain our `RequestSupplier`s, and construct our  `ProductServiceProxy` with the suppliers dependent on the environment we're running in, much more easily:

```java
RequestSupplier base = new BaseRequestSupplier();
RequestSupplier actual;
if (this.environment.equals("DEV") {
  actual = base;
} else {
  actual = new ApiKeyRequestSupplier(base, "the-key");
}
ProductServiceProxy proxy = new ProductServiceProxy(actual, "https://url/path");
```

Because we're following the decorator pattern, this allows us to continue using the same base contract the service requires, but we can modify the request to add other changes, such as API key authentication.

We can delegate to either a default implementation, or have multiple layers of these, depending on whether you also need to perform Mutual TLS, add other required headers, etc.

We would then, in our Cucumber step definition classes to have something like this:

```java
@When("^I retrieve the product information$")
public void retrieveTheProduct() {
  // note that the below can be further simplified, by removing these hardcoded IDs in this place!
  if (this.environment.equals("LOCAL")) {
    response = this.proxy.retrieveProduct("1234");
  } else if (this.environment.equals("DEV")) {
    response = this.proxy.retrieveProduct("/products/234");
  } else if (this.environment.equals("QA")) {
    response = this.proxy.retrieveProduct("/products/11111");
  }
}
```

This allows us to much more easily simplify our HTTP logic, allowing our step definitions themselves to focus on what they're trying to test, and our HTTP logic can be set up one, through configuration.
