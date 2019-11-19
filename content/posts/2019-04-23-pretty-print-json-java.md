---
title: "Pretty Print JSON with Java"
description: "How to pretty print a JSON object using Java and Jackson."
tags:
- blogumentation
- java
- json
- pretty-print
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-04-23T21:22:00+0100
slug: "pretty-print-json-java"
series: pretty-print-json
---
Note: This has been adapted from steps from [mkyong.com](https://www.mkyong.com/java/how-to-enable-pretty-print-json-output-jackson/).

When we want to pretty print a JSON object in Java, we can take advantage of the [Jackson](https://github.com/FasterXML/jackson-core) library's serialisation of objects.

For this to happen, all we need is to have a Plain Old Java Object (POJO) that is the data object for the class, with the relevant markup for JSON properties:

```java
import com.fasterxml.jackson.annotation.JsonProperty;

class TheObject {
    @JsonProperty("wibble")
    public String wibble;

    @JsonProperty("foo")
    public int foo;
}
```

Now we can use an instance of Jackson's `ObjectMapper` class to return a `String` with the pretty-printed JSON value, which we can then print out as we want:

```java
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public void prettyPrintObject() {
    ObjectMapper objectMapper = new ObjectMapper();
    TheObject o = new TheObject();
    o.wibble = "hello there";
    o.foo = 1234;
    o.map = new HashMap<>();
    o.map.put("abc", "def");

    String value = objectMapper.writerWithDefaultPrettyPrinter()
      .writeValueAsString(o);
    System.out.println(value);
}
```

This gives us a nice pretty-printed result:

```json
{
  "wibble" : "hello there",
  "foo" : 1234,
  "map" : {
    "abc" : "def"
  }
}
```

This was tested with Jackson v2.9.8.
