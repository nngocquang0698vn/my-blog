---
title: "Avoiding Spring context issues when parallelising `@Nested` Spring integration tests"
description: "Using abstract base classes to reduce risk of Spring context overall issues with Spring (Boot) integration tests."
date: 2022-03-22T11:44:08+0000
syndication:
- "https://brid.gy/publish/twitter"
tags:
- "blogumentation"
- "java"
- "spring"
- "spring-boot"
- "testing"
- "tdd"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/3e88e3081a.png"
slug: "spring-integration-test-nested"
---
I write a lot of integration tests with Spring (Boot) and enjoy using nested test classes while using JUnit 5 to provide some structure.

For instance, I may have the following test hierarchy:

```java
V1AlphaFetcherIntegrationTest { // top-level class
  Fetch { // method under test
    InGeneral { // regardless of the happy/sad path testing
      delegatesToMapperFromMethod()
      itAddsRequestCorrelationIdToMdcFromMdc()
    }

    WhenNotFound {
      // ...
    }

    WhenBadRequest {
      // ...
    }
  }
}
```

This structure gives better breakdown of where tests are applied, allowing a more targeted test setup/teardown for each set of specific cases, and generally helps visibility of tests and failures, too.

On the flipside as I [default to parallelisation](https://www.jvt.me/posts/2021/06/01/parallel-tests/) with my tests, this leads to the need to juggle the Spring context.

I've hit a number of issues with this parallelisation in the past, with i.e. `MockBean`s sometimes having more invocations than expected, or where we've got setup for mocks being crossed over.

# Before

Previously, or where not managing Spring context, I'd reach to the following hierarchy for tests, where we have our overall integration test class, which has beans set up and any other helper methods, which can then be consumed inside the nested classes:

```java
@ExtendWith(SpringExtension.class)
@Import({IntegrationTestBase.Config.class, JacksonAutoConfiguration.class})
class V1AlphaFetcherIntegrationTest {
  protected final TestLogger logger = TestLoggerFactory.getTestLogger(V1AlphaFetcher.class);

  @MockBean protected Mdc mdc;

  @Autowired protected ObjectMapper objectMapper;
  @Autowired protected MockWebServer server;

  @Autowired protected V1AlphaFetcher fetcher;

  @TestConfiguration
  static class Config {

    @Bean
    public MockWebServer webServer() {
      return new MockWebServer();
    }

    @Bean
    public WebClient webClient() {
      return WebClient.builder().build();
    }

   // other beans
  }

  @AfterEach
  void tearDown() {
    logger.clear();
  }

  // shared methods


  @Nested
  class Fetch {
    @Nested
    class InGeneral {
      // tests, using the shared beans like `mdc`
    }
  }
}
```

This would then lead to some awkward state management, possibly requiring a `@BeforeEach` in each test to reset things, which isn't ideal, and overcomplicates our tests.

# After

The solution I find works is to instead create a base class for each nested test case, i.e. `IntegrationTestBase`:

```java
class V1AlphaFetcherIntegrationTest {
  @ExtendWith(SpringExtension.class)
  @Import({IntegrationTestBase.Config.class, JacksonAutoConfiguration.class})
  @DirtiesContext
  @Nested
  abstract class IntegrationTestBase {
    protected final TestLogger logger = TestLoggerFactory.getTestLogger(V1AlphaFetcher.class);

    @MockBean protected Mdc mdc;

    @Autowired protected ObjectMapper objectMapper;
    @Autowired protected MockWebServer server;

    @Autowired protected V1AlphaFetcher fetcher;

    @TestConfiguration
    static class Config {

      @Bean
      public MockWebServer webServer() {
        return new MockWebServer();
      }

      @Bean
      public WebClient webClient() {
        return WebClient.builder().build();
      }

     // other beans
    }

    @AfterEach
    void tearDown() {
      logger.clear();
    }

    // shared methods
  }

  @Nested
  class Fetch {
    @Nested
    class InGeneral extends IntegrationTestBase {
      // tests
    }
  }
}
```

This allows us to put common things into a central place, making a clear set of common setup, and allowing us to access shared beans using `protected` fields. By leaving state out of the overall test class, we also make it much clearer how the state is being managed.
