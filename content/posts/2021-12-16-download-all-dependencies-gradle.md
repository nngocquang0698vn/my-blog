---
title: "Retrieving All Dependencies Required by a JAR at Runtime"
description: "How to handily retrieve the full runtime classpath required for a JAR file, using Gradle."
tags:
- blogumentation
- gradle
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-16T15:14:10+0000
slug: download-all-dependencies-gradle
image: https://media.jvt.me/c25b297eaa.png
---
Let's say that you have a project like [browserup-proxy](https://github.com/browserup/browserup-proxy) that has a handy startup script that requires you provide the full Java classpath to execute it, which you want to distribute inside a Git repo, or a Docker image.

Although there are online tools which may be able to do this for us, we should also [strive to have something locally](/posts/2020/09/01/against-online-tooling/) without relying on (potentially unsafe) online tools.

Fortunately, we can use Gradle's inbuilt dependency management for this. By setting up a Gradle project with the following `build.gradle:`

```groovy
plugins {
  id 'java'
}

ext {
  browserUpVersion = '2.0.1'
}

dependencies {
  implementation "com.browserup:browserup-proxy-core:$browserUpVersion"
  implementation "com.browserup:browserup-proxy-mitm:$browserUpVersion"
  implementation "com.browserup:browserup-proxy-rest:$browserUpVersion"
}

task buildZip(type: Zip) {
  from configurations.runtimeClasspath
}

repositories {
  mavenCentral()
}
```

Now, when we run `./gradlew clean buildZip`, it will produce a ZIP file with all the JARs required to execute correctly:

