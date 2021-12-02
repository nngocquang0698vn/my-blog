---
title: "Packaging Wiremock Stubs into a Standalone JAR"
description: "How to use Gradle to package a standalone JAR for Wiremock, including any stubs needed."
date: 2021-12-02T11:11:31+0000
tags:
- "blogumentation"
- "java"
- "gradle"
- "wiremock"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/2a42816de8.png"
slug: gradle-wiremock-standalone-stubs
---
The [Wiremock](http://wiremock.org) project is pretty great for stubbing out HTTP services, and I've been using it for a few years for both local testing, and distributing stubs to consumers of applications.

Although you can distribute stubs in i.e. a ZIP or a lightweight dependency packaged as a JAR, it can also be useful to package it as a standalone JAR, which could be additionally distributed in a Docker image.

Wiremock has supported [a standalone JAR](http://wiremock.org/docs/running-standalone/) for some time, but until the [v2.32.0 release](https://github.com/wiremock/wiremock/releases/tag/2.32.0) this morning, it wasn't possible to package the stubs into the same JAR as the Wiremock JAR.

Now it's possible to package it all into a single JAR, and allow you to execute the following:

```sh
java -jar /path/to/standalone-jar.jar --load-resources-from-classpath 'wiremock'
```

Note that you **must** put your resources into a directory in the classpath as it's not possible to use the top-level classpath.

So how do I get this working?

Following similar setup to [_Packaging Wiremock Extensions into the Standalone Server Runner_]({{< ref 2021-09-12-gradle-wiremock-extensions-standalone >}}), we can set up our `build.gradle`:

```groovy
plugins {
  id "com.github.johnrengelman.shadow" version "7.0.0"
  id 'java'
}

project.ext {
  wiremockVersion = '2.32.0'
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

This can be seen in [this sample project](https://gitlab.com/jamietanna/wiremock-gradle/-/tree/main/with-stubs).

Then, when we populate the `src/main/resources/wiremock` directory:

```
src/main/resources/wiremock/mappings/stub.json
src/main/resources/wiremock/__file/
```

And that's it!
