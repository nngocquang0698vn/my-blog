---
title: "Extracting Request Parameters Dynamically for a `multipart/form-data` Request"
description: "How to access all key-value pairs of parameters sent in a `multipart/form-data` request."
tags:
- blogumentation
- java
- spring
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-08T14:04:33+01:00
slug: "spring-extract-multipart-request-parameters"
---
While working on my [Micropub endpoint]({{< ref "2019-08-26-setting-up-micropub" >}}) I found that I needed to support `multipart/form-data` requests. Having never worked with them, there was a bit of a learning curve, especially around how to get the request parameters out of them (as I was not yet needing to support the media aspect of the request).

I had to dynamically parse these fields out because on any given request there could be anywhere between 4 and 10 parameters in a given request, and I'd not really ever know what that request would look like until receiving it.

Unfortunately most of the articles/answers on Stack Overflow I could find were not very helpful as they were based on the expectation that you had knowledge of which fields you were going to receive.

I did, however, manage to finally track down [this StackOverflow answer](https://stackoverflow.com/a/19830841) which mentions you can use the [`MultipartHttpServletRequest`](https://docs.spring.io/spring-framework/docs/5.1.6.RELEASE/javadoc-api/org/springframework/web/multipart/MultipartHttpServletRequest.html).

By adding this parameter to your endpoint's method call, you then get access to the full key-value parameters for the request in a `Map` which allows you to perform more automated traversal through the request's parameters.

This can be hooked in as such:

```java
import org.springframework.util.MultiValueMap;

@PostMapping(path = "/endpoint", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
public ResponseEntity<String> multipartForm(MultipartHttpServletRequest multipartRequest) {
  Map<String, String[]> multipartRequestParams = multipartRequest.getParameterMap();
  // iterate through the Map as you want, or get individual fields out
  String[] contentArr = multipartRequestParams.get("content");

  // or
  String[] contentArr = multiPartRequest.getParameter("content");
}
```

This has been tested with Spring Boot 2.1.4.RELEASE (which contains Spring 5.1.6.RELEASE).
