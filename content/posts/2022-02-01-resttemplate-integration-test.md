---
title: "Integration Testing Your Spring `RestTemplate`s with `RestClientTest`"
description: "How to write integration tests using `RestClientTest` with Spring Boot, for use with `RestTemplate` and `RestTemplateBuilder`s."
tags:
- blogumentation
- java
- spring-boot
- testing
- tdd
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-01T10:40:38+0000
slug: resttemplate-integration-test
image: /img/vendor/spring-logo.png
---
If you're building Spring Boot services which interact with other services, it's likely that you're using the `RestTemplate` to perform the HTTP calls themselves.

Although we can unit test these methods nicely, we're still going to want to build an integration test to validate that the HTTP layer works correctly.

A common choice for this is Wiremock or MockServer, but you can actually do it all using Spring Boot's `RestClientTest`, which provides the means to [test an auto-configured, and mocked, rest client](https://docs.spring.io/spring-boot/docs/2.6.3/reference/html/features.html#features.testing.spring-boot-applications.autoconfigured-rest-client).

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

# With a `RestTemplateBuilder`

If we're injecting in a `RestTemplateBuilder`, we will have a class looking like:

```java
import java.util.List;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientResponseException;
import org.springframework.web.client.RestTemplate;

@Component
public class ProductServiceClient {
  private final RestTemplate template;

  public ProductServiceClient(RestTemplateBuilder builder) {
    template = builder.build();
  }

  public List<Product> retrieveProducts() throws ProductServiceException {
    ResponseEntity<ProductContainer> response;
    try {
      response = template.getForEntity("/products", ProductContainer.class);
    } catch (RestClientResponseException e) {
      throw new ProductServiceException("Huh, something went wrong", e);
    }

    if (response.getBody() == null) {
      throw new ProductServiceException(
          "No response body was returned from the service, even though it returned HTTP "
              + response.getStatusCodeValue());
    }

    return response.getBody().getProducts();
  }
}
```

To test this, we can take advantage of the `RestClientTest`, and using the `MockRestServiceServer` to set up expectations for the API calls, and we can verify that any transformation is executed correctly:

```java
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withBadRequest;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.client.RestClientTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClientResponseException;

@RestClientTest(ProductServiceClient.class)
class ProductServiceClientTest {

  @Autowired private ObjectMapper mapper;
  @Autowired private MockRestServiceServer server;

  @Autowired private ProductServiceClient client;

  @Test
  void returnsProductsWhenSuccessful() throws ProductServiceException {
    server
        .expect(requestTo("/products"))
        .andRespond(withSuccess(successBody(), MediaType.APPLICATION_JSON));

    List<Product> products = client.retrieveProducts();

    assertThat(products)
        .containsExactly(
            new Product("123", "Credit Card"), new Product("456", "Debit Card (Express)"));
  }

  @Test
  void throwsProductServiceExceptionWhenErrorStatus() {
    server.expect(requestTo("/products")).andRespond(withBadRequest());

    assertThatThrownBy(() -> client.retrieveProducts())
        .isInstanceOf(ProductServiceException.class)
        .hasCauseInstanceOf(RestClientResponseException.class);
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

# With a `RestTemplate`

Alternatively, you may be injecting in a pre-configured `RestTemplate`:

```java
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientResponseException;
import org.springframework.web.client.RestTemplate;

@Component
public class ProductServiceClient {
  private final RestTemplate template;

  public ProductServiceClient(RestTemplate template) {
    this.template = template;
  }

