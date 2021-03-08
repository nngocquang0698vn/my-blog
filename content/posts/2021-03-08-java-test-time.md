---
title: "Testing Time with Java"
description: "How to make your Java tests better when dealing with `java.util.time`."
tags:
- blogumentation
- java
- testing
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-03-08T20:19:50+0000
slug: "java-test-time"
---
Working with date, time and timezones are probably one of the most difficult problems in software engineering. Dealing with leap years, Daylight Savings Time, and a whole host of other changes cause us difficulty, but why make things harder than it can be when it comes to testing?

Something I see a fair bit is folks spending a bit more effort trying to get their tests working, but not being flakey, and I thought I'd share a slightly better approach that's enabled through Java 8's `java.time` package, when applying Dependency Injection.

Let's go through an example of some code that doesn't test things so well, and we'll look at how we can improve it after:

# What You May Not Want to Do

Let's take the following straightforward class which creates a serialised JSON Web Token, with two dates associated with it:

```java
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.PlainJWT;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

public class JwtCreator {
  private final int days;

  public JwtCreator(int days) {
    this.days = days;
  }

  public String create() { // not expected to be production code!
    JWTClaimsSet claims = new JWTClaimsSet.Builder()
      .issueTime(Date.from(Instant.now()))
      .expirationTime(Date.from(Instant.now().plus(days, ChronoUnit.DAYS)))
      .build();
    return new PlainJWT(claims).serialize();
  }
}
```

We'd want to write at least the following tests to validate that these dates are formed correctly:

```java
import com.nimbusds.jwt.PlainJWT;
import org.junit.jupiter.api.Test;

import java.text.ParseException;
import java.time.Instant;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Date;

import static org.assertj.core.api.Assertions.assertThat;

class JwtCreatorTest {
  private final JwtCreator creator = new JwtCreator(5);

  @Test
  void itWasIssuedNow() throws ParseException {
    PlainJWT jwt = PlainJWT.parse(creator.create());

    assertThat(jwt.getJWTClaimsSet().getIssueTime())
      .isEqualTo(Date.from(Instant.now()));
  }

  @Test
  void itHasExpiryIn5Days() throws ParseException {
    PlainJWT jwt = PlainJWT.parse(creator.create());

    assertThat(jwt.getJWTClaimsSet().getExpirationTime())
      .isEqualTo(Date.from(Instant.now().plus(5, ChronoUnit.DAYS)));
  }
}
```

Unfortunately this doesn't work, because our `Instant.now()` calls in our tests execute after our `create()` call, so they don't match. We could modify our code to make sure that we i.e. ignore millisecond precision:

```java
@Test
void itWasIssuedNow() throws ParseException {
  PlainJWT jwt = PlainJWT.parse(creator.create());

  assertThat(jwt.getJWTClaimsSet().getIssueTime())
    .isInSameSecondAs(Date.from(Instant.now()));
}

@Test
void itHasExpiryIn5Days() throws ParseException {
  PlainJWT jwt = PlainJWT.parse(creator.create());

  assertThat(jwt.getJWTClaimsSet().getExpirationTime())
    .isInSameSecondAs(Date.from(Instant.now().plus(5, ChronoUnit.DAYS)));
}
```

This fixes the exact issue, but then we start hitting some flakiness in our tests, because depending on when the test executed, and how long things took to run, you may go over a second boundary, and have a failing test.

Instead, we could add a leeway in that allows some time difference between the test runs:

```java
private final long EXPIRY_DELTA = 1000 * 2;

@Test
void itWasIssuedNow() throws ParseException {
  PlainJWT jwt = PlainJWT.parse(creator.create());

  assertThat(jwt.getJWTClaimsSet().getIssueTime())
    .isCloseTo(Date.from(Instant.now()), EXPIRY_DELTA);
}

@Test
void itHasExpiryIn5Days() throws ParseException {
  PlainJWT jwt = PlainJWT.parse(creator.create());

  assertThat(jwt.getJWTClaimsSet().getExpirationTime())
    .isCloseTo(Date.from(Instant.now().plus(5, ChronoUnit.DAYS)), EXPIRY_DELTA);
}
```

