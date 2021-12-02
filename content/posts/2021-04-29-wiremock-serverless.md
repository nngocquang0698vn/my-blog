---
title: "Server-less Wiremock, or Using Wiremock Without an HTTP Server"
description: "How to match Wiremock's stubs without running an HTTP Server."
date: "2021-04-29T18:51:00+0100"
tags:
- "blogumentation"
- "java"
- "testing"
- "wiremock"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/2a42816de8.png"
slug: "wiremock-serverless"
---
I'm a big fan of using [Wiremock](http://wiremock.org/) for stubbing out HTTP services - it can be run as part of your local tests, and it can be deployed as a standalone executable JAR. It runs by having an HTTP server that translates the incoming HTTP requests to the stubbed JSON/Java response, and has bindings that even allow it to run with Node.JS applications.

I've been looking at running Wiremock as part of an AWS Lambda function to cut down costs when not testing, but have found that the overhead of running the HTTP server inside the Lambda to be a bit more than I'd hoped.

Update 2021-10-21: This article has been amended as from v2.32.0 there is planned to be first-class support for the `DirectCallHttpServer`, which can be found [documented on the official docs site](http://wiremock.org/docs/running-without-http-server/).

# Prior to v2.32.0

However, today, I managed to find a way to solve this, which has given us the following speed improvements (taken fairly unscientifically on a locally running AWS Lambda):

- 45-60% reduction in invocation time
- ~7-10% better memory footprint
- ~7-10% cold start reduction

You can find a sample project available at [<i class="fa fa-gitlab"></i> jamietanna/serverless-wiremock](https://gitlab.com/jamietanna/serverless-wiremock). (I'm also very shamelessly stealing the pun server-less from friend and colleague Lewis)

My first foray into this, while looking through the `WireMockServer` code, was that there's a field for a `StubRequestHandler` which we could fetch using Reflection - which was my first solution.

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

Note that this is currently an undocumented use of an internal API - [see this issue thread](https://github.com/tomakehurst/wiremock/issues/1476) where we're discussing alternatives to make this a public API.
