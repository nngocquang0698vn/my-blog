---
title: "Testing Data Serialisation/Deserialization in Java (with Gson)"
description: "How to validate your JSON types correctly serialise/deserialise when using the Gson library."
tags:
- java
- testing
- gson
- blogumentation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-07T09:21:02+0000
slug: "testing-json-gson"
series: writing-better-tests
image: https://media.jvt.me/7e70383567.png
---
In [_Testing Data Serialisation/Deserialization in Java (with Jackson)_](/posts/2021/10/02/testing-json/), I mentioned how you could test your serialisation layer if you're using Jackson.

One of the [learnings from running Java AWS Lambdas](/posts/2021/11/17/java-serverless-learnings/) is that using [Gson](https://github.com/google/gson) is a good choice, albeit a bit slower than [Moshi](https://github.com/square/moshi).

Because this is a pretty integral part of interacting with other services / being interacted with, we need to make sure these models are mapped correctly.

Testing these can be done in a few ways, but often I see them not being tested as low in the test pyramid as we can do.

Fortunately, there are a few options for how we can test that serialisation (from object to string) and deserialisation (from string to object) works.

For instance, let's say we have the class:

```java
package me.jvt.hacking.models;

import com.google.gson.annotations.SerializedName;

public class TokenGrantDto {
  @SerializedName("access_token")
  private String accessToken;
  @SerializedName("refresh_token")
  private String refreshToken;
  @SerializedName("expires_in")
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
package me.jvt.hacking.models;

import com.google.gson.Gson;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class TokenGrantDtoJsonTest {
  private static final Gson GSON = new Gson();

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

        asJson = GSON.toJson(dto);
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

Alternatively, we can use the underlying `JsonObject` and `JsonElement`s inside Gson to validate things more easily:

```java
package me.jvt.hacking.models;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class TokenGrantDtoJsonTest {
  private static final Gson GSON = new Gson();

  @Nested
  class Serialization {
    @Nested
    class HappyPath {

      private JsonObject asJson;

      @BeforeEach
      void setup() {
        TokenGrantDto dto = new TokenGrantDto();
        dto.setAccessToken("j.w.t");
        dto.setRefreshToken("r.j.w.t");
        dto.setScope("foo bar");
        dto.setExpiresIn(123L);

        asJson = JsonParser.parseString(GSON.toJson(dto)).getAsJsonObject();
      }

      @Test
      void scopeIsMapped() {
        assertThat(asJson.get("scope").getAsString()).isEqualTo("foo bar");
      }

      @Test
      void expiresInIsMapped() {
        assertThat(asJson.get("expires_in").getAsLong()).isEqualTo(123);
      }

      @Test
      void accessTokenIsMapped() {
        assertThat(asJson.get("access_token").getAsString()).isEqualTo("j.w.t");
      }

      @Test
      void refreshTokenIsMapped() {
        assertThat(asJson.get("refresh_token").getAsString()).isEqualTo("r.j.w.t");
      }
    }
  }
}
```

This gives us a pretty handy test harness, and we don't need to manage JSON strings, as well as having a bit more control over checking whether fields are absent:

```java
@Test
void isNotSerialised() {
  assertThat(asJson.has("scope")).isFalse();
}
```
