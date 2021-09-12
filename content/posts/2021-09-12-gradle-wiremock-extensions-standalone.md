---
title: "Packaging Wiremock Extensions into the Standalone Server Runner"
description: "How to use Gradle to package a standalone JAR for Wiremock, including any extensions needed."
date: 2021-09-12T17:58:39+0100
tags:
- "blogumentation"
- "java"
- "gradle"
- "wiremock"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/2a42816de8.png"
slug: "gradle-wiremock-extensions-standalone"
---
The [Wiremock](http://wiremock.org) project is pretty great for stubbing out HTTP services. It has a powerful [Extensions API](http://wiremock.org/docs/extending-wiremock/) which allows writing custom code to perform additional transformation of the responses that are sent to a caller.

These extensions can be packaged and released as their own artefacts for others to use, and consumed as part of the build.

If you're deploying Wiremock to i.e. an AWS EC2 or into a container, you may want to package a standalone JAR for Wiremock which contains all the dependencies it could need, including extensions.

This makes sure you don't have to collect classpaths on the receiving end, and can instead be sure that your packaged JAR has everything it'll need to operate, allowing us to run the following to execute it with the extension(s) we want to add:

```sh
java -jar with-extension/build/libs/with-extension.jar --extensions me.jvt.hacking.wiremock.extensions.HelloWorldHeaderExtension
```

This is produced using the following `build.gradle`:

```groovy
plugins {
  id "com.github.johnrengelman.shadow" version "7.0.0"
  id 'java'
}

project.ext {
  wiremockVersion = '2.31.0'
}

dependencies {
  runtimeOnly "com.github.tomakehurst:wiremock-jre8-standalone:$wiremockVersion"
  implementation "com.github.tomakehurst:wiremock-jre8:$wiremockVersion"
}

shadowJar {
  mergeServiceFiles() // https://www.shiveenp.com/posts/fix-shadow-jar-http4k-jetty/
  archiveClassifier.set '' // as this defaults to a separate artifact, called `-all`
}

jar {
  manifest {
    attributes 'Main-Class': 'com.github.tomakehurst.wiremock.standalone.WireMockServerRunner'
  }
}

assemble.dependsOn 'shadowJar'
```

This can be seen in [this sample project](https://gitlab.com/jamietanna/wiremock-gradle/-/tree/main/with-extension), including the definition for the custom `HelloWorldHeaderExtension`.

Note that if we don't have the `mergeServiceFiles`, we then receive the following exception:

```
Exception in thread "main" java.lang.ExceptionInInitializerError
        at org.eclipse.jetty.http.MimeTypes$Type.<init>(MimeTypes.java:98)
        at org.eclipse.jetty.http.MimeTypes$Type.<clinit>(MimeTypes.java:56)
        at org.eclipse.jetty.http.MimeTypes.<clinit>(MimeTypes.java:175)
        at com.github.tomakehurst.wiremock.jetty9.JettyHttpServer.addMockServiceContext(JettyHttpServer.java:400)
        at com.github.tomakehurst.wiremock.jetty9.JettyHttpServer.createHandler(JettyHttpServer.java:118)
        at com.github.tomakehurst.wiremock.jetty94.Jetty94HttpServer.createHandler(Jetty94HttpServer.java:115)
        at com.github.tomakehurst.wiremock.jetty9.JettyHttpServer.<init>(JettyHttpServer.java:105)
        at com.github.tomakehurst.wiremock.jetty94.Jetty94HttpServer.<init>(Jetty94HttpServer.java:42)
        at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)
        at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:62)
        at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45)
        at java.lang.reflect.Constructor.newInstance(Constructor.java:423)
        at com.github.tomakehurst.wiremock.jetty9.JettyHttpServerFactory.buildHttpServer(JettyHttpServerFactory.java:63)
        at com.github.tomakehurst.wiremock.WireMockServer.<init>(WireMockServer.java:75)
        at com.github.tomakehurst.wiremock.standalone.WireMockServerRunner.run(WireMockServerRunner.java:65)
        at com.github.tomakehurst.wiremock.standalone.WireMockServerRunner.main(WireMockServerRunner.java:134)
Caused by: java.lang.ArrayIndexOutOfBoundsException: 1
        at org.eclipse.jetty.http.PreEncodedHttpField.<clinit>(PreEncodedHttpField.java:68)
        ... 16 more
```
