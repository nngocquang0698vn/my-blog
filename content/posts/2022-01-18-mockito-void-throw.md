---
title: "Mocking `void` methods with Mockito"
description: "How to Mock a `void` method with Mockito, for instance to throw an exception."
tags:
- blogumentation
- java
- mockito
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-18T15:28:31+0000
slug: "mockito-void-throw"
image: https://media.jvt.me/35891268eb.png
---
As with many other Java developers, I heavily utilise [Mockito](https://mockito.org/) as a mocking framework for unit testing.

Sometimes I'll end up needing to write a test case which wants to mock a `void`-returning method, for instance to throw an exception:

```java
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.AssertionsForClassTypes.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class DataClassValidatorTest {
  @Test
  void t(@Mock UnderTest sut) {
    when(sut.doTheThing()).thenThrow(new RuntimeException("foo"));

    assertThatThrownBy(sut::doTheThing).isInstanceOf(RuntimeException.class);
  }

  private static class UnderTest {
    public void doTheThing() {
      throw new RuntimeException("Expected");
    }
  }
}
```

Unfortunately this doesn't work, as we receive the following compilation error:

```
src/test/java/me/jvt/hacking/DataClassValidatorTest.java:24: error: 'void' type not allowed here
    Mockito.when(sut.doTheThing()).thenThrow(new RuntimeException("foo"));
```

And in IntelliJ, we we see the following cryptic error:

```
reason: no instance(s) of type variable(s) T exist so that void conforms to T
```

This is because Mockito can't mock a `void` as such, and instead we need to use `doThrow()`:

```diff
 import org.junit.jupiter.api.Test;
 import org.junit.jupiter.api.extension.ExtendWith;
 import org.mockito.Mock;
 import org.mockito.junit.jupiter.MockitoExtension;

 import static org.assertj.core.api.AssertionsForClassTypes.assertThatThrownBy;
-import static org.mockito.Mockito.when;
+import static org.mockito.Mockito.doThrow;

 @ExtendWith(MockitoExtension.class)
 class DataClassValidatorTest {
   @Test
   void t(@Mock UnderTest sut) {
-    when(sut.doTheThing()).thenThrow(new RuntimeException("foo"));
+    doThrow(new RuntimeException("foo")).when(sut).doTheThing();

     assertThatThrownBy(sut::doTheThing).isInstanceOf(RuntimeException.class);
   }

   private static class UnderTest {
     public void doTheThing() {
       throw new RuntimeException("Expected");
     }
   }
 }
```
