---
title: "Executing `javax.servlet.Filter`s in aws-serverless-java-container Jersey Apps"
description: "How to add a `javax.servlet.Filter` to a Jersey application, built using the AWS Serverless Container for Java."
tags:
- java
- jersey
- blogumentation
- aws
- serverless
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-01-25T22:10:14+0000
slug: "servlet-filter-jersey-aws-serverless"
---
I work with a few Jersey web applications that are built on top of the [aws-serverless-java-container](https://github.com/awslabs/aws-serverless-java-container).

We have a lot of shared libraries that solve things in a central way, and for a lot of our Java web services, these are built with `java.servlet.Filter`s. To allow us to continue using these across multiple types of web services, we wanted to be able to integrate the `Filter`s in, but couldn't quite work out how using [Stefano Buliani's comment on this GitHub thread](https://github.com/awslabs/aws-serverless-java-container/issues/209#issuecomment-437987336).

In the interest of [Blogumentation]({{< ref 2017-06-25-blogumentation >}}), I've created [<i class="fa fa-gitlab"></i> jamietanna/jersey-servlet-filter-example](https://gitlab.com/jamietanna/jersey-servlet-filter-example) to show how to do this.

We can do this by replacing the existing logic in [StreamLambdaHandler](https://github.com/awslabs/aws-serverless-java-container/blob/aws-serverless-java-container-1.5.2/samples/jersey/pet-store/src/main/java/com/amazonaws/serverless/sample/jersey/StreamLambdaHandler.java) and, as per Stefano's comment, we can construct the `JerseyLambdaContainerHandler` ourselves, and register our `Filter` for the URLs it needs to handle.

```java
import com.amazonaws.serverless.proxy.AwsProxyExceptionHandler;
import com.amazonaws.serverless.proxy.AwsProxySecurityContextWriter;
import com.amazonaws.serverless.proxy.internal.servlet.AwsProxyHttpServletRequestReader;
import com.amazonaws.serverless.proxy.internal.servlet.AwsProxyHttpServletResponseWriter;
import com.amazonaws.serverless.proxy.internal.testutils.Timer;
import com.amazonaws.serverless.proxy.jersey.JerseyLambdaContainerHandler;
import com.amazonaws.serverless.proxy.model.AwsProxyRequest;
import com.amazonaws.serverless.proxy.model.AwsProxyResponse;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;

import org.glassfish.jersey.jackson.JacksonFeature;
import org.glassfish.jersey.server.ResourceConfig;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.EnumSet;
import javax.servlet.DispatcherType;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.FilterRegistration;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

public class StreamLambdaHandler implements RequestStreamHandler {
    private static final ResourceConfig jerseyApplication = new ResourceConfig()
                                                             .packages("com.amazonaws.serverless.sample.jersey")
                                                             .register(JacksonFeature.class);
    private static final JerseyLambdaContainerHandler<AwsProxyRequest, AwsProxyResponse> handler
            = getAwsProxyHandler(); // required to simplify setup

    private static JerseyLambdaContainerHandler<AwsProxyRequest, AwsProxyResponse> getAwsProxyHandler() {
        // allow us to inject Filter(s) before we `initialize`
        JerseyLambdaContainerHandler<AwsProxyRequest, AwsProxyResponse> newHandler = new JerseyLambdaContainerHandler(
                AwsProxyRequest.class, AwsProxyResponse.class,
                new AwsProxyHttpServletRequestReader(),
                new AwsProxyHttpServletResponseWriter(), new AwsProxySecurityContextWriter(),
                new AwsProxyExceptionHandler(), jerseyApplication);
        // register all the filters we need
        addFilter(newHandler, new ExampleFilter(), "FilterName");
        // finalise setup
        newHandler.initialize();
        return newHandler;
    }

    private static void addFilter(JerseyLambdaContainerHandler<?, ?> handler, String filterName, Filter filterToAdd) {
        FilterRegistration.Dynamic registered = handler.getServletContext().addFilter(filterName, filterToAdd);
        registered.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST), true, "/*"); // you could do something different here
    }

    // ...
}
```
