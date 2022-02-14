---
title: "Testing Data Serialisation/Deserialization in Java (with Moshi)"
description: "How to validate your JSON types correctly serialise/deserialise when using the Moshi library."
tags:
- java
- testing
- moshi
- blogumentation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-01T09:42:31+0000
slug: "testing-json-moshi"
series: writing-better-tests
image: https://media.jvt.me/7e70383567.png
---
In [_Testing Data Serialisation/Deserialization in Java (with Jackson)_](/posts/2021/10/02/testing-json/), I mentioned how you could test your serialisation layer if you're using Jackson.

One of the [learnings from running Java AWS Lambdas](/posts/2021/11/17/java-serverless-learnings/) is that [Moshi](https://github.com/square/moshi) is a great for your JSON (de)serialisation layer.

Because this is a pretty integral part of interacting with other services / being interacted with, we need to make sure these models are mapped correctly.

Testing these can be done in a few ways, but often I see them not being tested as low in the test pyramid as we can do.

Fortunately, there are a few options for how we can test that serialisation (from object to string) and deserialisation (from string to object) works.

For instance, let's say we have the class:

```java
import com.squareup.moshi.Json;

public class TokenGrantDto {
  @Json(name = "access_token")
  private String accessToken;
  @Json(name = "refresh_token")
  private String refreshToken;
  @Json(name = "expires_in")
  private long expiresIn;
  private String scope;

  public String getAccessToken() {
    return accessToken;
  }

  public void setAccessToken(String accessToken) {
    this.accessToken = accessToken;
  }

  public String getRefreshToken() {
    return refreshToken;
  }

  public void setRefreshToken(String refreshToken) {
    this.refreshToken = refreshToken;
  }

  public long getExpiresIn() {
    return expiresIn;
  }

  public void setExpiresIn(long expiresIn) {
    this.expiresIn = expiresIn;
  }

  public String getScope() {
    return scope;
  }

  public void setScope(String scope) {
    this.scope = scope;
  }
}
```

We could write a test like so which validates that the serialisation is set up correctly:

```java
import com.squareup.moshi.JsonAdapter;
import com.squareup.moshi.Moshi;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class TokenGrantDtoJsonTest {
  private final Moshi moshi = new Moshi.Builder().build();
  private final JsonAdapter<TokenGrantDto> adapter = moshi.adapter(TokenGrantDto.class);

  @Nested
  class Serialization {
    @Nested
    class HappyPath {

      private String asJson;

      @BeforeEach
      void setup() {
        TokenGrantDto dto = new TokenGrantDto();
        dto.setAccessToken("j.w.t");
        dto.setRefreshToken("r.j.w.t");
        dto.setScope("foo bar");
        dto.setExpiresIn(123L);

        asJson = adapter.toJson(dto);
      }

      @Test
      void scopeIsMapped() {
        assertThat(asJson).contains("\"scope\":\"foo bar\"");
      }

      @Test
      void expiresInIsMapped() {
        assertThat(asJson).contains("\"expires_in\":123");
      }

      @Test
      void accessTokenIsMapped() {
        assertThat(asJson).contains("\"access_token\":\"j.w.t\"");
      }

      @Test
      void refreshTokenIsMapped() {
        assertThat(asJson).contains("\"refresh_token\":\"r.j.w.t\"");
      }
    }
  }
}
```

This works, gives us incredibly fast feedback, but requires embedding JSON strings. I don't know about you, but I find that having to craft and maintain embedded JSON strings is _the worst_.

It also has the risk that at some point you'll need to introduce whitespace in each place if you change that way that the JSON is produced, and then we have to update a _tonne_ of test data unnecessarily.

Or, we inject each of these snippets from files, which still leaves us with a fair bit of overhead.

Alternatively, we can utilise Jackson _for test purposes only_, so we can parse the JSON that is produced into the generic and handy `JsonNode` for easier validation:

```java
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.squareup.moshi.JsonAdapter;
import com.squareup.moshi.Moshi;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class TokenGrantDtoJsonTest {
  private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
  private final Moshi moshi = new Moshi.Builder().build();
  private final JsonAdapter<TokenGrantDto> adapter = moshi.adapter(TokenGrantDto.class);

  @Nested
  class Serialization {
    @Nested
    class HappyPath {

      private JsonNode asJson;

      @BeforeEach
      void setup() throws JsonProcessingException {
        TokenGrantDto dto = new TokenGrantDto();
        dto.setAccessToken("j.w.t");
        dto.setRefreshToken("r.j.w.t");
        dto.setScope("foo bar");
        dto.setExpiresIn(123L);

        asJson = OBJECT_MAPPER.readValue(adapter.toJson(dto), JsonNode.class);
      }

      @Test
      void scopeIsMapped() {
        assertThat(asJson.get("scope").textValue()).isEqualTo("foo bar");
      }

      @Test
      void expiresInIsMapped() {
        assertThat(asJson.get("expires_in").numberValue()).isEqualTo(123);
      }

      @Test
      void accessTokenIsMapped() {
        assertThat(asJson.get("access_token").textValue()).isEqualTo("j.w.t");
      }

      @Test
      void refreshTokenIsMapped() {
        assertThat(asJson.get("refresh_token").textValue()).isEqualTo("r.j.w.t");
      }
    }
  }
}
```

This gives us a pretty handy test harness, and we don't need to manage JSON strings, as well as having a bit more control over checking whether fields are absent:

```java
@Test
void isNotSerialised() {
  assertThat(asJson.get("scope")).isNull();
}
```
