---
title: "Integration Testing Your Spring `WebClient`s with Wiremock"
description: "How to write integration tests using Wiremock, for use with `WebClient`s."
date: "2022-03-22T10:38:47+0000"
syndication:
- "https://twitter.com/JamieTanna/status/1506220842514010112"
tags:
- "blogumentation"
- "java"
- "spring-boot"
- "testing"
- "tdd"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/3e88e3081a.png"
slug: "webclient-integration-test-wiremock"
---
If you're building Spring Boot services which interact with other services, it's likely that you're using the `WebClient` from the WebFlux project to use a more reactive and non-blocking HTTP client.

Although we can unit test these methods nicely, we're still going to want to build an integration test to validate that the HTTP layer works correctly.

As noted in [the version of this article, using OkHttp](https://www.jvt.me/posts/2022/02/07/webclient-integration-test/), we can't use a built-in Spring means to test this, but we can use an HTTP server like [Wiremock](https://wiremock.org/).

Sample code for this blog post can be found [on GitLab](https://gitlab.com/jamietanna/spring-boot-http-client-integration-testing).

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

# Setting up Wiremock

Firstly, we need to add Wiremock to the classpath, i.e. for Gradle:

```groovy
dependencies {
  testImplementation 'com.github.tomakehurst:wiremock-jre8:2.32.0'
}
```

Next, we set up the following Spring integration test, so we can make use of the autowired `ObjectMapper` from Spring:

```java
import static com.github.tomakehurst.wiremock.client.WireMock.*;
import static com.github.tomakehurst.wiremock.core.WireMockConfiguration.options;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.tomakehurst.wiremock.WireMockServer;
import java.util.List;
import me.jvt.hacking.webclient.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.web.reactive.function.client.WebClient;

@Import({ProductServiceClientTest.Config.class, JacksonAutoConfiguration.class})
@ExtendWith(SpringExtension.class)
class ProductServiceClientTest {

  @TestConfiguration
  static class Config {
    @Bean
    public WireMockServer webServer() {
      WireMockServer wireMockServer = new WireMockServer(options().dynamicPort());
      // required so we can use `baseUrl()` in the construction of `webClient` below
      wireMockServer.start();
      return wireMockServer;
    }

    @Bean
    public WebClient webClient(WireMockServer server) {
      return WebClient.builder().baseUrl(server.baseUrl()).build();
    }

    @Bean
    public ProductServiceClient client(WebClient webClient) {
      return new ProductServiceClient(webClient);
    }
  }

  @Autowired private ObjectMapper mapper;
  @Autowired private WireMockServer server;

  @Autowired private ProductServiceClient client;

  @Test
  void returnsProductsWhenSuccessful() throws ProductServiceException {
    server.stubFor(
        get(urlEqualTo("/products"))
            .willReturn(
                aResponse()
                    .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                    .withBody(successBody())));

    List<Product> products = client.retrieveProducts();

    assertThat(products)
        .containsExactly(
            new Product("123", "Credit Card"), new Product("456", "Debit Card (Express)"));
  }

  @Test
  void throwsProductServiceExceptionWhenErrorStatus() {
    server.stubFor(get(anyUrl()).willReturn(aResponse().withStatus(400)));

    assertThatThrownBy(() -> client.retrieveProducts())
        .hasCauseInstanceOf(ProductServiceException.class);
  }

  @Test
  void setsAcceptHeader() throws ProductServiceException {
    server.stubFor(
        get(urlEqualTo("/products"))
            .willReturn(
                aResponse()
                    .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                    .withBody(successBody())));

    client.retrieveProducts();

    server.verify(
        getRequestedFor(urlEqualTo("/products")).withHeader("accept", equalTo("application/json")));
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

If you're happy constructing an `ObjectMapper` another way, I'll leave it as an exercise to the reader, [based on how we did it for OkHttp's tests](https://www.jvt.me/posts/2022/02/07/webclient-integration-test/#setting-up-mockwebserver).

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

```java
import static com.github.tomakehurst.wiremock.client.WireMock.*;
import static com.github.tomakehurst.wiremock.core.WireMockConfiguration.options;

import com.github.tomakehurst.wiremock.WireMockServer;
import me.jvt.hacking.webclient.Application;
import me.jvt.hacking.webclient.WebClientConfig;
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
@Import(WebClientConfig.class)
@ContextConfiguration(classes = Application.class)
class WebClientIntegrationTest {

  @Autowired
  @Qualifier("foo")
  private WebClient foo;

  @Autowired
  @Qualifier("bar")
  private WebClient bar;

  private final WireMockServer server = new WireMockServer(options().dynamicPort());

  @BeforeEach
  void setup() {
    server.start();
    server.stubFor(get(anyUrl()).willReturn(aResponse().withStatus(200)));
  }

  @Test
  void fooSetsApiKey() throws InterruptedException {
    foo.get().uri(server.url("/products")).retrieve().toBodilessEntity().block();

    server.verify(getRequestedFor(urlEqualTo("/products")).withHeader("Api-Key", equalTo("1.2.3")));
  }

  @Test
  void barSetsTextPlainAcceptHeader() throws InterruptedException {
    bar.get().uri(server.url("/products")).retrieve().bodyToMono(String.class).block();

    server.verify(
        getRequestedFor(urlEqualTo("/products"))
            .withHeader("accept", equalTo(MediaType.TEXT_PLAIN_VALUE)));
  }
}
```