  public List<Product> retrieveProducts() throws ProductServiceException {
    ResponseEntity<ProductContainer> response;
    try {
      response = template.getForEntity("/products", ProductContainer.class);
    } catch (RestClientResponseException e) {
      throw new ProductServiceException("Huh, something went wrong", e);
    }

    if (response.getBody() == null) {
      throw new ProductServiceException(
          "No response body was returned from the service, even though it returned HTTP "
              + response.getStatusCodeValue());
    }

    return response.getBody().getProducts();
  }
}
```

However, if we try and do this, we likely receive the following failure while trying to set up the `ApplicationContext`:

```
Failed to load ApplicationContext
java.lang.IllegalStateException: Failed to load ApplicationContext
	at org.springframework.test.context.cache.DefaultCacheAwareContextLoaderDelegate.loadContext(DefaultCacheAwareContextLoaderDelegate.java:132)
	at org.springframework.test.context.support.DefaultTestContext.getApplicationContext(DefaultTestContext.java:124)
	at org.springframework.test.context.support.DependencyInjectionTestExecutionListener.injectDependencies(DependencyInjectionTestExecutionListener.java:118)
	at org.springframework.test.context.support.DependencyInjectionTestExecutionListener.prepareTestInstance(DependencyInjectionTestExecutionListener.java:83)
	at org.springframework.boot.test.autoconfigure.SpringBootDependencyInjectionTestExecutionListener.prepareTestInstance(SpringBootDependencyInjectionTestExecutionListener.java:43)
	at org.springframework.test.context.TestContextManager.prepareTestInstance(TestContextManager.java:248)
	at org.springframework.test.context.junit.jupiter.SpringExtension.postProcessTestInstance(SpringExtension.java:138)
	at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.lambda$invokeTestInstancePostProcessors$8(ClassBasedTestDescriptor.java:363)
	at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.executeAndMaskThrowable(ClassBasedTestDescriptor.java:368)
	at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.lambda$invokeTestInstancePostProcessors$9(ClassBasedTestDescriptor.java:363)
	at java.base/java.util.stream.ReferencePipeline$3$1.accept(ReferencePipeline.java:197)
	at java.base/java.util.stream.ReferencePipeline$2$1.accept(ReferencePipeline.java:179)
	at java.base/java.util.ArrayList$ArrayListSpliterator.forEachRemaining(ArrayList.java:1625)
	at java.base/java.util.stream.AbstractPipeline.copyInto(AbstractPipeline.java:509)
	at java.base/java.util.stream.AbstractPipeline.wrapAndCopyInto(AbstractPipeline.java:499)
	at java.base/java.util.stream.StreamSpliterators$WrappingSpliterator.forEachRemaining(StreamSpliterators.java:310)
	at java.base/java.util.stream.Streams$ConcatSpliterator.forEachRemaining(Streams.java:735)
	at java.base/java.util.stream.Streams$ConcatSpliterator.forEachRemaining(Streams.java:734)
	at java.base/java.util.stream.ReferencePipeline$Head.forEach(ReferencePipeline.java:762)
	at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.invokeTestInstancePostProcessors(ClassBasedTestDescriptor.java:362)
	at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.lambda$instantiateAndPostProcessTestInstance$6(ClassBasedTestDescriptor.java:283)
	at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
	at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.instantiateAndPostProcessTestInstance(ClassBasedTestDescriptor.java:282)
	at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.lambda$testInstancesProvider$4(ClassBasedTestDescriptor.java:272)
	at java.base/java.util.Optional.orElseGet(Optional.java:364)
	at org.junit.jupiter.engine.descriptor.ClassBasedTestDescriptor.lambda$testInstancesProvider$5(ClassBasedTestDescriptor.java:271)
	at org.junit.jupiter.engine.execution.TestInstancesProvider.getTestInstances(TestInstancesProvider.java:31)
	at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.lambda$prepare$0(TestMethodTestDescriptor.java:102)
	at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
	at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.prepare(TestMethodTestDescriptor.java:101)
	at org.junit.jupiter.engine.descriptor.TestMethodTestDescriptor.prepare(TestMethodTestDescriptor.java:66)
	at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$prepare$2(NodeTestTask.java:123)
	at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
	at org.junit.platform.engine.support.hierarchical.NodeTestTask.prepare(NodeTestTask.java:123)
	at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:90)
	at java.base/java.util.ArrayList.forEach(ArrayList.java:1511)
	at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.invokeAll(SameThreadHierarchicalTestExecutorService.java:41)
	at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:155)
	at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
	at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
	at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
	at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
	at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
	at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
	at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
	at java.base/java.util.ArrayList.forEach(ArrayList.java:1511)
	at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.invokeAll(SameThreadHierarchicalTestExecutorService.java:41)
	at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$6(NodeTestTask.java:155)
	at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
	at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$8(NodeTestTask.java:141)
	at org.junit.platform.engine.support.hierarchical.Node.around(Node.java:137)
	at org.junit.platform.engine.support.hierarchical.NodeTestTask.lambda$executeRecursively$9(NodeTestTask.java:139)
	at org.junit.platform.engine.support.hierarchical.ThrowableCollector.execute(ThrowableCollector.java:73)
	at org.junit.platform.engine.support.hierarchical.NodeTestTask.executeRecursively(NodeTestTask.java:138)
	at org.junit.platform.engine.support.hierarchical.NodeTestTask.execute(NodeTestTask.java:95)
	at org.junit.platform.engine.support.hierarchical.SameThreadHierarchicalTestExecutorService.submit(SameThreadHierarchicalTestExecutorService.java:35)
	at org.junit.platform.engine.support.hierarchical.HierarchicalTestExecutor.execute(HierarchicalTestExecutor.java:57)
	at org.junit.platform.engine.support.hierarchical.HierarchicalTestEngine.execute(HierarchicalTestEngine.java:54)
	at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:108)
	at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:88)
	at org.junit.platform.launcher.core.EngineExecutionOrchestrator.lambda$execute$0(EngineExecutionOrchestrator.java:54)
	at org.junit.platform.launcher.core.EngineExecutionOrchestrator.withInterceptedStreams(EngineExecutionOrchestrator.java:67)
	at org.junit.platform.launcher.core.EngineExecutionOrchestrator.execute(EngineExecutionOrchestrator.java:52)
	at org.junit.platform.launcher.core.DefaultLauncher.execute(DefaultLauncher.java:96)
	at org.junit.platform.launcher.core.DefaultLauncher.execute(DefaultLauncher.java:75)
	at org.gradle.api.internal.tasks.testing.junitplatform.JUnitPlatformTestClassProcessor$CollectAllTestClassesExecutor.processAllTestClasses(JUnitPlatformTestClassProcessor.java:99)
	at org.gradle.api.internal.tasks.testing.junitplatform.JUnitPlatformTestClassProcessor$CollectAllTestClassesExecutor.access$000(JUnitPlatformTestClassProcessor.java:79)
	at org.gradle.api.internal.tasks.testing.junitplatform.JUnitPlatformTestClassProcessor.stop(JUnitPlatformTestClassProcessor.java:75)
	at org.gradle.api.internal.tasks.testing.SuiteTestClassProcessor.stop(SuiteTestClassProcessor.java:61)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:77)
	at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.base/java.lang.reflect.Method.invoke(Method.java:568)
	at org.gradle.internal.dispatch.ReflectionDispatch.dispatch(ReflectionDispatch.java:36)
	at org.gradle.internal.dispatch.ReflectionDispatch.dispatch(ReflectionDispatch.java:24)
	at org.gradle.internal.dispatch.ContextClassLoaderDispatch.dispatch(ContextClassLoaderDispatch.java:33)
	at org.gradle.internal.dispatch.ProxyDispatchAdapter$DispatchingInvocationHandler.invoke(ProxyDispatchAdapter.java:94)
	at jdk.proxy1/jdk.proxy1.$Proxy2.stop(Unknown Source)
	at org.gradle.api.internal.tasks.testing.worker.TestWorker$3.run(TestWorker.java:193)
	at org.gradle.api.internal.tasks.testing.worker.TestWorker.executeAndMaintainThreadName(TestWorker.java:129)
	at org.gradle.api.internal.tasks.testing.worker.TestWorker.execute(TestWorker.java:100)
	at org.gradle.api.internal.tasks.testing.worker.TestWorker.execute(TestWorker.java:60)
	at org.gradle.process.internal.worker.child.ActionExecutionWorker.execute(ActionExecutionWorker.java:56)
	at org.gradle.process.internal.worker.child.SystemApplicationClassLoaderWorker.call(SystemApplicationClassLoaderWorker.java:133)
	at org.gradle.process.internal.worker.child.SystemApplicationClassLoaderWorker.call(SystemApplicationClassLoaderWorker.java:71)
	at worker.org.gradle.process.internal.worker.GradleWorkerMain.run(GradleWorkerMain.java:69)
	at worker.org.gradle.process.internal.worker.GradleWorkerMain.main(GradleWorkerMain.java:74)
