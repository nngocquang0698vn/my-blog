---
title: "Gotcha: URL Encoding for consecutive double slashes issue with Rest Assured"
description: "How to workaround consecutive double slashes being URL encoded (as `%2F`s) in Rest Assured."
categories:
- blogumentation
- rest-assured
tags:
- blogumentation
- java
- rest-assured
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-04-15T22:16:21+0100
slug: "url-encode-restassured"
---
Earlier today I was writing some Java to interact with a RESTful API using [Rest Assured](http://rest-assured.io/). However, I was seeing some weird results with URL encoded characters in my perfectly reasonable URLs.

The code I was using was similar to below:

```java
// passed into the method as an empty string
String argument = "";
String FORMAT = "https://some/api/%s/";
given()
  .when()
  .log().all()
  .get(String.format(FORMAT, argument))
  .then()
  .log().all();
```

When running this, I received the following logs from Rest Assured:

```
Request method:	GET
Request URI:	https://some/api%2F%2F/
Proxy:			<none>
Request params:	<none>
Query params:	<none>
Form params:	<none>
Path params:	<none>
Headers:		Accept=*/*
Cookies:		<none>
Multiparts:		<none>
Body:			<none>
```

Notice that the URL has two `%2F`s, which are the URL encoded value of a `/`.

I didn't expect this, and after doing some searching around found two issues on the Rest Assured issue tracker: [issue 335](https://github.com/rest-assured/rest-assured/issues/335) and [issue 867](https://github.com/rest-assured/rest-assured/issues/867).

It appears that the workaround is to disable URL encoding:

```diff
 String argument = "";
 String FORMAT = "https://some/api/%s/";
 given()
+  .urlEncodingEnabled(false)
   .when()
   .log().all()
   .get(String.format(FORMAT, argument))
   .then()
   .log().all();
```

Or:

```diff
 String argument = "";
 String FORMAT = "https://some/api/%s/";
 given()
   .when()
+  .urlEncodingEnabled(false)
   .log().all()
   .get(String.format(FORMAT, argument))
   .then()
   .log().all();
```

Which gives gives a correct request:

```
Request method:	GET
Request URI:	https://some/api///
Proxy:			<none>
Request params:	<none>
Query params:	<none>
Form params:	<none>
Path params:	<none>
Headers:		Accept=*/*
Cookies:		<none>
Multiparts:		<none>
Body:			<none>
```

This appears to affect _at least_ RestAssured versions v2.8.0 and v3.3.0.

Note: RestAssured appears to add a trailing slash, leading to three slashes.
