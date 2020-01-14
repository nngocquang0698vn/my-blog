---
title: "Performing Mutual TLS Authentication with Rest Assured"
description: "How to configure Rest Assured to perform Mutual TLS authentication against an API."
tags:
- blogumentation
- certificates
- mutual-tls
- java
- rest-assured
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-01-14T19:27:21+0000
slug: "mutual-tls-auth-rest-assured"
---
It's possible that you want to perform mutual TLS authentication to further secure your APIs.

If you're writing a Java project, it's possible you're using [Rest Assured](http://rest-assured.io/) to interact with your API.

But it's not immediately obvious how we can actually set it up within Rest Assured. Fortunately, if we look at the [`auth()` method, which returns an `AuthenticationSpecification`](https://www.javadoc.io/static/io.rest-assured/rest-assured/4.0.0/io/restassured/specification/AuthenticationSpecification.html), there is a `certificate` method, which allows us to pass in a pre-created JKS keystore and its password:

```java

String pathToKeystore = "/path/to/keystore.jks";
String keystorePassword = "changeit";

RestAssured
  .given()
  .auth()
    .certificate(pathToKeystore, keystorePassword)
  .get("https://localhost:8443/");
```

Rest Assured will then go through the keystore and authenticate with the key it needs.

Note that this was tested with Rest Assured v4.0.0.