Caused by: org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'productServiceClient' defined in file [/home/jamie/workspaces/jvt.me/tmp/spring-boot-controller-tdd/build/classes/java/main/me/jvt/hacking/ProductServiceClient.class]: Unsatisfied dependency expressed through constructor parameter 0; nested exception is org.springframework.beans.factory.NoSuchBeanDefinitionException: No qualifying bean of type 'org.springframework.web.client.RestTemplate' available: expected at least 1 bean which qualifies as autowire candidate. Dependency annotations: {}
	at app//org.springframework.beans.factory.support.ConstructorResolver.createArgumentArray(ConstructorResolver.java:800)
	at app//org.springframework.beans.factory.support.ConstructorResolver.autowireConstructor(ConstructorResolver.java:229)
	at app//org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.autowireConstructor(AbstractAutowireCapableBeanFactory.java:1372)
	at app//org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBeanInstance(AbstractAutowireCapableBeanFactory.java:1222)
	at app//org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:582)
	at app//org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:542)
	at app//org.springframework.beans.factory.support.AbstractBeanFactory.lambda$doGetBean$0(AbstractBeanFactory.java:335)
	at app//org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:234)
	at app//org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:333)
	at app//org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:208)
	at app//org.springframework.beans.factory.support.DefaultListableBeanFactory.preInstantiateSingletons(DefaultListableBeanFactory.java:953)
	at app//org.springframework.context.support.AbstractApplicationContext.finishBeanFactoryInitialization(AbstractApplicationContext.java:918)
	at app//org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:583)
	at app//org.springframework.boot.SpringApplication.refresh(SpringApplication.java:730)
	at app//org.springframework.boot.SpringApplication.refreshContext(SpringApplication.java:412)
	at app//org.springframework.boot.SpringApplication.run(SpringApplication.java:302)
	at app//org.springframework.boot.test.context.SpringBootContextLoader.loadContext(SpringBootContextLoader.java:121)
	at app//org.springframework.test.context.cache.DefaultCacheAwareContextLoaderDelegate.loadContextInternal(DefaultCacheAwareContextLoaderDelegate.java:99)
	at app//org.springframework.test.context.cache.DefaultCacheAwareContextLoaderDelegate.loadContext(DefaultCacheAwareContextLoaderDelegate.java:124)
	... 86 more
