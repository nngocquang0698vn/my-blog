---
title: "Creating More Descriptive and Fluent Assertion Helpers"
description: "How to improve test readability, and developer experience, using assertion helpers."
date: 2021-11-04T19:26:02+0000
tags:
- blogumentation
- testing
- java
- ruby
- rspec
- assertj
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "assertion-helpers"
series: writing-better-tests
---
Tests are good for two reasons - firstly, they give you confidence that the thing you're building works in the way that it's meant to. Secondly, they describe in a way that is somewhat human readable how your system should work.

When you're writing tests, you want to make the test code clear and concise, so either when it fails, or when someone's reviewing the code, they can quickly understand what the intent behind the test is.

Although the testing community has built some very good tools for doing this, they're very unlikely to predict the way that your project and problem domain work.

This is absolutely fine - and in some cases, I'd be concerned if someone had written test code for my specific project! - and gives us the ability to shine.

For example, let's say that we're writing an application that uses OAuth2 to secure the authorization layer, and any request to the server requires the `payment` scope, with a specific server having issuer it.

We would end up writing something like this:

```java
assertThat(user.isAuthenticated()).isTrue();
assertThat(user.getAttributes().get("iss")).isEqualTo("https://issuer.domain/auth/server");
assertThat(user.getScopes()).contains("SCOPE_payment");
```

Whereas a more human-readable way of doing this would be:

```java
assertThat(user)
  .isAuthenticated() // could even be made implicit by `hasPaymentScope`
  .hasCorrectIssuer()
  .hasPaymentScope();
```

This gives us the ability to have a fluent chain of assertions, but it more importantly removes a lot of the plumbing of where the values are coming from.

Although some of that matters, it isn't necessarily important _in each and every test_ so we can instead abstract it out.

This can make a huge amount of difference when we've got a lot of things being asserted, or when things are quite nested.

The reduction of boilerplate, and providing domain-specific assertions leads to a much nicer development experience, and I've found to be hugely beneficial for developer experience.

Below you can see some examples of how to implement your own.

# Java + AssertJ

On Java projects, it's very likely you're using AssertJ for your assertions.

Following the same example as above, we can create our custom assertion by creating a class that extends the `AbstractAssert` class, and implement the assertions we want:

```java
import org.assertj.core.api.AbstractAssert;

public class UserAssert extends AbstractAssert<UserAssert, User> {
  private static final String ISSUER = "https://issuer.domain/auth/server";

  protected UserAssert(User user) {
    super(user, User.class);
  }

  public static UserAssert assertThat(User user) {
    return new UserAssert(user);
  }

  public UserAssert isAuthenticated() {
    if (!actual.isAuthenticated()) {
      failWithMessage(
          "The user was expected to have been successfully authenticated, but they weren't");
    }

    return this;
  }

  public UserAssert hasCorrectIssuer() {
    String iss = actual.getAttributes().get("iss");
    if (!ISSUER.equals(iss)) {
      failWithActualExpectedAndMessage(
          "https://issuer.domain/auth/server",
          iss,
          "The user was expected to have their token issued by our Authorization Server, but they did not");
    }

    return this;
  }

  public UserAssert hasPaymentScope() {
    if (!actual.getScopes().contains("SCOPE_payment")) {
      failWithMessage("The user was expected to have the `payment` scope, but they did not");
    }

    return this;
  }
}
```

We can then import the assertion in our tests and use it as the example above.

Something else that we're seeing here is that we've got the ability to actually write human-readable error messages. This is an underrated but _super_ helpful because it gives us a much nicer error when things go wrong - instead of an error like `expected "SCOPE_payment" to be present, but it was not`, we can add a bit more info.

This is even more helpful when running not just on component-level tests, but if you're running integration tests across multiple services, and it helps to have more human-readable errors.

# Ruby + RSpec

In a slightly different example, we can utilise RSpec's ability to [define custom matchers](https://relishapp.com/rspec/rspec-expectations/v/3-10/docs/custom-matchers/define-a-custom-matcher).

This allows us to specify a custom matcher, `have_same_querystring`, which we can then call as part of our tests:

```ruby
RSpec::Matchers.define :have_same_querystring do |expected|
  match do |actual|
    CGI.parse(URI.parse(expected).query) == CGI.parse(URI.parse(actual).query)
  end
end

RSpec.describe "..." do
  describe "..." do
    it "..." do
      expect('https://bar?utm=foo#fragment-is-ignored').to have_same_querystring "https://url?utm=foo"
    end
  end
end
```

# Alternatives

Alternatively, you could "just" use helper methods.

These work nicely, and allow us to for instance replace:

```java
assertThat(user.isAuthenticated()).isTrue();
assertThat(user.getAttributes().get("iss")).isEqualTo("https://issuer.domain/auth/server");
assertThat(user.getScopes()).contains("SCOPE_payment");
```

With the following:

```java
assertAuthenticated(user);
assertIssuer(user);
assertPaymentScope(user);

// ...

private void assertAuthenticated(User user) {
  assertThat(user.isAuthenticated()).isTrue();
}

private void assertIssuer(User user) {
  assertThat(user.getAttributes().get("iss")).isEqualTo("https://issuer.domain/auth/server");
}

private void assertPaymentScope(User user) {
  assertThat(user.getScopes()).contains("SCOPE_payment");
}
```

This looks alright, and is generally OK if you're only doing the same thing in a single class.

However, if you're needing to do this across multiple classes, or even multiple projects, please put that into an actual assertion helper!
