---
title: "Testing Data Serialisation/Deserialization in Java (with Jackson)"
description: "How to validate your JSON types correctly serialise/deserialise."
tags:
- java
- testing
- jackson
- blogumentation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-10-02T22:00:14+0100
slug: "testing-json"
series: writing-better-tests
image: https://media.jvt.me/7e70383567.png
---
When working with data models in Java, we'll often have a Plain Old Java Object (POJO) that corresponds to the incoming request body, so we can interact with it more easily and have access to getters/setters.

Because this is a pretty integral part of interacting with other services / being interacted with, we need to make sure these models are mapped correctly.

Testing these can be done in a few ways, but often I see them not being tested as low in the test pyramid as we can do.

Fortunately, there are a few options for how we can test that serialisation (from object to string) and deserialisation (from string to object) works.

For instance, let's say we have the class:

```java
/**
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.annotation.JsonProperty;

public class TokenGrantDto {

  @JsonProperty("access_token")
  @JsonInclude(Include.NON_NULL)
  private String accessToken;

  @JsonProperty("refresh_token")
  @JsonInclude(Include.NON_NULL)
  private String refreshToken;

  private long expiresIn;

  @JsonProperty("token_type")
  @JsonInclude(Include.NON_NULL)
  private String tokenType;

  @JsonInclude(Include.NON_NULL)
  private String scope;

  @JsonInclude(Include.NON_NULL)
  private String me;

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

  @JsonInclude(Include.NON_NULL)
  @JsonProperty("expires_in")
  public Long getExpiresIn() {
    if (0 == expiresIn) {
      return null;
    }
    return expiresIn;
  }

  public void setExpiresIn(long expiresIn) {
    this.expiresIn = expiresIn;
  }

  public String getTokenType() {
    return tokenType;
  }

  public void setTokenType(String tokenType) {
    this.tokenType = tokenType;
  }

  public String getScope() {
    return scope;
  }

  public void setScope(String scope) {
    this.scope = scope;
  }

  public String getMe() {
    return me;
  }

  public void setMe(String me) {
    this.me = me;
  }
}
```

This then may have a unit or unit integration test like the following, which uses Jackson's `ObjectMapper` to verify serialisation/deserialisation:

```java
/**
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

class TokenGrantDtoTest {
  private static final ObjectMapper mapper = new ObjectMapper();

  private ObjectNode node;
  @Nested
  class Serialization {
    @Nested
    class HappyPath {
      @BeforeEach
      void setup() throws JsonProcessingException {
        TokenGrantDto dto = new TokenGrantDto();
        dto.setAccessToken("j.w.t");
        dto.setRefreshToken("j.w.t.2");
        dto.setExpiresIn(1234L);
        dto.setMe("https://me");
        dto.setScope("draft update");
        dto.setTokenType("Bearer");

        String actual = mapper.writeValueAsString(dto);
        node = mapper.readValue(actual, ObjectNode.class);
      }

      @Test
      void accessTokenIsMapped() {
        assertThat(node.get("access_token").textValue()).isEqualTo("j.w.t");
      }

      // ommitted for brevity

      @Test
      void expiresInIsMapped() {
        assertThat(node.get("expires_in").numberValue()).isEqualTo(1234L);
      }
    }

    // ommitted for brevity

    @Nested
    class WhenMissingProperties {
      @BeforeEach
      void setup() throws JsonProcessingException {
        TokenGrantDto dto = new TokenGrantDto();

        String actual = mapper.writeValueAsString(dto);
        node = mapper.readValue(actual, ObjectNode.class);
      }

      @ParameterizedTest
      @ValueSource(strings = {"access_token", "expires_in", "me", "scope", "token_type"})
      void propertiesAreNotMapped(String property) {
        assertThat(node.get(property)).isNull();
      }
    }
  }
}
```

This gives us a pretty handy test harness!