Caused by: org.springframework.beans.factory.NoSuchBeanDefinitionException: No qualifying bean of type 'org.springframework.web.client.RestTemplate' available: expected at least 1 bean which qualifies as autowire candidate. Dependency annotations: {}
	at app//org.springframework.beans.factory.support.DefaultListableBeanFactory.raiseNoMatchingBeanFound(DefaultListableBeanFactory.java:1799)
	at app//org.springframework.beans.factory.support.DefaultListableBeanFactory.doResolveDependency(DefaultListableBeanFactory.java:1355)
	at app//org.springframework.beans.factory.support.DefaultListableBeanFactory.resolveDependency(DefaultListableBeanFactory.java:1309)
	at app//org.springframework.beans.factory.support.ConstructorResolver.resolveAutowiredArgument(ConstructorResolver.java:887)
	at app//org.springframework.beans.factory.support.ConstructorResolver.createArgumentArray(ConstructorResolver.java:791)
	... 104 more
```

This is because we instead need to make sure that we wire in a `RestTemplate`, not a `RestTemplateBuilder`, which is the default, meaning we need to make the following change:

```diff
 import static org.assertj.core.api.Assertions.assertThat;
 import static org.assertj.core.api.Assertions.assertThatThrownBy;
 import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
 import static org.springframework.test.web.client.response.MockRestResponseCreators.withBadRequest;
 import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

 import com.fasterxml.jackson.core.JsonProcessingException;
 import com.fasterxml.jackson.databind.ObjectMapper;
 import java.util.List;
 import org.junit.jupiter.api.Test;
 import org.springframework.beans.factory.annotation.Autowired;
+import org.springframework.boot.test.autoconfigure.web.client.AutoConfigureWebClient;
 import org.springframework.boot.test.autoconfigure.web.client.RestClientTest;
 import org.springframework.http.MediaType;
 import org.springframework.test.web.client.MockRestServiceServer;
 import org.springframework.web.client.RestClientResponseException;

 @RestClientTest(ProductServiceClient.class)
