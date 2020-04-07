---
title: "Providing Custom Serialization for `Map` Keys in Jackson"
description: "How to configure Jackson to use a custom method to serialise keys for a `Map`."
tags:
- blogumentation
- java
- jackson
- json
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-04-07T18:37:19+0100
slug: "jackson-map-key-serialise"
---
If you're working with Java and are serialising/deserialising content to or from JSON, you will likely be using [Jackson](https://github.com/FasterXML/jackson-databind).

If you have a `Map<String, T>`, you may want to tweak the way that the keys are then represented in i.e. JSON serialisation, because Jackson will by default use camel case.

In my case, I wanted to replace keys in a camel case format (such as `likeOf`) with a kebab case (such as `like-of`), which I used [Guava's `CaseFormat` functionality](https://guava.dev/releases/22.0/api/docs/com/google/common/base/CaseFormat.html) for, but the logic you want can be plumbed in as needed.

Because these are `String` keys, we can extend the existing [`StringKeySerializer`](https://fasterxml.github.io/jackson-databind/javadoc/2.10/com/fasterxml/jackson/databind/ser/std/StdSerializer.html) class that Jackson provides, and write our own implementation for how to serialise the key:

```java
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.StdKeySerializers.StringKeySerializer;

public class KebabCaseKeySerialiser extends StringKeySerializer {

  @Override
  public void serialize(Object value, JsonGenerator g, SerializerProvider provider)
      throws IOException {
    // unnecessary assignment for readability
    String newKeyValue = CaseFormat.LOWER_CAMEL.to(CaseFormat.LOWER_HYPHEN, (String) value);
    g.writeFieldName(newKeyValue);
  }
}
```

Then, on the POJO that is being serialised:

```java
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

@JsonSerialize(keyUsing = KebabCaseKeySerialiser.class)
public class Properties extends HashMap<String, Object> {
  // ...
}
```

This then instructs Jackson to serialise the keys using our custom serialiser - awesome!

This was tested with Jackson v2.10.2.
