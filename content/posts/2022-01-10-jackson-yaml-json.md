---
title: "Adding both an `ObjectMapper` and a `YAMLMapper` to Spring Boot"
description: "How to have an `ObjectMapper` and a `YAMLMapper` coexisting in a Spring Boot project's bean dependencies."
tags:
- blogumentation
- java
- jackson
- spring-boot
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-10T17:35:48+0000
slug: "jackson-yaml-json"
image: https://media.jvt.me/7e70383567.png
---
There are times where you may want to interact with both JSON and YAML in your Spring Boot services, for instance if your HTTP layer is JSON, and you want to read YAML files from some data source.

The below is based on a Spring Boot 2.6.2 service, with Jackson v2.13.1.

If we assume that we have the following configuration class:

```java
import org.springframework.context.annotation.Configuration;

@Configuration
public class SpringConfiguration {
}
```

And when we send an API request, we get the following response:

```http
HTTP/1.1 200
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Cache-Control: no-cache, no-store, max-age=0, must-revalidate
Pragma: no-cache
Expires: 0
X-Frame-Options: DENY
Content-Type: application/vnd.spring-boot.actuator.v3+json
Transfer-Encoding: chunked
Date: Mon, 10 Jan 2022 17:28:05 GMT

{
  "java": {
    "jvm": {
      "name": "OpenJDK 64-Bit Server VM",
      "vendor": "Oracle Corporation",
      "version": "17.0.1+12-39"
    },
    "runtime": {
      "name": "OpenJDK Runtime Environment",
      "version": "17.0.1+12-39"
    },
    "vendor": "Oracle Corporation",
    "version": "17.0.1"
  },
  "test": "hello"
}
```

Now, if we add a `YAMLMapper`:

```java
import com.fasterxml.jackson.dataformat.yaml.YAMLMapper;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SpringConfiguration {
  @Bean
  public YAMLMapper yamlMapper() {
    return new YAMLMapper();
  }
}
```

We get the following back from the API:

```http
HTTP/1.1 200
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Cache-Control: no-cache, no-store, max-age=0, must-revalidate
Pragma: no-cache
Expires: 0
X-Frame-Options: DENY
Content-Type: application/vnd.spring-boot.actuator.v3+json
Transfer-Encoding: chunked
Date: Mon, 10 Jan 2022 17:30:16 GMT

---
test: "hello"
java:
  vendor: "Oracle Corporation"
  version: "17.0.1"
  runtime:
    name: "OpenJDK Runtime Environment"
    version: "17.0.1+12-39"
  jvm:
    name: "OpenJDK 64-Bit Server VM"
    vendor: "Oracle Corporation"
    version: "17.0.1+12-39"
```

Which hopefully you can see does not look right, as it's rendering as YAML, although the `content-type` describes itself as JSON.

This is because the `YAMLMapper` extends `ObjectMapper`, and Spring Boot doesn't autoconfigure an `ObjectMapper` for us, as there's already an `ObjectMapper` (the `YAMLMapper`) available as a bean.

To solve this, we can make sure that we explicitly opt-in to the Jackson autoconfiguration which enables the creation of the `ObjectMapper`, as well as the existing `YAMLMapper`:

```java
import com.fasterxml.jackson.dataformat.yaml.YAMLMapper;

import org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Configuration
@Import(JacksonAutoConfiguration.class})
public class SpringConfiguration {
  @Bean
  public YAMLMapper yamlMapper() {
    return new YAMLMapper();
  }
}
```

This now returns us a valid JSON response, again, and the two beans can coexist safely.
