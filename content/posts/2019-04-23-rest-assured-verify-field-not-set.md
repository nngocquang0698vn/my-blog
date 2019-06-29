---
title: "Verify if a field in a JSON response is not set with Rest Assured"
description: "How to verify whether a field is not present in a JSON Rest Assured `Response`."
tags:
- blogumentation
- java
- rest-assured
- json
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-04-23T22:07:13+0100
slug: "rest-assured-verify-field-not-set"
---
Earlier today I was trying to write some assertions on a [Rest Assured](http://rest-assured.io/) `Response`, where I was validating that the resulting JSON had fields that were **not** being returned.

Let us say that I want to validate that the response coming back does _not_ have the field `description`, only `id`:

```json
{
  "id": 1
}
```

To interact with a JSON `Response`, I used the `.path` method on the `Response`, such as:

```java
import io.restassured.response.Response;

import static io.restassured.RestAssured.given;

Response response = given()
  .when()
  .get("...");
String description = response.path("description");
// assert with your favourite assertion library
assertThat(description).isNotNull();
```

This worked great until I realised that it wouldn't handle the case where `description` returns a `null`:

```json
{
  "id": 1,
  "description": null
}
```

This means we instead need to use Rest Assured's `ValidatableResponse` and Hamcrest's `hasKey` matcher:

```java
import io.restassured.response.Response;
import io.restassured.response.ValidatableResponse;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.hasKey;

// ...
Response response = given()
  .when()
  .get("...");
ValidatableResponse validatableResponse = response.then();
validatableResponse.body("$", not(hasKey("description")));
```

This will then throw an `AssertionError` when we have a `description` field present, even if it's set to `null`:

```
Exception in thread "main" java.lang.AssertionError: 1 expectation failed.
JSON path $ doesn't match.
Expected: not map containing ["description"->ANYTHING]
  Actual: {description=null, id=1}
```