+@AutoConfigureWebClient(registerRestTemplate = true)
 class ProductServiceClientTest {

   @Autowired private ObjectMapper mapper;
   @Autowired private MockRestServiceServer server;

   @Autowired private ProductServiceClient client;

   @Test
   void returnsProductsWhenSuccessful() throws ProductServiceException {
     server
         .expect(requestTo("/products"))
         .andRespond(withSuccess(successBody(), MediaType.APPLICATION_JSON));

     List<Product> products = client.retrieveProducts();

     assertThat(products)
         .containsExactly(
             new Product("123", "Credit Card"), new Product("456", "Debit Card (Express)"));
   }

   @Test
   void throwsProductServiceExceptionWhenErrorStatus() {
     server.expect(requestTo("/products")).andRespond(withBadRequest());

     assertThatThrownBy(() -> client.retrieveProducts())
         .isInstanceOf(ProductServiceException.class)
         .hasCauseInstanceOf(RestClientResponseException.class);
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

# Conflicts when using multiple `RestTemplate`s

However, what happens when we've got multiple `RestTemplate`s? For instance, we may want to have a `RestTemplate` that adds an `Api-Key` header to the request, and another which does not.

The best solution for this is to expose multiple `RestTemplate` beans, but this requires we use `@Qualifier` in the constructor such as:

```java
public ProductServiceClient(@Qualifier("productServiceRestTemplate") RestTemplate template) {
  // ...
}
```

However, this unfortunately doesn't work super nicely with the `RestClientTest`, as it can't inject it, as it doesn't [allow specifying the bean name](https://github.com/spring-projects/spring-boot/issues/29614).

One option we've got is to use the `@TestConfiguration` configuration option, which we can use to specify our own bean, removing the autoconfiguration that is performed by `RestClientTest`:

```java
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withBadRequest;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.client.AutoConfigureWebClient;
import org.springframework.boot.test.autoconfigure.web.client.RestClientTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClientResponseException;
import org.springframework.web.client.RestTemplate;

// or this can be bundled into @ContextConfiguration(classes = ProductServiceClientTest.Config.class)
@Import(ProductServiceClientTest.Config.class)
@RestClientTest // NOTE that we do not call out the `ProductServiceClient`!
@AutoConfigureWebClient(registerRestTemplate = true)
class ProductServiceClientTest {

  @TestConfiguration
  static class Config {
    @Bean
    public ProductServiceClient client(RestTemplate restTemplate) {
      return new ProductServiceClient(restTemplate);
    }
  }

  // existing tests
}
```

This then works as before, and gives us a handy means to override the configuration, and doesn't require too much overhead.

But note that this also removes any custom configuration we've got in our bean definition for `productServiceRestTemplate`.

# Adding tests for multiple `RestTemplates` together, with custom configuration

If we want to add tests to validate that the `RestTemplate`s themselves are set up correctly, independent to the classes that test them, we may want to create a common test class, which can allow us to verify any configuration that has been applied to them.

To do this, we can't unfortunately use `RestClientTest`, as it can't autowire multiple `RestTemplate`s, such as the following definition:

```java
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestTemplate;

@Configuration
public class RestTemplateConfig {
  @Bean
  public RestTemplate foo(@Value("1.2.3") String apiKey) {
    return new RestTemplateBuilder()
        .additionalInterceptors(
            (request, body, execution) -> {
              request.getHeaders().set("api-key", apiKey);
              return execution.execute(request, body);
            })
        .build();
  }

  @Bean
  public RestTemplate bar() {
    return new RestTemplateBuilder()
        .additionalInterceptors(
            (request, body, execution) -> {
              request.getHeaders().setAccept(List.of(MediaType.valueOf("text/plain")));
              return execution.execute(request, body);
            })
        .build();
  }
}
```

To add a central test to validate that their configuration is correct, we can create a lightweight Spring test, only for the `RestTemplateConfig`:

```java
import static org.springframework.test.web.client.match.MockRestRequestMatchers.header;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import me.jvt.hacking.application.Application;
import me.jvt.hacking.application.RestTemplateConfig;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.test.web.client.MockServerRestTemplateCustomizer;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestTemplate;

@ExtendWith(SpringExtension.class)
@Import(RestTemplateConfig.class)
@ContextConfiguration(classes = Application.class)
class RestTemplateIntegrationTest {

  @Autowired
  @Qualifier("foo")
  private RestTemplate foo;

  @Autowired
  @Qualifier("bar")
  private RestTemplate bar;

  private MockRestServiceServer serverFoo;
  private MockRestServiceServer serverBar;

  @BeforeEach
  void setup() {
    serverFoo = buildServer(foo);
    serverBar = buildServer(bar);
  }

  @Test
  void fooSetsApiKey() {
    serverFoo
        .expect(requestTo("/products"))
        .andExpect(header("Api-Key", "1.2.3"))
        .andRespond(withSuccess("Foo", MediaType.APPLICATION_JSON));

    foo.getForObject("/products", String.class);

    serverFoo.verify();
  }

  @Test
  void barSetsTextPlainAcceptHeader() {
    serverBar
        .expect(requestTo("/products"))
        .andExpect(header("accept", "text/plain"))
        .andRespond(withSuccess("Bar", MediaType.APPLICATION_JSON));

    bar.getForObject("/products", String.class);

    serverBar.verify();
  }

  private static MockRestServiceServer buildServer(RestTemplate restTemplate) {
    MockServerRestTemplateCustomizer serverRestTemplateCustomizer =
        new MockServerRestTemplateCustomizer();
    serverRestTemplateCustomizer.customize(restTemplate);
    return serverRestTemplateCustomizer.getServer();
  }
}
```
