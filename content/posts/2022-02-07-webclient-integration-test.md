---
title: "Integration Testing Your Spring `WebClient`s with okhttp's `MockWebServer`"
description: "How to write integration tests using `RestClientTest` with Spring Boot, for use with `RestTemplate` and `RestTemplateBuilder`s."
tags:
- blogumentation
- java
- spring-boot
- testing
- tdd
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-07T10:44:19+0000
slug: webclient-integration-test
syndication:
- "https://brid.gy/publish/twitter"
---
If you're building Spring Boot services which interact with other services, it's likely that you're using the `WebClient` from the WebFlux project to use a more reactive and non-blocking HTTP client.

Although we can unit test these methods nicely, we're still going to want to build an integration test to validate that the HTTP layer works correctly.

A common choice for this is Wiremock or MockServer, and I'd hoped to say that, similar to [integration testing our `RestTemplate`s](/posts/2022/02/01/resttemplate-integration-test/), we'd be able to use Spring Boot's `RestClientTest`, but [there's no plan for Spring Boot to have this functionality](https://github.com/spring-projects/spring-boot/issues/8404).

We can, however, use okhttp3's `MockWebServer` as noted on the issue above, and in [this blog by Mimacom](https://blog.mimacom.com/spring-webclient-testing/), which may be slightly more lightweight than our other options.

# Base setup

Let's say that we have a class, `ProductServiceClient`, which can be described using the following interface:

```java
public interface ProductServiceClient {
  List<Product> retrieveProducts() throws ProductServiceException;
}
```

And which utilises the following POJOs:

```java
public record Product(String id, String name) {}
```

```java
import java.util.List;

public class ProductContainer {
  private List<Product> products;

  public List<Product> getProducts() {
    return products;
  }

  public void setProducts(List<Product> products) {
    this.products = products;
  }
}
```

```java
public class ProductServiceException extends Exception {
  public ProductServiceException(String message) {
    super(message);
  }

  public ProductServiceException(String message, Throwable throwable) {
    super(message, throwable);
  }
}
```

And finally, we have our `ProductServiceClient`:

```java
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Component
public class ProductServiceClient {
  private final WebClient webClient;

  public ProductServiceClient(WebClient webClient) {
    this.webClient = webClient;
  }

  public List<Product> retrieveProducts() throws ProductServiceException {
    ProductContainer response;
    response =
        webClient
            .get()
            .uri("/products")
            .retrieve()
            .onStatus(
                HttpStatus::is4xxClientError,
                error -> Mono.error(new ProductServiceException("Huh, something went wrong")))
            .bodyToMono(ProductContainer.class)
            .block();

    if (response == null) {
      throw new ProductServiceException("No response body was returned from the service");
    }

    return response.getProducts();
  }
}
```

# Setting up `MockWebServer`

Firstly, we need to add both the core okhttp library, and `mockwebserver` to the classpath, i.e. for Gradle:

```groovy
dependencies {
  testImplementation"com.squareup.okhttp3:okhttp:4.9.3"
  testImplementation"com.squareup.okhttp3:mockwebserver:4.9.3"
}
```

Next, we set up the following Spring integration test, so we can make use of the autowired `ObjectMapper` from Spring:

```java
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import me.jvt.hacking.application.Application;
import okhttp3.mockwebserver.MockResponse;
import okhttp3.mockwebserver.MockWebServer;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.web.reactive.function.client.WebClient;

@Import(ProductServiceClientTest.Config.class)
@ExtendWith(SpringExtension.class)
class ProductServiceClientTest {

  @TestConfiguration
  static class Config {
    @Bean
    public MockWebServer webServer() {
      return new MockWebServer();
    }

    @Bean
    public WebClient webClient(MockWebServer webServer) {
      return WebClient.builder().baseUrl(webServer.url("").toString()).build();
    }

    @Bean
    public ProductServiceClient client(WebClient webClient) {
      return new ProductServiceClient(webClient);
    }
  }

  @Autowired private ObjectMapper mapper;
  @Autowired private MockWebServer server;

  @Autowired private ProductServiceClient client;

  @Test
  void returnsProductsWhenSuccessful() throws ProductServiceException {
    server.enqueue(
        new MockResponse()
            .setResponseCode(200)
            .setHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON)
            .setBody(successBody()));

    List<Product> products = client.retrieveProducts();

    assertThat(products)
        .containsExactly(
            new Product("123", "Credit Card"), new Product("456", "Debit Card (Express)"));
  }

  @Test
  void throwsProductServiceExceptionWhenErrorStatus() {
    server.enqueue(new MockResponse().setResponseCode(400));

    assertThatThrownBy(() -> client.retrieveProducts())
        .hasCauseInstanceOf(ProductServiceException.class);
  }

  private String successBody() {
    ProductContainer container = new ProductContainer();
    container.setProducts(
        List.of(new Product("123", "Credit Card"), new Product("456", "Debit Card (Express)")));
    try {
      return mapper.writeValueAsString(container);
    } catch (JsonProcessingException e) {
      throw new IllegalStateException(e);
    }
  }
}
```

If you're happy constructing an `ObjectMapper` another way, you can remove the need for Spring:

```java
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import okhttp3.mockwebserver.MockResponse;
import okhttp3.mockwebserver.MockWebServer;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.client.WebClient;

class ProductServiceClientTest {

  private static final ObjectMapper MAPPER = new ObjectMapper();

  private MockWebServer server;
  private ProductServiceClient client;

  @BeforeEach
  void setup() {
    server = new MockWebServer();
    WebClient webClient = WebClient.builder().baseUrl(server.url("").toString()).build();
    client = new ProductServiceClient(webClient);
  }

  @Test
  void returnsProductsWhenSuccessful() throws ProductServiceException {
    server.enqueue(
        new MockResponse()
            .setResponseCode(200)
            .setHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON)
            .setBody(successBody()));

    List<Product> products = client.retrieveProducts();

    assertThat(products)
        .containsExactly(
            new Product("123", "Credit Card"), new Product("456", "Debit Card (Express)"));
  }

  @Test
  void throwsProductServiceExceptionWhenErrorStatus() {
    server.enqueue(new MockResponse().setResponseCode(400));

    assertThatThrownBy(() -> client.retrieveProducts())
        .hasCauseInstanceOf(ProductServiceException.class);
  }

  private String successBody() {
    ProductContainer container = new ProductContainer();
    container.setProducts(
        List.of(new Product("123", "Credit Card"), new Product("456", "Debit Card (Express)")));
    try {
      return MAPPER.writeValueAsString(container);
    } catch (JsonProcessingException e) {
      throw new IllegalStateException(e);
    }
  }
}
```

# Adding tests for multiple `WebClient` together, with custom configuration

If we want to add tests to validate that the `WebClient`s themselves are set up correctly, independent to the classes that test them, we may want to create a common test class, which can allow us to verify any configuration that has been applied to them.

Let's say that we have the following configuration class for two different `WebClient`s:

```java
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class WebClientConfig {
  @Bean
  public WebClient foo(@Value("1.2.3") String apiKey) {
    return WebClient.builder()
        .defaultRequest(requestHeadersSpec -> requestHeadersSpec.header("api-key", apiKey))
        .build();
  }

  @Bean
  public WebClient bar() {
    return WebClient.builder()
        .defaultRequest(
            requestHeadersSpec -> requestHeadersSpec.accept(MediaType.valueOf("text/plain")))
        .build();
  }
}
```

This allows us to write the following test to verify that the HTTP requests are sent correctly.

**Note** the need for enqueueing a `MockResponse`, as without it the tests will fail.

```java
import static org.assertj.core.api.Assertions.assertThat;

import java.util.concurrent.TimeUnit;
import me.jvt.hacking.application.Application;
import me.jvt.hacking.application.RestTemplateConfig;
import okhttp3.mockwebserver.MockResponse;
import okhttp3.mockwebserver.MockWebServer;
import okhttp3.mockwebserver.RecordedRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.web.reactive.function.client.WebClient;

@ExtendWith(SpringExtension.class)
@Import(RestTemplateConfig.class)
@ContextConfiguration(classes = Application.class)
class RestTemplateIntegrationTest {

  @Autowired
  @Qualifier("foo")
  private WebClient foo;

  @Autowired
  @Qualifier("bar")
  private WebClient bar;

  private final MockWebServer server = new MockWebServer();

  @BeforeEach
  void setup() {
    // required to be set, otherwise `takeRequest` will never return anything
    server.enqueue(new MockResponse());
  }

  @Test
  void fooSetsApiKey() throws InterruptedException {
    foo.get().uri(server.url("/products").toString()).retrieve().toBodilessEntity().block();

    RecordedRequest request = server.takeRequest(1, TimeUnit.SECONDS);
    assertThat(request).isNotNull(); // could also be wrapped in an `Optional`
    assertThat(request.getPath()).isEqualTo("/products");
    assertThat(request.getHeader("Api-Key")).isEqualTo("1.2.3");
  }

  @Test
  void barSetsTextPlainAcceptHeader() throws InterruptedException {
    bar.get().uri(server.url("/products").toString()).retrieve().bodyToMono(String.class).block();

    RecordedRequest request = server.takeRequest(1, TimeUnit.SECONDS);
    assertThat(request).isNotNull(); // could also be wrapped in an `Optional`
    assertThat(request.getPath()).isEqualTo("/products");
    assertThat(request.getHeader("accept")).isEqualTo(MediaType.TEXT_PLAIN_VALUE);
  }
}
```
