---
title: "Codifying Your Technical / Architectural Standards with ArchUnit"
description: "How to use ArchUnit to codify your technical standards to reduce code review requirements, and arrive at a more consistent codebase."
tags:
- blogumentation
- java
- archunit
- code-review
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-21T16:34:03+0000
slug: code-standards-archunit
---
Whether you're in a team that's still meshing with your technical skills, or you've been working as a tight-knit group for years, there are likely going to be cases where someone trips up in terms of following architectural patterns in your codebase.

In my previous team, we built up a "technical ways of working" document that [constantly evolved](/posts/2021/11/05/secret-sauce/#a-consistent-and-evolving-ways-of-working) as we discussed changes at code review, then documented the decision for the future.

The problem with this approach is that the result was a document stored outside of our codebase, which meant it was less easy to follow and to add as part of the review process. Although we used tools like [Spotless](https://github.com/diffplug/spotless) to automate code style, we had no guardrails for architecture of the internal codebase.

This led to times where previous code review time was dedicated to commenting on someone not following the agreed patterns of the team, instead of focussing on the important things - like the feature we were trying to deliver.

About 18 months ago, one of my colleagues at the time, <span class="h-card"><a class="u-url" href="https://lewisfoster.me/">Lewis</a></span>, did a talk about [ArchUnit](https://www.archunit.org/) and started to flesh out the rules that were available for common libraries we used, but I'd not gotten around to looking at it in any depth. We'd [recently started to add them into Wiremock](https://github.com/wiremock/wiremock/pull/1634).

After learning about [jMolecules](https://github.com/xmolecules/jmolecules) at [yesterday's jChampions](https://www.youtube.com/watch?v=IzLHmPNmLLw), I've started to properly dig into ArchUnit, and will have more on jMolecules in a later post 👀

ArchUnit is a great test framework for building unit (integration?) tests around our code style and structure, and it's a really powerful addition to any Java codebase, which can help codify our standards into tests, so we don't need to worry about them when it comes to code review.

Code snippets can be found [in full in a sample project on GitLab](https://gitlab.com/jamietanna/archunit-example).

# Example: Don't allow `@Autowired` on fields

For instance, let's say that we're using a Spring (Boot) application, and we want to make sure that we don't write classes using field injection:

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class BadBean {
    @Autowired
    private Object field;
}
```

Although we may see warnings in our IDE/in tooling such as SonarQube, there's nothing actively stopping someone doing this, unless it is caught by a human in i.e. code review.

We'd be able to write the following ArchUnit test:

```java
import com.tngtech.archunit.junit.AnalyzeClasses;
import com.tngtech.archunit.junit.ArchTest;
import com.tngtech.archunit.lang.ArchRule;
import org.springframework.beans.factory.annotation.Autowired;

import static com.tngtech.archunit.base.DescribedPredicate.describe;
import static com.tngtech.archunit.base.DescribedPredicate.equalTo;
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes;

@AnalyzeClasses(packages = "me.jvt.hacking")
class ArchitectureTest {
  @ArchTest
    ArchRule fieldsShouldNotBeAutowired =
    classes()
      .that()
      .haveNameNotMatching(".*Test")
      .and()
      .areNotAnnotatedWith(Nested.class)
      .and()
      .containAnyFieldsThat(
          describe(
            "are Autowired by Spring",
            f -> f.tryGetAnnotationOfType(Autowired.class).isPresent()))
      .should()
      .containNumberOfElements(equalTo(0));
}
```

When run on the above, we can see the following test failures:

```
Architecture Violation [Priority: MEDIUM] - Rule 'classes that have name not matching '.*Test' and are top level classes and contain any fields that are Autowired by Spring should contain number of elements equal to '0'' was violated (1 times):
there is/are 1 element(s) in classes [me.jvt.hacking.BadBean]
java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that have name not matching '.*Test' and are top level classes and contain any fields that are Autowired by Spring should contain number of elements equal to '0'' was violated (1 times):
there is/are 1 element(s) in classes [me.jvt.hacking.BadBean]
```

# Example: Require naming of mocked fields

Now, let's say that we want to replace a class like so:

```java
@ExtendWith(MockitoExtension.class)
class AddMockPrefixToMockedFieldsTest {
  @Mock private BadBean bean;

  @Test
  void isNotNull() {
    // not a great test, but checks that Mockito is working
    assertThat(bean).isNotNull();
  }
}
```

We should have a class like, using `@Mock` and the `MockitoExtension` to manage mock lifecycles:

```java
@ExtendWith(MockitoExtension.class)
class AddMockPrefixToMockedFieldsTest {
  @Mock private BadBean bean;

  @Test
  void isNotNull() {
    // not a great test, but checks that Mockito is working
    assertThat(bean).isNotNull();
  }
}
```

This can be represented with an ArchUnit rule:

```java
@ArchTest
ArchRule mockAnnotationRequiresMockPrefix =
  fields()
    .that()
    .areDeclaredInClassesThat()
    .resideOutsideOfPackage("..architecture") // avoid this test class
    .and()
    .areDeclaredInClassesThat()
    .haveNameMatching(".*Test")
    .or()
    .areDeclaredInClassesThat()
    .areAnnotatedWith(Nested.class)
    .and()
    .areAnnotatedWith(Mock.class)
    .should()
    .haveNameMatching("mock.*");
```

Which displays the following error when executed against the problematic code:

```
Architecture Violation [Priority: MEDIUM] - Rule 'fields that are declared in classes that reside outside of package '..architecture' and are declared in classes that have name matching '.*Test' or are declared in classes that are annotated with @Nested and are annotated with @Mock should have name matching 'mock.*'' was violated (1 times):
Field <me.jvt.hacking.examples.AddMockPrefixToMockedFieldsTest.bean> does not match 'mock.*' in (AddMockPrefixToMockedFieldsTest.java:0)
java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'fields that are declared in classes that reside outside of package '..architecture' and are declared in classes that have name matching '.*Test' or are declared in classes that are annotated with @Nested and are annotated with @Mock should have name matching 'mock.*'' was violated (1 times):
Field <me.jvt.hacking.examples.AddMockPrefixToMockedFieldsTest.bean> does not match 'mock.*' in (AddMockPrefixToMockedFieldsTest.java:0)
```

# Example: Require use of `@Mock` on mock fields

On the other hand, we may already have a lot of fields that are currently instantiated with `mock`:

```java
class AddMockToFieldsTest {
    private List<BadBean> mockBeans;

    @BeforeEach
    void setup() {
        mockBeans = mock(List.class); // Unchecked assignment: 'java.util.List' to 'java.util.List<me.jvt.hacking.BadBean>'
    }

    @Test
    void isNotNull() {
        // not a great test, but checks that Mockito is working
        assertThat(mockBeans).isNotNull();
    }
}
```

But we want to migrate them to:

```java
@ExtendWith(MockitoExtension.class)
class AddMockToFieldsTest {
    @Mock
    private List<BadBean> mockBeans;

    @Test
    void isNotNull() {
        // not a great test, but checks that Mockito is working
        assertThat(mockBeans).isNotNull();
    }
}
```

To do this, we'd create the following ArchUnit test:

```java
@ArchTest
ArchRule mockPrefixRequiresMockAnnotation =
  fields()
    .that()
    .areDeclaredInClassesThat()
    .resideOutsideOfPackage("..architecture") // avoid this test class
    .and()
    .areDeclaredInClassesThat()
    .haveNameMatching(".*Test")
    .or()
    .areDeclaredInClassesThat()
    .areAnnotatedWith(Nested.class)
    .and()
    .haveNameMatching("mock.*")
    .should()
    .beAnnotatedWith(Mock.class);
```

And would get a handy error message:

```
Architecture Violation [Priority: MEDIUM] - Rule 'fields that are declared in classes that reside outside of package '..architecture' and are declared in classes that have name matching '.*Test' or are declared in classes that are annotated with @Nested and have name matching 'mock.*' should be annotated with @Mock' was violated (1 times):
Field <me.jvt.hacking.examples.AddMockToFieldsTest.mockBeans> is not annotated with @Mock in (AddMockToFieldsTest.java:0)
java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'fields that are declared in classes that reside outside of package '..architecture' and are declared in classes that have name matching '.*Test' or are declared in classes that are annotated with @Nested and have name matching 'mock.*' should be annotated with @Mock' was violated (1 times):
Field <me.jvt.hacking.examples.AddMockToFieldsTest.mockBeans> is not annotated with @Mock in (AddMockToFieldsTest.java:0)
```

# Example: Require `final` fields

Something quite commonly required is to make sure that we use immutable classes, the first step of which is to make sure that we can't create a class like so, with mutable fields:

```java
public class NonFinalFields {
  private int count;
  private String version;

  public NonFinalFields(int count, String version) {

    this.count = count;
    this.version = version;
  }

  public int getCount() {
    return count;
  }

  public String getVersion() {
    return version;
  }
}
```

So we'd create the following ArchUnit rule to enforce this:

```java
@ArchTest
ArchRule alwaysFinalFields =
  classes()
    .that()
    .haveNameNotMatching(".*Test")
    .and()
    .areNotAnnotatedWith(Nested.class)
    .and()
    .haveNameNotMatching(".*Dao")
    .and()
    .resideOutsideOfPackage("..architecture")
    .should()
    .haveOnlyFinalFields();
```

And then we get the following error:

```
Architecture Violation [Priority: MEDIUM] - Rule 'classes that have name not matching '.*Test' and are not annotated with @Nested and have name not matching '.*Dao' and reside outside of package '..architecture' should have only final fields' was violated (2 times):
Field <me.jvt.hacking.NonFinalFields.count> is not final in (NonFinalFields.java:0)
Field <me.jvt.hacking.NonFinalFields.version> is not final in (NonFinalFields.java:0)
java.lang.AssertionError: Architecture Violation [Priority: MEDIUM] - Rule 'classes that have name not matching '.*Test' and are not annotated with @Nested and have name not matching '.*Dao' and reside outside of package '..architecture' should have only final fields' was violated (2 times):
Field <me.jvt.hacking.NonFinalFields.count> is not final in (NonFinalFields.java:0)
Field <me.jvt.hacking.NonFinalFields.version> is not final in (NonFinalFields.java:0)
```

# Conclusion

Hopefully this gives you a bit of a flavour of what you can do with ArchUnit, and what you may want to think about for your projects to maintain consistent codebases.

You may also fancy a look at the [example use cases ArchUnit documents](https://www.archunit.org/use-cases).
