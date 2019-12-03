---
title: "Extracting Request Parameters Dynamically for a `application/x-www-form-urlencoded` Request"
description: "How to access all key-value pairs of parameters sent in a `application/x-www-form-urlencoded` request."
tags:
- blogumentation
- java
- spring
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-08T14:04:33+01:00
slug: "spring-extract-form-request-parameters"
image: /img/vendor/spring-logo.png
---
While working on my [Micropub endpoint]({{< ref "2019-08-26-setting-up-micropub" >}}) I found that I needed to support `application/x-www-form-urlencoded` requests.

I had to dynamically parse these fields out because on any given request there could be anywhere between 4 and 10 parameters in a given request, and I'd not really ever know what that request would look like until receiving it.

I found that Spring has you covered, and makes this quite convenient, simply asking you to amend your endpoint to request a `MultiValueMap`. Remember to mark it as the `@RequestBody`, otherwise Spring won't know where those parameters are coming from:

```java
import org.springframework.util.MultiValueMap;

@PostMapping(path = "/endpoint", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
public ResponseEntity<String> form(@RequestBody MultiValueMap<String, String> formParameters) {
  // iterate through `formParameters` as you wish

  // get all values for a given parameter
  List<String> contentValues = formParameters.get("content");

  // get the first instance for a given parameter
  String content = formParameters.getFirst("content");
}
```

This has been tested with Spring Boot 2.1.4.RELEASE (which contains Spring 5.1.6.RELEASE).