However, this then has the risk that we're going to end up on a slower machine, and then tests may intermittently fail.

These are all leading to temporary solutions, and are taking away from how we'd commonly do this i.e. if we had a dependent class or static methods we didn't want to test in a unit test.

# Injecting a `Clock`

The best way of doing this is to inject a `java.time.Clock` into the class under test, as all the classes in `java.time` that we'd generally want to use provide an overloaded method with a `Clock` parameter to allow injection.

This allows our tests to be changed to have a shared `Clock`, and means we can now check they're equal to "now" at the time that we set up the test class:

```diff
 import com.nimbusds.jwt.PlainJWT;
 import org.junit.jupiter.api.Test;

 import java.text.ParseException;
+import java.time.Clock;
 import java.time.Instant;
 import java.time.ZoneId;
 import java.time.temporal.ChronoUnit;
 import java.util.Date;

 import static org.assertj.core.api.Assertions.assertThat;

 class JwtCreatorTest {
-  private final long EXPIRY_DELTA = 1000 * 2;
+  private static final Clock FIXED_CLOCK = Clock.fixed(Instant.now().truncatedTo(ChronoUnit.SECONDS), ZoneId.of("UTC"));
+  private static final Instant NOW = Instant.now(FIXED_CLOCK);
   private final JwtCreator creator = new JwtCreator(5, FIXED_CLOCK);

   @Test
@@ -18,7 +20,7 @@ class JwtCreatorTest {
     PlainJWT jwt = PlainJWT.parse(creator.create());

     assertThat(jwt.getJWTClaimsSet().getIssueTime())
-      .isCloseTo(Date.from(Instant.now()), EXPIRY_DELTA);
+      .isEqualTo(Date.from(NOW));
   }

   @Test
@@ -26,6 +28,7 @@ class JwtCreatorTest {
     PlainJWT jwt = PlainJWT.parse(creator.create());

     assertThat(jwt.getJWTClaimsSet().getExpirationTime())
-      .isCloseTo(Date.from(Instant.now().plus(5, ChronoUnit.DAYS)), EXPIRY_DELTA);
+      .isEqualTo(Date.from(NOW.plus(5, ChronoUnit.DAYS)));
   }
 }
```

We then need to update our class to allow injecting in a `Clock`, and then use it to source the date:

```diff
 import com.nimbusds.jwt.JWTClaimsSet;
 import com.nimbusds.jwt.PlainJWT;

+import java.time.Clock;
 import java.time.Instant;
 import java.time.temporal.ChronoUnit;
 import java.util.Date;

 public class JwtCreator {
+  private final Clock clock;
   private final int days;

-  public JwtCreator(int days) {
+  public JwtCreator(int days, Clock clock) {
     this.days = days;
+    this.clock = clock;
   }

   public String create() { // not expected to be production code!
     JWTClaimsSet claims = new JWTClaimsSet.Builder()
-      .issueTime(Date.from(Instant.now()))
-      .expirationTime(Date.from(Instant.now().plus(days, ChronoUnit.DAYS)))
+      .issueTime(Date.from(Instant.now(clock)))
+      .expirationTime(Date.from(Instant.now(clock).plus(days, ChronoUnit.DAYS)))
       .build();
     return new PlainJWT(claims).serialize();
   }
 }
```

We could make this a package-private test-only constructor, but I prefer having it as a required dependency for our class:

```java
public class JwtCreator {

  public JwtCreator(int days) {
    this.days = days;
    this.clock = Clock.systemUTC();
  }

  JwtCreator(int days, Clock clock) {
    this.days = days;
    this.clock = clock;
  }

  // ...
}
```
