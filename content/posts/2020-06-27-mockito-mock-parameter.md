---
title: "Using `@Mock` as a Method Parameter with Mockito"
description: "Using `@Mock` on method parameters to reduce manual mock setups with Mockito."
tags:
- blogumentation
- java
- mockito
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-27T14:21:08+0100
slug: "mockito-mock-parameter"
image: https://media.jvt.me/35891268eb.png
---
As with many other Java developers, I heavily utilise [Mockito](https://mockito.org/) as a mocking framework for unit testing.

I'll often end up with tests that look like this:

```java
import org.mockito.Mock;

// ...

@Test
void getPagesReturnsValueFromDelegate() throws AnalyticsServiceException {
  // given
  LocalDate date = LocalDate.now();
  List<Page> mockList = mock(List.class);       // <--- this is what we're interested in
  when(delegate.getPages(any())).thenReturn(mockList);

  // when
  List<Page> actual = sut.getPages(date);

  // then
  assertThat(actual).isSameAs(mockList);
}
```

In this case, I want to create a `List` and check it's returned by the caching layer I'm testing.

However, this is a good example of where inlining our `mock` calls is bad, because IntelliJ warns us:

```
Unchecked assignment: 'java.util.List' to 'java.util.List<me.jvt.www.api.analytics.model.Page>'
```

This is quite annoying, and pollutes our codebase with warnings that we really want to avoid.

One solution would be to make it a field of the test class, and `@Mock` it there, but in this case it's a throwaway mock that is only required in this test, not in all tests (therefore wouldn't make as much sense to make a field variable).

Fortunately, we can utilise something my colleague Lewis taught me the other week, and use `@Mock` as a method parameter.

This gives us the following test:

```java
@Test
void getPagesReturnsValueFromDelegate(@Mock List<Page> mockList)
    throws AnalyticsServiceException {
  // given
  LocalDate date = LocalDate.now();
  when(delegate.getPages(any())).thenReturn(mockList);

  // when
  List<Page> actual = sut.getPages(date);

  // then
  assertThat(actual).isSameAs(mockList);
}
```

This would of course, make our tests more readable if we had many mocks being set up!

Note that you also need to make sure you're using Mockito's mock setup, i.e. with JUnit5 you would have:

```java
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class CachingAnalyticsServiceTest {
  // ...
```

This has been tested as of spring-boot-starter-test v2.2.4.RELEASE.
