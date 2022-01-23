---
title: "How to Manually Trigger JSR380 Bean Validation on a Class"
description: "How to perform validation on a class using JSR380, when not using a framework like Spring Boot."
tags:
- blogumentation
- java
- jsr380
- bean-validation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-08-06T10:47:39+0100
slug: "trigger-jsr380-manually"
---
The [JSR380](https://jcp.org/en/jsr/detail?id=380) standard is a great way of validating your beans in Java.

But if you're not using something like Spring Boot to orchestrate it happening automagically, it can seem a little difficult to apply it manually.

**Update 2022-01-23**: You may want to read [_How to Create and Unit Test Java Bean Validation Annotations_](/posts/2022/01/23/java-bean-validation/) which covers this in more depth.

# Existing Code

To set the picture, let's say that we have the following classes that provide the basis for our application, and how we want to validate it.

We have the overarching interface for our classes, `TypeToValidate`:

```java
package example;

@ValidField
public interface TypeToValidate {
  String getField();
}

```

We then have a concrete implementation which returns a hardcoded value:

```java
package example;

public class ObjectToValidate implements TypeToValidate {
  @Override
  public String getField() {
    return "not-correct";
  }
}
```

We can provide our annotation, `@ValidField`:

```java
package example;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import javax.validation.Constraint;
import javax.validation.Payload;

@Documented
@Constraint(validatedBy = ValidFieldValidator.class)
@Target(ElementType.TYPE) // allows us to annotate the interface/class itself
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidField {
  String message() default "The field didn't validate correctly";

  Class<?>[] groups() default {};

  Class<? extends Payload>[] payload() default {};
}
```

And the associated `ValidFieldValidator`:

```java
package example;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class ValidFieldValidator implements ConstraintValidator<ValidField, TypeToValidate> {
  public void initialize(ValidField constraint) {}

  public boolean isValid(TypeToValidate obj, ConstraintValidatorContext context) {
    return obj.getField().equals("correct");
  }
}
```

# Manually Triggering Validation

So we can actually perform the validation, we need to retrieve a `Validator`, and then we can trigger it on the concrete implementation of the class:

```java
package example;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;

import java.util.Set;
import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import org.junit.jupiter.api.Test;

class ValidFieldValidatorTest {
  @Test
  void itReturnsConstraintViolations() {
    Validator javaxValidator = Validation.buildDefaultValidatorFactory().getValidator();

    Set<ConstraintViolation<TypeToValidate>> e = javaxValidator.validate(new ObjectToValidate());
    assertThat(e.size()).isEqualTo(1);
    System.err.println(e);
  }
}
```

This then rightfully rejects it, as the field has failed its validation, and we receive a set of `ConstraintViolation`s:

```
[ConstraintViolationImpl{interpolatedMessage='The field didn't validate correctly', propertyPath=, rootBeanClass=class example.ObjectToValidate, messageTemplate='The field didn't validate correctly'}]
```
