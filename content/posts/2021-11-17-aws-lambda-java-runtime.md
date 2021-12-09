---
title: "Determining the Version Of Libraries Packaged into the Java AWS Lambda Runtime"
description: "How to determine what libraries, and their respective versions, are packaged into AWS Lambda."
tags:
- blogumentation
- java
- aws
- aws-lambda
- serverless
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-11-17T17:21:49+0000
slug: "aws-lambda-java-runtime"
image: /img/vendor/AmazonWebservices_Logo.png
---
If you're building an application on AWS Lambda, you may have gone through the pain of trying to work out what versions of libraries are installed in the runtime.

It may be that you've hit a bug where you're expecting a newer version of Jackson than is available, or that you're trying to check if GSON is installed or not.

Fortunately, you can find this out - not using AWS documentation, but by reverse engineering things, which appears to be the AWS way!

The wonderful folks over at <span class="h-card"><a class="u-url" href="http://lambci.org/">LambCI</a></span> have created [lambci/lambda](https://github.com/lambci/docker-lambda) which produces Docker containers with a copy of the filesystem as they exist in AWS Lambda, which means these are the best way to find out, without AWS adding documentation for it.

# JDK8

We can see the libraries and their versions by listing the contents of `/var/runtime/lib`:

```sh
$ docker run --entrypoint=ls -ti lambci/lambda:java8 /var/runtime/lib/
-rw-r--r-- 1 root root   15603 Nov 14  2020 AWSJavaSDKRegionXmlOverride-2.0.jar
-rw-r--r-- 1 root root    7409 Nov 14  2020 aws-lambda-java-core-1.2.0.jar
-rw-r--r-- 1 root root  206964 Nov 14  2020 gson-2.3.1.jar
-rw-r--r-- 1 root root   46468 Nov 14  2020 jackson-annotations-2.6.x.jar
-rw-r--r-- 1 root root  261317 Nov 14  2020 jackson-core-2.6.x.jar
-rw-r--r-- 1 root root 1172410 Nov 14  2020 jackson-databind-2.6.x.20200928.jar
-rw-r--r-- 1 root root 1349498 Nov 14  2020 joda-time-2.8.2.jar
-rw-r--r-- 1 root root   54495 Nov 14  2020 json-20160810.jar
-rw-r--r-- 1 root root  146122 Nov 14  2020 json-20160810-javadoc.jar
-rw-r--r-- 1 root root   58172 Nov 14  2020 json-20160810-sources.jar
-rw-r--r-- 1 root root    4084 Nov 14  2020 LambdaJavaRTEntry-1.0.jar
-rw-r--r-- 1 root root  140297 Jan 29  2021 LambdaSandboxJava-1.0.jar
-rwxr-xr-x 1 root root   51824 Nov 14  2020 libawslambda.so
-rwxr-xr-x 1 root root   67616 Nov 14  2020 liblambdaipc.so
-rwxr-xr-x 1 root root   26312 Nov 14  2020 liblambdalog.so
-rwxr-xr-x 1 root root  113208 Nov 14  2020 liblambdaruntime.so
```

This is useful, because we can see the version of each of these libraries in the filename.

Jackson isn't as clear, and we can't see an exact match in Maven Central by looking at the checksums, but we can be comfortable with the fact that it's a 2.6.x release.

# JDK11

On JDK 11, it's a little more difficult to see what's available, as the dependencies are bundled into a set of JARs:

```sh
$ docker run --entrypoint=ls -ti lambci/lambda:java11 /var/runtime/lib/
-rw-r--r-- 1 root root    7410 Dec  2  2020 aws-lambda-java-core-1.2.0.jar
-rw-r--r-- 1 root root  370426 Dec  2  2020 aws-lambda-java-runtime-0.2.0.jar
-rw-r--r-- 1 root root 2286677 Dec  2  2020 aws-lambda-java-serialization-0.2.0.jar
```

We can see that this is the [aws-lambda-java-core v1.2.0](https://mvnrepository.com/artifact/com.amazonaws/aws-lambda-java-core/1.2.0) dependency, but the `aws-lambda-java-runtime` and `aws-lambda-java-serialization` don't match anything on Maven Central, nor GitHub, as they appear to be private AWS libraries.

Because [JARs are just ZIP files](/posts/2020/02/25/unzip-jar/), we can use `unzip` to list the contents:

```
$ unzip -l aws-lambda-java-runtime-0.2.0.jar
# or
$ unzip -l aws-lambda-java-serialization-0.2.0.jar
```

This, unfortunately, still doesn't give us much information about the versions, just the dependencies.

In Jackson, we fortunately have the class `PackageVersion` class which when decompiled shows this is Jackson v2.10.0:

<details>

<summary>Decompiled <code>PackageVersion</code> class</summary>

```java
//
// Decompiled by Procyon v0.5.36
//

package com.amazonaws.lambda.thirdparty.com.fasterxml.jackson.databind.cfg;

import com.amazonaws.lambda.thirdparty.com.fasterxml.jackson.core.util.VersionUtil;
import com.amazonaws.lambda.thirdparty.com.fasterxml.jackson.core.Version;
import com.amazonaws.lambda.thirdparty.com.fasterxml.jackson.core.Versioned;

public final class PackageVersion implements Versioned
{
    public static final Version VERSION;

    public Version version() {
        return PackageVersion.VERSION;
    }

    static {
        VERSION = VersionUtil.parseVersion("2.10.0", "com.amazonaws.lambda.thirdparty.com.fasterxml.jackson.core", "jackson-databind");
    }
}
```

</details>

Unfortunately I've not found a straightforward way to determine the versions for the other classes, if you find a way, please write in to let me know!