```
Archive:  build/distributions/gradle-jars.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
    60059  2021-12-16 14:30   browserup-proxy-rest-2.0.1.jar
   202106  2021-12-16 14:30   browserup-proxy-core-2.0.1.jar
   212489  2021-12-16 14:30   browserup-proxy-mitm-2.0.1.jar
    80673  2021-12-16 14:30   swagger-jaxrs2-2.0.9.jar
    30501  2021-12-16 14:30   swagger-integration-2.0.9.jar
   162978  2021-12-16 14:30   swagger-core-2.0.9.jar
   128076  2021-12-16 14:01   jaxb-api-2.3.1.jar
   273273  2021-12-16 14:30   sitebricks-0.8.11.jar
    75204  2021-12-16 14:30   jersey-media-json-jackson-2.29.jar
    27403  2021-12-16 14:30   sitebricks-client-0.8.11.jar
    49925  2021-12-16 14:30   sitebricks-converter-0.8.11.jar
    15861  2021-12-16 14:30   jackson-jaxrs-json-provider-2.9.9.jar
    32627  2021-12-16 14:30   jackson-module-jaxb-annotations-2.9.9.jar
   100674  2021-12-16 14:30   jackson-datatype-jsr310-2.9.9.jar
    32373  2021-12-16 14:30   jackson-jaxrs-base-2.9.9.jar
  1348229  2021-12-16 14:30   jackson-databind-2.9.9.1.jar
    42456  2021-12-16 14:30   jackson-dataformat-yaml-2.9.9.jar
   325632  2021-12-16 14:30   jackson-core-2.9.9.jar
   118276  2021-12-16 14:30   swagger-models-2.0.9.jar
    66897  2021-12-16 14:30   jackson-annotations-2.9.9.jar
   135336  2021-12-16 14:30   littleproxy-2.0.0-beta-5.jar
    82706  2021-12-16 14:30   guice-servlet-4.2.2.jar
     6106  2021-12-16 14:30   guice-multibindings-4.2.2.jar
   846627  2021-12-16 14:30   guice-4.2.2.jar
  2746671  2021-12-16 14:30   guava-27.1-jre.jar
    71976  2021-10-27 08:51   jzlib-1.1.3.jar
   320748  2021-12-16 14:30   dnsjava-2.1.9.jar
  4062498  2021-12-16 14:30   netty-all-4.1.39.Final.jar
   870638  2021-12-16 14:30   bcpkix-jdk15on-1.62.jar
  4558151  2021-12-16 14:30   bcprov-jdk15on-1.62.jar
    98115  2021-10-27 08:52   dec-0.1.2.jar
    81751  2021-12-16 14:30   jersey-hk2-2.29.jar
   188187  2021-12-16 14:30   hk2-locator-2.5.0.jar
   780265  2021-12-16 14:30   javassist-3.25.0-GA.jar
   182089  2021-11-26 09:57   selenium-api-3.141.59.jar
    16461  2021-12-16 14:30   jcl-over-slf4j-1.7.28.jar
   322611  2021-12-16 14:30   async-http-client-1.6.3.jar
    41117  2021-12-16 14:30   slf4j-api-1.7.28.jar
    78146  2021-07-15 08:01   jopt-simple-5.0.4.jar
   127566  2021-12-16 14:30   jetty-servlet-9.4.20.v20190813.jar
   116947  2021-12-16 14:30   jetty-security-9.4.20.v20190813.jar
   657307  2021-12-16 14:30   jetty-server-9.4.20.v20190813.jar
   503880  2021-10-27 08:52   commons-lang3-3.9.jar
    73343  2021-12-16 14:30   jersey-container-servlet-core-2.29.jar
    53110  2021-12-16 14:30   jersey-bean-validation-2.29.jar
    29942  2021-12-16 14:30   swagger-jaxrs2-servlet-initializer-2.0.9.jar
    56674  2021-07-06 12:05   javax.activation-api-1.2.0.jar
     4617  2021-04-23 09:15   failureaccess-1.0.1.jar
     2199  2021-04-23 09:15   listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar
    19936  2021-03-12 16:55   jsr305-3.0.2.jar
   193322  2021-06-16 08:53   checker-qual-2.5.2.jar
    13694  2021-06-16 08:53   error_prone_annotations-2.2.0.jar
     8782  2021-06-16 08:53   j2objc-annotations-1.1.jar
     3448  2021-06-16 08:53   animal-sniffer-annotations-1.17.jar
  1816937  2021-07-15 08:02   barchart-udt-bundle-2.3.0.jar
     2497  2021-10-19 08:34   javax.inject-1.jar
     4467  2021-10-27 08:51   aopalliance-1.0.jar
     7083  2021-12-16 14:30   sitebricks-annotations-0.8.11.jar
   741232  2021-12-16 14:30   mvel2-2.1.3.Final.jar
     2254  2021-03-12 16:55   jcip-annotations-1.0.jar
     5594  2021-12-16 14:30   annotations-7.0.3.jar
   300845  2021-12-16 14:30   jsoup-1.8.1.jar
   926649  2021-12-16 14:30   jersey-server-2.29.jar
  1155887  2021-12-16 14:30   hibernate-validator-6.0.17.Final.jar
    93107  2021-12-16 14:30   validation-api-2.0.1.Final.jar
    95806  2021-07-15 08:01   javax.servlet-api-3.1.0.jar
   207850  2021-12-16 14:30   jetty-http-9.4.20.v20190813.jar
   156134  2021-12-16 14:30   jetty-io-9.4.20.v20190813.jar
   218808  2021-12-16 14:30   jersey-client-2.29.jar
    86010  2021-12-16 14:30   jersey-media-jaxb-2.29.jar
  1157956  2021-12-16 14:30   jersey-common-2.29.jar
   187228  2021-12-16 14:30   hk2-api-2.5.0.jar
   117332  2021-12-16 14:30   hk2-utils-2.5.0.jar
     5408  2021-12-16 14:30   jakarta.inject-2.5.0.jar
    83786  2021-12-16 14:30   jersey-entity-filtering-2.29.jar
   140262  2021-12-16 14:30   jakarta.ws.rs-api-2.1.5.jar
    78859  2021-12-16 14:30   jakarta.el-api-3.0.2.jar
   237055  2021-12-16 14:30   jakarta.el-3.0.2.jar
   428343  2021-12-16 14:30   classgraph-4.6.32.jar
    34734  2021-12-16 14:30   swagger-annotations-2.0.9.jar
   431406  2021-12-16 14:30   xstream-1.3.1.jar
   790250  2021-12-16 14:30   netty-3.2.4.Final.jar
   538722  2021-12-16 14:30   jetty-util-9.4.20.v20190813.jar
    25150  2021-12-16 14:30   jakarta.annotation-api-1.3.4.jar
    19479  2021-12-16 14:30   osgi-resource-locator-1.0.3.jar
    14212  2021-12-16 14:30   aopalliance-repackaged-2.5.0.jar
    66469  2021-12-16 14:30   jboss-logging-3.3.2.Final.jar
    65100  2021-12-16 14:30   classmate-1.3.4.jar
   301298  2021-11-29 08:26   snakeyaml-1.23.jar
    24956  2021-12-16 14:30   xpp3_min-1.1.4c.jar
---------                     -------
 31309843                     90 files
```

A sample project can be found at [<i class="fa fa-gitlab"></i> jamietanna/gradle-download-jars](https://gitlab.com/jamietanna/gradle-download-jars).
