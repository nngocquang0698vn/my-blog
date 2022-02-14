---
title: "Generate Plain Old Java Objects (POJOs) from JSON Schema Definitions with Gradle"
description: How to generate POJOs really quickly and easily, with no manual work, using the Gradle jsonschema2pojo Plugin.
tags:
- blogumentation
- gradle
- java
- json-schema
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-11-29T09:23:37+0000
slug: "gradle-json-schema"
image: https://media.jvt.me/c25b297eaa.png
---
It's possible that you're using [JSON Schema](https://json-schema.org/) as a means for describing and validating your data is formatted correctly.

If you're on a Java project, it may be that you're currently manually translating from JSON Schema types to Plain Old Java Objects (POJOs), which is time consuming and has the risk of drifting between your definitions and implementations.

One of the benefits of using a very structured format like JSON Schema is that you can programmatically generate the contents of your Java models, or any other languages you may be using, for that matter.

# Example JSON Schema

As an example, we'll use the JSON Schema noted on the [jsonschema2pojo website](https://www.jsonschema2pojo.org):

```json
{
  "type":"object",
  "properties": {
    "foo": {
      "type": "string"
    },
    "bar": {
      "type": "integer"
    },
    "baz": {
      "type": "boolean"
    }
  }
}
```

This will be stored in the location `src/main/resources/schema/data.json`.

# Generating the POJOs

There are then two options for how we want to generate the POJOs.

In both cases, we receive the following Java objects:

<details>

<summary>Generated <code>Data</code> class</summary>

```java
import java.util.HashMap;
import java.util.Map;
import javax.annotation.processing.Generated;
import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonPropertyOrder({
    "foo",
    "bar",
    "baz"
})
@Generated("jsonschema2pojo")
public class Data {

    @JsonProperty("foo")
    private String foo;
    @JsonProperty("bar")
    private Integer bar;
    @JsonProperty("baz")
    private Boolean baz;
    @JsonIgnore
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonProperty("foo")
    public String getFoo() {
        return foo;
    }

    @JsonProperty("foo")
    public void setFoo(String foo) {
        this.foo = foo;
    }

    @JsonProperty("bar")
    public Integer getBar() {
        return bar;
    }

    @JsonProperty("bar")
    public void setBar(Integer bar) {
        this.bar = bar;
    }

    @JsonProperty("baz")
    public Boolean getBaz() {
        return baz;
    }

    @JsonProperty("baz")
    public void setBaz(Boolean baz) {
        this.baz = baz;
    }

    @JsonAnyGetter
    public Map<String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    @JsonAnySetter
    public void setAdditionalProperty(String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(Data.class.getName()).append('@').append(Integer.toHexString(System.identityHashCode(this))).append('[');
        sb.append("foo");
        sb.append('=');
        sb.append(((this.foo == null)?"<null>":this.foo));
        sb.append(',');
        sb.append("bar");
        sb.append('=');
        sb.append(((this.bar == null)?"<null>":this.bar));
        sb.append(',');
        sb.append("baz");
        sb.append('=');
        sb.append(((this.baz == null)?"<null>":this.baz));
        sb.append(',');
        sb.append("additionalProperties");
        sb.append('=');
        sb.append(((this.additionalProperties == null)?"<null>":this.additionalProperties));
        sb.append(',');
        if (sb.charAt((sb.length()- 1)) == ',') {
            sb.setCharAt((sb.length()- 1), ']');
        } else {
            sb.append(']');
        }
        return sb.toString();
    }

    @Override
    public int hashCode() {
        int result = 1;
        result = ((result* 31)+((this.bar == null)? 0 :this.bar.hashCode()));
        result = ((result* 31)+((this.baz == null)? 0 :this.baz.hashCode()));
        result = ((result* 31)+((this.additionalProperties == null)? 0 :this.additionalProperties.hashCode()));
        result = ((result* 31)+((this.foo == null)? 0 :this.foo.hashCode()));
        return result;
    }

    @Override
    public boolean equals(Object other) {
        if (other == this) {
            return true;
        }
        if ((other instanceof Data) == false) {
            return false;
        }
        Data rhs = ((Data) other);
        return (((((this.bar == rhs.bar)||((this.bar!= null)&&this.bar.equals(rhs.bar)))&&((this.baz == rhs.baz)||((this.baz!= null)&&this.baz.equals(rhs.baz))))&&((this.additionalProperties == rhs.additionalProperties)||((this.additionalProperties!= null)&&this.additionalProperties.equals(rhs.additionalProperties))))&&((this.foo == rhs.foo)||((this.foo!= null)&&this.foo.equals(rhs.foo))));
    }

}
```

</details>


# jsonschema2pojo-gradle-plugin

The official jsonschema2pojo project has [a Gradle plugin](https://github.com/joelittlejohn/jsonschema2pojo/tree/master/jsonschema2pojo-gradle-plugin) that can be used.

As noted in [_Add to Gradle Plugin Portal_](https://github.com/joelittlejohn/jsonschema2pojo/issues/282), it's likely that you've not seen this before, as it's not on the Gradle plugin portal, so it means we need to use the legacy plugin configuration using our `buildscript`:

```groovy
buildscript {
  dependencies {
    classpath 'org.jsonschema2pojo:jsonschema2pojo-gradle-plugin:1.1.1'
  }
}

apply plugin: 'jsonschema2pojo'

dependencies {
  // ...
}

jsonSchema2Pojo {
  source = files("${sourceSets.main.output.resourcesDir}/schema")
  targetDirectory = file("${project.buildDir}/generated-sources/js2p") // required for IDEs to pick it up as a source root
}
```

When compiling the project, for instance as part of a build, it'll produce the objects into the `targetDirectory`, which should then be consumable by your project.

## js2d-gradle

Alternatively, there's the [jsonschema2dataclass Gradle plugin, js2d-gradle](https://github.com/jsonschema2dataclass/js2d-gradle), which _is_ [on the Gradle plugin portal](https://plugins.gradle.org/plugin/org.jsonschema2dataclass).

```groovy
plugins {
  id 'uk.gov.api.spring-boot-conventions'
  id "org.jsonschema2dataclass" version "3.2.1"
}

dependencies {
  // ...
}

jsonSchema2Pojo {
  source.setFrom files("${sourceSets.main.output.resourcesDir}/schema")
  // default targetDirectoryPrefix works with IDEs
}
```

When compiling the project, for instance as part of a build, it'll produce the objects into a location that can be consumed by your project.

While writing this article, I spotted [an issue in the docs](https://github.com/jsonschema2dataclass/js2d-gradle/pull/195) so until that's merged, watch out!
