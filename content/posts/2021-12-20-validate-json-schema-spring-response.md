---
title: "Validating a Spring (Boot) Response Matches JSON Schema with MockMVC"
description: "How to perform JSON Schema validation for a Spring (Boot) service's response when testing using MockMVC."
tags:
- blogumentation
- spring
- spring-boot
- java
- json-schema
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-20T14:43:13+0000
slug: validate-json-schema-spring-response
image: /img/vendor/spring-logo.png
---
If you're developing an API in Spring (Boot) it's very likely that you're using MockMVC as a means to validate that your web layer is set up correctly.

(If you're not already doing this, give [_Shift Your Testing Left with Spring Boot Controllers_](/posts/2021/11/28/spring-boot-controller-tdd/) a read!)

Hopefully you're also [using a JSON Schema for the Interface Portion of your RESTful API](/posts/2021/12/16/api-object-schema/) to make sure that you have a well-formed structure for your data models.

But the age-old problem is always being confident that things are actually matching correctly, because it's hard to keep them aligned, even when you're [automagically generating them](/posts/2021/11/29/gradle-json-schema/), because there may be optional fields that you're forgetting to set.

Today I've been looking at how you can do this through MockMVC and found that although it's not a first-class citizen (at time of writing) with Spring's [`ContentResultMatchers`](https://docs.spring.io/spring-framework/docs/5.3.13/javadoc-api/org/springframework/test/web/servlet/result/ContentResultMatchers.html), it's actually straightforward to do using Rest Assured's standalone [`json-schema-validator` dependency](https://mvnrepository.com/artifact/io.rest-assured/json-schema-validator).

# Example

The below code snippets are taken from the example project, which is available [on GitLab](https://gitlab.com/jamietanna/json-schema-mockmvc).

Let's say that we have an API endpoint that can be described by the following JSON Schema:

```json
{
  "$schema": "https://json-schema.org/draft/2019-09/schema",
  "$id": "https://gitlab.com/jamietanna/json-schema-mockmvc/-/tree/main/src/test/resources/schemas/api-response.json",
  "title": "Example API",
  "type": "object",
  "required": [
    "apis"
  ],
  "properties": {
    "apis": {
      "type": "array",
      "items": {
        "type": "object",
        "required": [
          "name",
          "url"
        ],
        "properties": {
          "name": {
            "type": "string"
          },
          "url": {
            "type": "string"
          }
        }
      }
    }
  }
}
```

If we assume that we've already got tests that perform the following validation:

```java
private ResultActions resultActions;

@BeforeEach
void setup() throws Exception {
  Api api0 = new Api("Contacts API", "https://example.com/contacts");
  Api api1 = new Api("Publishing API", "https://example.com/publishing");
  when(service.findAll()).thenReturn(Set.of(api0, api1));

  resultActions = mvc.perform(get("/apis"));
}

@Test
void containsItems() throws Exception {
  resultActions.andExpect(jsonPath("$.apis").isArray());
}

// ...
```

If we want to add in a JSON Schema validation test as part of this, what we can do is add a new dependency on the [`json-schema-validator` dependency](https://mvnrepository.com/artifact/io.rest-assured/json-schema-validator), and then use the Hamcrest matcher provided:

```java
import static io.restassured.module.jsv.JsonSchemaValidator.matchesJsonSchemaInClasspath;

// ...

@Test
void matchesJsonSchema() throws Exception {
  resultActions.andExpect(
      content().string(matchesJsonSchemaInClasspath("schemas/api-response.json")));
}
```

Which will now give us a handy set of errors if we accidentally break our schema:

<details>

<summary>Example error</summary>

```
Response content
Expected: The content to match the given JSON schema.
error: instance type (null) does not match any allowed primitive type (allowed: ["string"])
    level: "error"
    schema: {"loadingURI":"file:/home/jamie/workspaces/tmp/json-schema-mockmvc/build/resources/test/schemas/api-response.json#","pointer":"/properties/apis/items/properties/name"}
    instance: {"pointer":"/apis/0/name"}
    domain: "validation"
    keyword: "type"
    found: "null"
    expected: ["string"]
error: instance type (null) does not match any allowed primitive type (allowed: ["string"])
    level: "error"
    schema: {"loadingURI":"file:/home/jamie/workspaces/tmp/json-schema-mockmvc/build/resources/test/schemas/api-response.json#","pointer":"/properties/apis/items/properties/url"}
    instance: {"pointer":"/apis/0/url"}
    domain: "validation"
    keyword: "type"
    found: "null"
    expected: ["string"]

     but: was "{\"apis\":[{\"name\":null,\"url\":null}]}"
java.lang.AssertionError: Response content
Expected: The content to match the given JSON schema.
error: instance type (null) does not match any allowed primitive type (allowed: ["string"])
    level: "error"
    schema: {"loadingURI":"file:/home/jamie/workspaces/tmp/json-schema-mockmvc/build/resources/test/schemas/api-response.json#","pointer":"/properties/apis/items/properties/name"}
    instance: {"pointer":"/apis/0/name"}
    domain: "validation"
    keyword: "type"
    found: "null"
    expected: ["string"]
error: instance type (null) does not match any allowed primitive type (allowed: ["string"])
    level: "error"
    schema: {"loadingURI":"file:/home/jamie/workspaces/tmp/json-schema-mockmvc/build/resources/test/schemas/api-response.json#","pointer":"/properties/apis/items/properties/url"}
    instance: {"pointer":"/apis/0/url"}
    domain: "validation"
    keyword: "type"
    found: "null"
    expected: ["string"]

     but: was "{\"apis\":[{\"name\":null,\"url\":null}]}"
```

</details>
