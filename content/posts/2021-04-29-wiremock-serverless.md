---
title: "Server-less Wiremock, or Using Wiremock Without an HTTP Server"
description: "How to match Wiremock's stubs without running an HTTP Server."
tags:
- blogumentation
- java
- testing
- wiremock
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-04-29T18:51:00+0100
slug: "wiremock-serverless"
image: https://media.jvt.me/2a42816de8.png
---
I'm a big fan of using [Wiremock](http://wiremock.org/) for stubbing out HTTP services - it can be run as part of your local tests, and it can be deployed as a standalone executable JAR. It runs by having an HTTP server that translates the incoming HTTP requests to the stubbed JSON/Java response, and has bindings that even allow it to run with Node.JS applications.

I've been looking at running Wiremock as part of an AWS Lambda function to cut down costs when not testing, but have found that the overhead of running the HTTP server inside the Lambda to be a bit more than I'd hoped.

However, today, I managed to find a way to solve this.

You can find a sample project available at [<i class="fa fa-gitlab"></i> jamietanna/serverless-wiremock](https://gitlab.com/jamietanna/serverless-wiremock). (I'm also very shamelessly stealing the pun server-less from friend and colleague Lewis)

My first foray into this, while looking through the `WireMockApp` code, was that there's a field for a `StubRequestHandler` which we could fetch using Reflection - which was my first solution.

However, looking a bit closer, I found that we could instantiate the `WireMockApp` ourselves, and get access to the handler ourselves:

```java
import com.github.tomakehurst.wiremock.core.Options;
import com.github.tomakehurst.wiremock.core.WireMockApp;
import com.github.tomakehurst.wiremock.core.WireMockConfiguration;
import com.github.tomakehurst.wiremock.http.StubRequestHandler;
// ...

Options options = WireMockConfiguration.options().usingFilesUnderClasspath("wiremock");
WireMockApp app = new WireMockApp(options, null); // null as there's no container running the HTTP side of things
StubRequestHandler handler = app.buildStubRequestHandler();
```

Now we've got our handler, we want to invoke it for a given HTTP request, just without sending an actual HTTP request.

To do this, there's a `Request` interface that the handler expects, and we can then put the data in as needed - for instance with a Lambda, we'd take the API Gateway proxy event and convert it to the `Request` class.

For brevity I won't show the full implementation, as it can be found in sample repo.

```java
import com.github.tomakehurst.wiremock.http.Request;
import com.github.tomakehurst.wiremock.http.ResponseDefinition;
import com.github.tomakehurst.wiremock.stubbing.ServeEvent;
// ...

Request request = new Request() {
    // fill in with your HTTP data
};
ServeEvent event = handler.handleRequest(request);
ResponseDefinition response  = event.getResponseDefinition();
// then get the matched stub's response, i.e. status code out of `response`
```

This gives us a really nice, lightweight, solution for running Wiremock without the overhead of HTTP!
