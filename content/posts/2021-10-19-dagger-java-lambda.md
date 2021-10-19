---
title: "Lightweight and Powerful Dependency Injection for JVM-based Applications with Dagger"
description: "How and why you should be using Dagger for your dependency injection."
date: 2021-10-19T09:35:14+0100
tags:
- "blogumentation"
- "java"
- "aws-lambda"
- "dagger"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "dagger-java-lambda"
---
I'm a big fan of writing RESTful API services in Spring Boot, and using Spring's Dependency Injection framework. However, there are cases where it doesn't make sense, like on AWS Lambda, or for running Cucumber Acceptance Tests (unless you're already in a Spring-heavy team).

Fortunately, one big contender for the Dependency Injection side is [Dagger](https://dagger.dev/) - or specifically, Dagger2 - which is described as:

> Dagger is a fully static, compile-time dependency injection framework for Java, Kotlin, and Android.

As it runs compile-time, it provides a super speedy feedback loop, not requiring you execute expensive integration tests to validate if everything is hooked up correctly.

I've recently migrated a few Lambdas to it, and found it's a really nice experience.

# Example Application

Let's take the example of an AWS Lambda, which has a service layer for business logic, and then delegates out to an external API, which is a pretty common pattern.

The below example code is adapted from the [aws-lambda-developer-guide's blank-java project](https://github.com/awsdocs/aws-lambda-developer-guide/tree/a5a7ebb44681168bb9ed6b03f16571ec4443aa7d/sample-apps/java-basic).

Let's say we have the following handler class for our Lambda:

```java
package me.jvt.hacking;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import me.jvt.hacking.service.ServiceLayer;

import java.util.Collections;
import java.util.Map;

public class Handler
    implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

  private final ServiceLayer service;

  public Handler() {
    // TODO: need to initialise the `service`, once we have DI
  }

  /* test only */ Handler(ServiceLayer service) {
    this.service = service;
  }

  @Override
  public APIGatewayProxyResponseEvent handleRequest(
      APIGatewayProxyRequestEvent event, Context context) {
    if (!service.validateRequest(event)) {
      return badRequest();
    }
    String apiResponse = service.retrieveData(event.getQueryStringParameters().get("productId"));
    return success(apiResponse);
  }

  private static APIGatewayProxyResponseEvent badRequest() {
    return new APIGatewayProxyResponseEvent().withStatusCode(400);
  }

  private static APIGatewayProxyResponseEvent success(String apiResponse) {
    return new APIGatewayProxyResponseEvent()
        .withStatusCode(200)
        .withBody(apiResponse)
        .withHeaders(Collections.singletonMap("content-type", "text/plain"));
  }
}
```

This uses the service layer:

```java
package me.jvt.hacking.service;

import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import me.jvt.hacking.client.ProductApiClient;

import java.util.TreeMap;

public class ServiceLayer {
  private final boolean requireAuthentication;
  private final ProductApiClient productApiClient;

  public ServiceLayer(boolean requireAuthentication, ProductApiClient productApiClient) {
    this.requireAuthentication = requireAuthentication;
    this.productApiClient = productApiClient;
  }

  public boolean validateRequest(APIGatewayProxyRequestEvent event) {
    TreeMap<String, String> headers = new TreeMap<>(String.CASE_INSENSITIVE_ORDER);
    headers.putAll(event.getHeaders());
    if (requireAuthentication) {
      // this is **NOT** a secure example, it is purely to show something that may be configurable for i.e. local testing
      return headers.containsKey("authorization");
    }

    if (event.getQueryStringParameters().isEmpty() || !event.getQueryStringParameters().containsKey("productId")) {
      return false;
    }

    return true;
  }

  public String retrieveData(String productId) {
    return this.productApiClient.retrieveProductInformation(productId);
  }
}
```

And the service layer calls out to the following stubbed API client:

```java
package me.jvt.hacking.client;

public class ProductApiClient {
  private final String apiBaseUrl;

  public ProductApiClient(String apiBaseUrl) {
    this.apiBaseUrl = apiBaseUrl;
  }

  public String retrieveProductInformation(String productId) {
    return String.format(
        "Example response from calling out to %s/products/%s", apiBaseUrl, productId);
  }
}
```

This is all packaged into a Gradle project:

```groovy
plugins {
    id 'java'
}

repositories {
    mavenCentral()
}

dependencies {
    implementation platform('software.amazon.awssdk:bom:2.10.73')
    implementation platform('com.amazonaws:aws-xray-recorder-sdk-bom:2.4.0')
    implementation 'software.amazon.awssdk:lambda'
    implementation 'com.amazonaws:aws-xray-recorder-sdk-core'
    implementation 'com.amazonaws:aws-xray-recorder-sdk-aws-sdk-core'
    implementation 'com.amazonaws:aws-xray-recorder-sdk-aws-sdk-v2'
    implementation 'com.amazonaws:aws-xray-recorder-sdk-aws-sdk-v2-instrumentor'
    implementation 'com.amazonaws:aws-lambda-java-core:1.2.1'
    implementation 'com.amazonaws:aws-lambda-java-events:2.2.9'
    implementation 'com.google.code.gson:gson:2.8.6'
    implementation 'org.apache.logging.log4j:log4j-api:2.13.0'
    implementation 'org.apache.logging.log4j:log4j-core:2.13.0'
    runtimeOnly 'org.apache.logging.log4j:log4j-slf4j18-impl:2.13.0'
    runtimeOnly 'com.amazonaws:aws-lambda-java-log4j2:1.2.0'
    testImplementation 'org.junit.jupiter:junit-jupiter-api:5.6.0'
    testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.6.0'
}

test {
    useJUnitPlatform()
}

task packageFat(type: Zip) {
    from compileJava
    from processResources
    into('lib') {
        from configurations.runtimeClasspath
    }
    dirMode = 0755
    fileMode = 0755
}

task packageLibs(type: Zip) {
    into('java/lib') {
        from configurations.runtimeClasspath
    }
    dirMode = 0755
    fileMode = 0755
}

task packageSkinny(type: Zip) {
    from compileJava
    from processResources
}

java {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
}

build.dependsOn packageSkinny
```

# Custom "Dependency Injection"

One option you can follow is to not _really_ do dependency injection, but have at least a central class that managed dependencies, and provides `static` methods to retrieve the instances you need.

```java
package me.jvt.hacking;

import me.jvt.hacking.client.ProductApiClient;
import me.jvt.hacking.service.ServiceLayer;

public class Config {
  private Config() {
    throw new UnsupportedOperationException("Utility class");
  }

  public static ServiceLayer serviceLayer() {
    return new ServiceLayer(
        booleanEnvironmentVariable("REQUIRE_AUTHENTICATION", true), productApiClient());
  }

  public static ProductApiClient productApiClient() {
    return new ProductApiClient(System.getenv("PRODUCT_API_BASEURL"));
  }

  private static boolean booleanEnvironmentVariable(String name, boolean defaultValue) {
    if (!System.getenv().containsKey(name)) {
      return defaultValue;
    }
    return Boolean.parseBoolean(System.getenv(name));
  }
}
```

This can be enhanced by using the [singleton pattern](https://refactoring.guru/design-patterns/singleton) to make sure we're not creating unnecessary instances of classes, but otherwise it does the job.

This can then be hooked into our `Handler`'s zero-args constructor and allows us to run the Lambda application:

```diff
 package me.jvt.hacking;

 import com.amazonaws.services.lambda.runtime.Context;
 import com.amazonaws.services.lambda.runtime.RequestHandler;
 import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
 import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
 import me.jvt.hacking.service.ServiceLayer;

 import java.util.Collections;
 import java.util.Map;

 public class Handler
     implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

   private final ServiceLayer service;

   public Handler() {
-    // TODO: need to initialise the `service`
+    this(Config.serviceLayer());
   }

   // ...
 }
```

# Dagger Dependency Injection

Now, to convert to Dagger, we need to do a few things.

The first one is that we need to make sure we add Dagger to our dependency tree, and make sure that Gradle processes the compiler dependency under its `annotationProcessor` configuration:

```diff
 dependencies {
+    annotationProcessor 'com.google.dagger:dagger-compiler:2.39.1'
     implementation platform('software.amazon.awssdk:bom:2.10.73')
     implementation platform('com.amazonaws:aws-xray-recorder-sdk-bom:2.4.0')
+    implementation 'com.google.dagger:dagger:2.39.1'
     implementation 'software.amazon.awssdk:lambda'
```

Next, Dagger needs to know what dependencies it needs to build + resolve. To do this, we create an `@Component` that lists all dependencies required. To keep with the naming we've got, we'll refactor our `Config` class into the below.

```java
package me.jvt.hacking;

import dagger.Component;
import me.jvt.hacking.client.ProductApiClient;
import me.jvt.hacking.service.ServiceLayer;

import javax.inject.Singleton;


@Singleton
@Component(modules = {ConfigModule.class})
public interface Config {
    ProductApiClient productApiClient();
    ServiceLayer serviceLayer();
}
```

Dagger needs to know where the definitions are for these dependencies, so we need to now set up our modules which define the definitions for providing them.

Although this application is small, you can likely see that we'd want to split out into many modules based on slices of functionality.

We can replace our old `Config` class from before we were on Dagger into the `ConfigModule`:

```java
package me.jvt.hacking;

import dagger.Module;
import dagger.Provides;
import me.jvt.hacking.client.ProductApiClient;
import me.jvt.hacking.service.ServiceLayer;

import javax.inject.Singleton;

@Module
public class ConfigModule {
  private ConfigModule() {
    throw new UnsupportedOperationException("Utility class");
  }

  @Provides
  @Singleton
  public static ServiceLayer serviceLayer(ProductApiClient productApiClient) {
    return new ServiceLayer(
        booleanEnvironmentVariable("REQUIRE_AUTHENTICATION", true), productApiClient);
  }

  @Provides
  @Singleton
  public static ProductApiClient productApiClient() {
    return new ProductApiClient(System.getenv("PRODUCT_API_BASEURL"));
  }

  private static boolean booleanEnvironmentVariable(String name, boolean defaultValue) {
    if (!System.getenv().containsKey(name)) {
      return defaultValue;
    }
    return Boolean.parseBoolean(System.getenv(name));
  }
}
```

You'll notice that at this point, we've added the `@Singleton` definitions - you can always add them as a follow-up to adding Dagger, once you've discovered where they need to be singletons.

When this successfully compiles, it allows us to call out to the `DaggerConfig` class, which is the compiled class with the correct dependencies created:

```diff
 package me.jvt.hacking;

 import com.amazonaws.services.lambda.runtime.Context;
 import com.amazonaws.services.lambda.runtime.RequestHandler;
 import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
 import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
 import me.jvt.hacking.service.ServiceLayer;

 import java.util.Collections;
 import java.util.Map;

 public class Handler
     implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

   private final ServiceLayer service;

   public Handler() {
-    this(Config.serviceLayer());
+    this(DaggerConfig.create().serviceLayer());
   }

   // ...
 }
```

## Improved Handling of Configuration

Although this application is quite small, we can start to see that if our modules each deal with environment variables, or retrieving configuration from files on the classpath, the modules start to get quite complex and more difficult to read.

This also isn't full dependency injection, because the definitions for creating dependencies aren't having their own dependencies injected.

We can do this by extracting this into the setup for the `Config` class itself by adding an `instance()` method (naming isn't important):

```java
package me.jvt.hacking;

import dagger.BindsInstance;
import dagger.Component;
import me.jvt.hacking.client.ProductApiClient;
import me.jvt.hacking.service.ServiceLayer;

import javax.inject.Named;
import javax.inject.Singleton;

@Singleton
@Component(modules = {ConfigModule.class})
public interface Config {
  ProductApiClient productApiClient();

  ServiceLayer serviceLayer();

  @Component.Builder
  interface Builder {
    @BindsInstance
    Builder productApiBaseUrl(@Named("productApiBaseUrl") String productApiBaseUrl);

    @BindsInstance
    Builder requireAuthentication(@Named("requireAuthentication") boolean requireAuthentication);

    Config build();
  }

  static Config instance() {
    // note that we could even read i.e. `APP_PROFILE` and then load a file from the classpath for other configuration
    return DaggerConfig.builder()
        .productApiBaseUrl(System.getenv("PRODUCT_API_BASEURL"))
        .requireAuthentication(booleanEnvironmentVariable("REQUIRE_AUTHENTICATION", true))
        .build();
  }

  static boolean booleanEnvironmentVariable(String name, boolean defaultValue) {
    if (!System.getenv().containsKey(name)) {
      return defaultValue;
    }
    return Boolean.parseBoolean(System.getenv(name));
  }
}
```

Which then allows our module to be much more lightweight, now focussing purely on what's injected:

```java
package me.jvt.hacking;

import dagger.Module;
import dagger.Provides;
import me.jvt.hacking.client.ProductApiClient;
import me.jvt.hacking.service.ServiceLayer;

import javax.inject.Named;
import javax.inject.Singleton;

@Module
public class ConfigModule {
  private ConfigModule() {
    throw new UnsupportedOperationException("Utility class");
  }

  @Provides
  @Singleton
  public static ServiceLayer serviceLayer(
      ProductApiClient productApiClient,
      @Named("requireAuthentication") boolean requireAuthentication) {
    return new ServiceLayer(requireAuthentication, productApiClient);
  }

  @Provides
  @Singleton
  public static ProductApiClient productApiClient(
      @Named("productApiBaseUrl") String productApiBaseUrl) {
    return new ProductApiClient(productApiBaseUrl);
  }
}
```

Finally, we can update our zero-args constructor in `Handler` to use this new method:

```diff
 package me.jvt.hacking;

 import com.amazonaws.services.lambda.runtime.Context;
 import com.amazonaws.services.lambda.runtime.RequestHandler;
 import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
 import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
 import me.jvt.hacking.service.ServiceLayer;

 import java.util.Collections;
 import java.util.Map;

 public class Handler
     implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

   private final ServiceLayer service;

   public Handler() {
-    this(DaggerConfig.create().serviceLayer());
+    this(Config.instance().serviceLayer());
   }

   // ...
 }
```

This then allows us a much nicer means to configure new dependencies, hooking them in via an environment/configuration aware `instance()` method, and allowing us to take advantage of i.e. `javax.inject.Inject` where we want it.
