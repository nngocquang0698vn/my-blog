---
title: "Adding a Wiretap to a Spring WebFlux `WebClient` to Log All Request/Response Data"
Description: "How to log all request/response data from a Spring Webflux `WebClient`."
tags:
- blogumentation
- java
- spring-boot
- spring
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-13T10:01:17+0000
slug: "log-webflux-client"
syndication:
- "https://brid.gy/publish/twitter"
---
If you're working with Spring Boot Webflux, you'll likely be using the `WebClient` as your HTTP client.

There may be cases that you need to add debug logging to investigate requests over the wire, for instance to debug things locally.

We can do this by taking a configuration for our `WebClient`:

```java
import io.netty.handler.logging.LogLevel;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;
import reactor.netty.transport.logging.AdvancedByteBufFormat;

@Configuration
public class WebClientConfiguration {

  @Bean
  public WebClient webClient(
      WebClient.Builder webClientBuilder,
      @Value("https://path/to/api") String apiBaseUrl,
      ) {
    return webClientBuilder
        .baseUrl(apiBaseUrl)
        .build();
  }
}
```

Then, to turn on our debug logging, we can provide an `HttpClient` that has been `wiretap`'d:

```java
import io.netty.handler.logging.LogLevel;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;
import reactor.netty.transport.logging.AdvancedByteBufFormat;

@Configuration
public class WebClientConfiguration {

  @Bean
  public WebClient webClient(
      WebClient.Builder webClientBuilder,
      @Value("https://path/to/api") String apiBaseUrl,
      ) {
    HttpClient httpClient =
        HttpClient.create()
            .wiretap(
                this.getClass().getCanonicalName(), LogLevel.DEBUG, AdvancedByteBufFormat.TEXTUAL);

    return webClientBuilder
        .clientConnector(new ReactorClientHttpConnector(httpClient))
        .baseUrl(apiBaseUrl)
        .build();
  }
}
```

The wiretap takes note of logging interfaces on the classpath, and for instance will use SLF4J if it finds it available, so logs will go to the location and format you want them in.

You may want to [turn this on depending on whether we're running in debug mode](/posts/2022/02/13/spring-debug-mode/), for instance:

```java
import io.netty.handler.logging.LogLevel;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;
import reactor.netty.transport.logging.AdvancedByteBufFormat;

@Configuration
public class WebClientConfiguration {

  @Bean
  public boolean isDebug(
      @Value("#{environment.getProperty('debug') != null && environment.getProperty('debug') != 'false'}")
          boolean isDebug) {
    return isDebug;
  }

  @Bean
  @ConditionalOnExpression("#{isDebug == true}")
  public ReactorClientHttpConnector wiretappedConnector(boolean isDebug) {
    HttpClient httpClient =
        HttpClient.create()
            .wiretap(
                this.getClass().getCanonicalName(), LogLevel.DEBUG, AdvancedByteBufFormat.TEXTUAL);
    return new ReactorClientHttpConnector(httpClient);
  }

  @Bean
  public WebClient webClient(
      WebClient.Builder webClientBuilder,
      @Value("https://path/to/api") String apiBaseUrl,
      ReactorClientHttpConnector reactorClientHttpConnector) {
    return webClientBuilder.clientConnector(reactorClientHttpConnector).baseUrl(apiBaseUrl).build();
  }
}
```
