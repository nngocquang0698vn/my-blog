---
title: "Using Abstract Test Classes To Reduce Duplication in Java"
description: "How to use Java's abstract classes to reduce duplication of code across unit tests with common functionality."
tags:
- java
- junit5
- testing
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-08-11T17:28:05+0100
slug: "abstract-test-class"
series: writing-better-tests
image: https://media.jvt.me/7e70383567.png
---
When you're writing unit tests, there are likely going to be cases where you have a lot of tests doing similar things.

I don't necessarily mean the test data that is used by tests - as we could i.e. utilise JUnit5's [Parameterized Tests](https://junit.org/junit5/docs/current/user-guide/#writing-tests-parameterized-tests) - but more that the tests themselves follow similar shapes.

For instance, what about where we want test coverage over an HTTP endpoint's code, but have different method handler depending on the the `accept`/`content-type` headers of the request, or how the request is authenticated? In this case, we could have a set of tests for each of these options, but that can be a bit more duplication than we want, especially if we're striving for full test coverage.

Recently, I've been working on a pretty formatter for Gherkin files, and as part of that, I've got a lot of the same tests being executed:

- is the file formatted correctly (including whitespace)?
- is the file formatted correctly (excluding whitespace)?
- does the file get parsed to the same result as we're expecting?

In this case, the only difference with the test cases are that there's a different file in use, otherwise are identical.

For all of these cases, I don't want to have to write the same tests repeatedly, and then have to remember to update all the places that have these references.

(In this example I'll use JUnit5 as the test framework, but this should be possible with other frameworks.)

What I really want to do, for the Gherkin example above, is to have a single set of common tests, which can then be run against any new set of feature files, with minimal duplication.

To do this, we can utilise JUnit5's Nested test classes, as well as Java's abstract classes to create our test case:

```java
@Nested
class ScenarioOutlineWithDocstring extends GoodTest {

  public ScenarioOutlineWithDocstring() {
    super("scenario_outline_with_docstring.feature");
  }

  @Test
  void anotherTestIfWeWantTo() {
    // if we wanted to add specific tests for this class, we can do but
    // otherwise it's just going to execute everything in our base class,
    // `GoodTest`
  }
}
```

This pushes the heavy lifting to the `GoodTest` class, and allows our overall test case class to be straightforward.

This then allows our base class to be defined as below - note that the two abstract test classes isn't required, it just works for my implementation:

```java
abstract class GoodTest extends AbstractTestCases {

  private final String filename;

  public GoodTest(String filename) {
    this.filename = filename;
  }

  @Override
  String filename() {
    return this.filename;
  }

  String inputFilename(String filename) {
    return "/input/good/" + filename;
  }

  @Test
  void isCorrectlyFormatted() {
    String expected = readFile(outputFilename(filename()));

    String actual = prettyPrint();

    assertThat(actual).isEqualTo(expected);
  }

  // other tests
}

abstract class AbstractTestCases {
  abstract String filename();

  abstract String inputFilename(String filename);

  String outputFilename(String filename) {
    return "/output/" + filename;
  }

  String readFile(String filename) {
    return ...; // ommited for brevity
  }

  String prettyPrint() {
    String filename = inputFilename(filename());
    return formatter.format(tokens(readFile(filename)));
  }

  List<Token> tokens(String raw) {
    return ...; // ommited for brevity
  }

  List<Envelope> envelopes(String raw) {
    return ...; // ommited for brevity
  }
}
```

This provides us a handy abstraction, which gives us a consistent place to put new tests, as well as allowing specific implementations to add custom tests for their specific cases, as well as handling some base case.

This can also do things like allow the implementing class to do things like:

```java
@Nested
class FormPost extends FormTest {

  @Override
  String contentType() {
    return MediaType.APPLICATION_FORM_URLENCODED_VALUE;
  }
}

@Nested
class MultipartFormPost extends FormTest {

  @Override
  String contentType() {
    return MediaType.MULTIPART_FORM_DATA_VALUE;
  }
}
```

Or set up the body depending on what type of request it is:

```java
abstract class JsonTest {
  abstract ObjectNode body();

  abstract String expectedScope();

  // ...
}
```

However, this isn't always quite perfect, and so I'd recommend this pattern in the case that:

- You have more tests than makes sense to be `@ParameterizedTest` (maybe 4 sets of tests?)
- You want to have a more structured hierarchy / naming structure to your tests
- You need any shared functionality that could be utilised by `abstract` methods being used by other methods in the baseclass, such as `prettyPrint()` above.
- You definitely know you'll want to add tests in the child classes (i.e. `ScenarioOutlineWithDocstring`) that are extra to what is provided in the base class
