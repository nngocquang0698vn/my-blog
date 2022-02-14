---
title: "How to Create and Unit Test Java Bean Validation Annotations"
description: "A guided example through what the different type of annotation `ElementType`s are, with respect to Bean Validation, and how to write unit tests for them."
tags:
- blogumentation
- java
- bean-validation
- testing
- tdd
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-23T10:24:30+0000
slug: "java-bean-validation"
image: https://media.jvt.me/7e70383567.png
---
Aside: I was originally going to name this article something fun like "fantastic beans and how to verify them", but couldn't find a good way of phrasing it that made sense.

While building [`uuid`, a library for UUID validation in Java](https://www.jvt.me/posts/2022/01/14/java-uuid-library/), I wanted to provide annotation-based validation for whether a String matched a UUID regular expression. Naturally, a good choice for this is using the Java Bean Validation standard.

I've done a little of this before, but one thing that I'd not really thought too much about was what the different options in `@Target`'s `ElementType` actually meant:

```java
@Target({
  ElementType.TYPE_USE,
  ElementType.ANNOTATION_TYPE,
  ElementType.PARAMETER,
  ElementType.FIELD
})
```

I found that [this StackOverflow answer on _What do Java annotation ElementType constants mean?_](https://stackoverflow.com/a/3550377/2257038) was super helpful, but there was still a jump from understanding how to use them, and the crux of the matter, which was "how do I use test-driven development and write tests for these annotations."

This article documents my understanding of the annotations' options, how we can use them, and most importantly how we can unit (integration) test them.

This article has a corresponding [sample project on GitLab](https://gitlab.com/jamietanna/bean-validation-tdd), and uses both `javax-validation` and `jakarta-validation` packages.

For each of the examples below, we will assume we have the `ValidData` annotation:

```java
import java.lang.annotation.*;
import javax.validation.Constraint;
import javax.validation.Payload;

@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({
 // ...
})
@Constraint(validatedBy = DataClassValidator.class)
public @interface ValidData {

  String message() default "The DataClass was not validated correctly";

  Class<?>[] groups() default {};

  Class<? extends Payload>[] payload() default {};
}
```

Which validates the `DataClass`:

```java
public class DataClass {
  private String nonNullValue;

  public DataClass() {}

  public DataClass(String nonNullValue) {
    this.nonNullValue = nonNullValue;
  }

  public String getNonNullValue() {
    return nonNullValue;
  }

  public void setNonNullValue(String nonNullValue) {
    this.nonNullValue = nonNullValue;
  }
}
```

Using the following `DataClassValidator`:

```java
import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class DataClassValidator implements ConstraintValidator<ValidData, DataClass> {
  @Override
  public boolean isValid(DataClass value, ConstraintValidatorContext context) {
    return value.getNonNullValue() != null;
  }
}
```

And the following test class setup:

```java
class ValidDataTest {
  private final Validator validator = Validation.buildDefaultValidatorFactory().getValidator();
  private final ExecutableValidator executableValidator = validator.forExecutables();

  @Nested
  // ...

  /**
   * Helper method for working with {@link Set>}s, as there's no i.e. <code>.get(0)</code>.
   *
   * @param set the set
   * @return the first element
   */
  private ConstraintViolation<Object> first(Set<ConstraintViolation<Object>> set) {
    return set.iterator().next();
  }
}
```

## `TYPE`

### What is it?

`Element.TYPE` annotations are for annotations which can be added to the top-level of a Java `class`/`enum`/`record`/`interface`, for instance:

```java
@ValidData
public class DataClass {}

@ValidData
public interface DataInterface {}

@ValidData
public enum DataEnum {}

@ValidData
public record DataRecord() {}
```

### How do we use + test it?

On our annotation, we target `TYPE`:

```java
@Target({ElementType.TYPE})
```

Then, we can annotate i.e. a class:

```java
@ValidData
public class DataClass {}
```

To test it we can trigger `Validator#validate`:

```java
@Nested
class TYPE_Validation {

  @Nested
  class WhenInvalid {
    @Test
    void hasViolation() {
      DataClass dataClass = new DataClass();

      Set<ConstraintViolation<Object>> violations = validate(validator, dataClass);

      assertThat(violations).hasSize(1);
    }

    @Test
    void hasMessage() {
      DataClass dataClass = new DataClass();

      Set<ConstraintViolation<Object>> violations = validate(validator, dataClass);

      assertThat(first(violations).getMessage())
          .isEqualTo("The DataClass was not validated correctly");
    }
  }

  @Nested
  class WhenValid {
    @Test
    void doesNotHaveViolations() {
      DataClass dataClass = new DataClass();
      dataClass.setNonNullValue("non-null");

      Set<ConstraintViolation<Object>> violations = validate(validator, dataClass);

      assertThat(violations).isEmpty();
    }
  }

  private Set<ConstraintViolation<Object>> validate(Validator validator, DataClass dataClass) {
    Set<ConstraintViolation<Object>> violations = validator.validate(dataClass);
    return violations;
  }
}

```

## `FIELD`

### What is it?

`ElementType.FIELD` validation allows us to validate that a field in a class is set correctly.

This is likely to be useful when allowing the field to be `@Autowired` by Spring, but has other use cases, too.

### How do we use + test it?

On our annotation, we target `FIELD`:

```java
@Target({
  ElementType.FIELD
})
```

Then, in a class that utilises the `DataClass`, we can then annotate the field with `@ValidData`:

```java
class ClassWithField {
  @ValidData private DataClass dataClass;
}
```

To test it we can trigger `Validator#validate`:

```java
@Nested
class FIELD_Validation {

  @Nested
  class WhenInvalid {
    @Test
    void hasViolation() {
      ClassWithField classWithField = new ClassWithField();
      classWithField.dataClass = new DataClass();

      Set<ConstraintViolation<Object>> violations = validate(classWithField);

      assertThat(violations).hasSize(1);
    }

    @Test
    void hasMessage() {
      ClassWithField classWithField = new ClassWithField();
      classWithField.dataClass = new DataClass();

      Set<ConstraintViolation<Object>> violations = validate(classWithField);

      assertThat(first(violations).getMessage())
          .isEqualTo("The DataClass was not validated correctly");
    }
  }

  @Nested
  class WhenValid {
    @Test
    void doesNotHaveViolations() {
      ClassWithField classWithField = new ClassWithField();
      classWithField.dataClass = new DataClass();
      classWithField.dataClass.setNonNullValue("non-null");

      Set<ConstraintViolation<Object>> violations = validate(classWithField);

      assertThat(violations).isEmpty();
    }
  }

  private Set<ConstraintViolation<Object>> validate(ClassWithField classWithField) {
    return validator.validate(classWithField);
  }

  class ClassWithField {
    @ValidData private DataClass dataClass;
  }
}
```

## `METHOD`

### What is it?

`ElementType.METHOD` is used to validate that the return value from a given method is deemed valid.

### How do we use + test it?

Let's say that we have the following method:

```java
@ValidData
public DataClass methodToCheck() {
  return null;
}

// alternatively
public @ValidData DataClass methodToCheck() {
  return null;
}
```

To test it, we need to use `ExecutableValidator#validateReturnValue`, which requires we use Reflection to get access to the method we're testing with, like so:

```java
@Nested
class METHOD_Validation {
  @Nested
  class WhenInvalid {
    @Test
    void hasViolation() {
      DataClass dataClass = new DataClass();

      Set<ConstraintViolation<Object>> violations = validate(dataClass);

      assertThat(violations).hasSize(1);
    }

    @Test
    void hasMessage() {
      DataClass dataClass = new DataClass();

      Set<ConstraintViolation<Object>> violations = validate(dataClass);

      assertThat(first(violations).getMessage())
          .isEqualTo("The DataClass was not validated correctly");
    }
  }

  @Nested
  class WhenValid {
    @Test
    void doesNotHaveViolations() {
      DataClass dataClass = new DataClass();
      dataClass.setNonNullValue("non-null");

      Set<ConstraintViolation<Object>> violations = validate(dataClass);

      assertThat(violations).isEmpty();
    }
  }

  private Set<ConstraintViolation<Object>> validate(DataClass dataClass) {
    Method method;
    try {
      method = getClass().getMethod("methodToCheck");
    } catch (NoSuchMethodException e) {
      throw new IllegalStateException("Could not find Method", e);
    }
    return executableValidator.validateReturnValue(this, method, dataClass);
  }

  @ValidData
  public DataClass methodToCheck() {
    return null; // in this example, it only needs to have the right type signature
  }
}
```

## `PARAMETER`

### What is it?

`ElementType.PARAMETER` is used to validate that objects passed into a method are valid, and can be used with both constructors and methods.

### How do we use + test it?

On our annotation, we target `PARAMETER`:

```java
@Target({
  ElementType.PARAMETER
})
```

Then, we can annotate methods, such as the below:

```java
public void methodToCheck(@ValidData DataClass clazz) {}
```

Or also in a constructor:

```java
class Another {
  public Another(@ValidData DataClass data) {}
}
```

To test it, we need to use `ExecutableValidator#validateParameters`, which requires we use Reflection to get access to the method we're testing with, like so:

```java
@Nested
class PARAMETER_Validation {
  @Nested
  class WhenInvalid {
    @Test
    void hasViolation() {
      DataClass dataClass = new DataClass();

      Set<ConstraintViolation<Object>> violations = validate(dataClass);

      assertThat(violations).hasSize(1);
    }

    @Test
    void hasMessage() {
      DataClass dataClass = new DataClass();

      Set<ConstraintViolation<Object>> violations = validate(dataClass);

      assertThat(first(violations).getMessage())
          .isEqualTo("The DataClass was not validated correctly");
    }
  }

  @Nested
  class WhenValid {
    @Test
    void doesNotHaveViolations() {
      DataClass dataClass = new DataClass();
      dataClass.setNonNullValue("non-null");

      Set<ConstraintViolation<Object>> violations = validate(dataClass);

      assertThat(violations).isEmpty();
    }
  }

  private Set<ConstraintViolation<Object>> validate(DataClass dataClass) {
    Method method;
    try {
      method = getClass().getMethod("methodToCheck", DataClass.class);
    } catch (NoSuchMethodException e) {
      throw new IllegalStateException("Could not find Method", e);
    }
    Object[] params = {dataClass};
    return executableValidator.validateParameters(this, method, params);
  }

  /**
   * Only required to have the right type signature.
   *
   * @param clazz the class that needs to be validated by the annotation
   */
  public void methodToCheck(@ValidData DataClass clazz) {}
}
```

## `CONSTRUCTOR`

### What is it?

`ElementType.CONSTRUCTOR` is used to validate that an object constructed via a constructor is deemed valid.

### How do we use + test it?

On our annotation, we target `CONSTRUCTOR`:

```java
@Target({
  ElementType.CONSTRUCTOR
})
```

Then, we annotate the method with `@ValidData`:

```java
@ValidData
public DataClass() {}

@ValidData
public DataClass(String nonNullValue) {
  this.nonNullValue = nonNullValue;
}
```

To test it we can trigger `ExecutableValidator#validateConstructorReturnValue`:

```java
@Nested
class CONSTRUCTOR_Validation {
  @Nested
  class ZeroArgsConstructor {
    /**
     * Can only ever be invalid, as there's no way to set it as valid on the zero-args
     * constructor.
     */
    @Nested
    class WhenInvalid {
      @Test
      void hasViolation() {
        Set<ConstraintViolation<Object>> violations = validate();

        assertThat(violations).hasSize(1);
      }

      @Test
      void hasMessage() {
        Set<ConstraintViolation<Object>> violations = validate();

        assertThat(first(violations).getMessage())
            .isEqualTo("The DataClass was not validated correctly");
      }
    }
  }

  @Nested
  class OneArgConstructor {
    @Nested
    class WhenInvalid {
      @Test
      void hasViolation() {
        Set<ConstraintViolation<Object>> violations = validate();

        assertThat(violations).hasSize(1);
      }

      @Test
      void hasMessage() {
        Set<ConstraintViolation<Object>> violations = validate();

        assertThat(first(violations).getMessage())
            .isEqualTo("The DataClass was not validated correctly");
      }
    }

    @Nested
    class WhenValid {
      @Test
      void doesNotHaveViolations() {
        DataClass dataClass = new DataClass("not-null");

        Set<ConstraintViolation<Object>> violations = validate(dataClass);

        assertThat(violations).isEmpty();
      }
    }
  }

  private Set<ConstraintViolation<Object>> validate() {
    return validate(new DataClass());
  }

  private Set<ConstraintViolation<Object>> validate(DataClass created) {
    Constructor<DataClass> constructor;
    try {
      constructor = DataClass.class.getConstructor(String.class);
    } catch (NoSuchMethodException e) {
      throw new IllegalStateException("Could not find Constructor", e);
    }

    return executableValidator.validateConstructorReturnValue(constructor, created);
  }
}
```

## `LOCAL_VARIABLE`

### What is it?

`ElementType.LOCAL_VARIABLE` is used to validate that a local variable is deemed valid.

Note that this can only be used at compile-time.

### How do we use + test it?

I've not played around with testing this, as it's not something we can use for runtime, but we're able to get one set up up like so:

```java
@NotNull
@Documented
@Retention(RetentionPolicy.SOURCE)
@Target({
        ElementType.LOCAL_VARIABLE
})
@Constraint(validatedBy = {})
public @interface ValidString {
  String message() default "Was not valid";

  Class<?>[] groups() default {};

  Class<? extends Payload>[] payload() default {};
}
```

And then we can use it when declaring local variables:

```java
public void localMethod() {
  @ValidString String uuid;
}
```

## `ANNOTATION_TYPE`

### What is it?

The `ElementType.ANNOTATION_TYPE` is for the case that we've got an annotation that we want to make composable with other annotations.

For instance, you may want to have an annotation such as `@ValidPostCode` that checks the postcode is `@NotNull` and `@NotBlank` as well as performing a `@Pattern`. In this case, `@NotNull`, `@NotBlank` and `@Pattern` will need to be targeting `ElementType.ANNOTATION_TYPE`.

### How do we use + test it?

On our annotation, we target `ANNOTATION_TYPE`:

```java
@Target({ElementType.ANNOTATION_TYPE})
```

Then, we can annotate another annotation with `ValidData`:

```java
@ValidData
@Target({ElementType.ANNOTATION_TYPE, ElementType.PARAMETER, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = {})
@Documented
private @interface MetaAnnotation {
  String message() default "This isn't used, as the @ValidData gets triggered instead";

  Class<?>[] groups() default {};

  Class<? extends Payload>[] payload() default {};
}
```

And then use this `MetaAnnotation`:

```java
private class ClassWithMetaAnnotation {
  @MetaAnnotation DataClass dataClass = new DataClass();
}
```

To test it we can trigger `Validator#validate`:

```java
@Nested
class ANNOTATION_TYPE_Validation {
  @Nested
  class WhenInvalid {
    @Test
    void hasViolation() {
      ClassWithMetaAnnotation clazz = new ClassWithMetaAnnotation();

      Set<ConstraintViolation<Object>> violations = validate(clazz);

      assertThat(violations).hasSize(1);
    }

    @Test
    void hasMessage() {
      ClassWithMetaAnnotation clazz = new ClassWithMetaAnnotation();

      Set<ConstraintViolation<Object>> violations = validate(clazz);

      assertThat(first(violations).getMessage())
          .isEqualTo("The DataClass was not validated correctly");
    }
  }

  @Nested
  class WhenValid {
    @Test
    void doesNotHaveViolations() {
      ClassWithMetaAnnotation clazz = new ClassWithMetaAnnotation();
      clazz.dataClass = new DataClass();
      clazz.dataClass.setNonNullValue("non-null");

      Set<ConstraintViolation<Object>> violations = validate(clazz);

      assertThat(violations).isEmpty();
    }
  }

  private Set<ConstraintViolation<Object>> validate(ClassWithMetaAnnotation clazz) {
    return validator.validate(clazz);
  }

  private class ClassWithMetaAnnotation {
    @MetaAnnotation DataClass dataClass = new DataClass();
  }
}

@ValidData
@Target({ElementType.ANNOTATION_TYPE, ElementType.PARAMETER, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = {})
@Documented
private @interface MetaAnnotation {
  String message() default "This isn't used, as the @ValidData gets triggered instead";

  Class<?>[] groups() default {};

  Class<? extends Payload>[] payload() default {};
}
```

## `PACKAGE`

### What is it?

`ElementType.PACKAGE` is used to annotate a package, but is not possible to use for validation.

### How do we use + test it?

This isn't possible to use for validation.

On our annotation, we target `PACKAGE`:

```java
@Target({ElementType.PACKAGE})
```

And then if we want to annotate the package `me.jvt.hacking.annotations`, we'd create the file `src/main/java/me/jvt/hacking/annotations/package-info.java` like so:

```java
@ValidData
package me.jvt.hacking.annotations;

import me.jvt.hacking.ValidData;
```

## `TYPE_PARAMETER`

### What is it?

`ElementType.TYPE_PARAMETER` allows us to annotate the use of a parameterised type, such as when declaring a generic class.

It doesn't appear to be usable for validation.

### How do we use + test it?

On our annotation, we target `TYPE_PARAMETER`:

```java
@Target({ElementType.TYPE_PARAMETER})
```

Then, we can annotate the use of a generic with the annotation:

```java
@Target({ElementType.TYPE_PARAMETER})
```

Then, we could add our annotation to a generic method/class:

```java
public <@Entity T extends DataClass> void methodToCheck(T t) {}

class ParameterisedTypeClass<@Entity T extends DataClass> {
  private final T t;

  public ParameterisedTypeClass(T t) {
    this.t = t;
  }

  T get() {
    return t;
  }
}
```

## `TYPE_USE`

### What is it?

`ElementType.TYPE_USE` allows us to annotate any use of a type, which overlaps with other annotation types, but also includes the ability to annotate when casting variables, or when using generics in parameterised types.

### How do we use + test it?

On our annotation, we target `TYPE_USE`:

```java
@Target({ElementType.TYPE_USE})
```

Then, we can annotate the use of a generic with the annotation:

```java
private class ClassWithContainer {
  private List<@ValidData DataClass> dataClasses;
}
```

To test it we can trigger `Validator#validate`:

```java @Nested
class TYPE_USE_Validation {

  @Nested
  class WhenInvalid {
    @Test
    void hasViolation() {
      ClassWithContainer clazz = new ClassWithContainer();
      DataClass dataClass = new DataClass();
      clazz.dataClasses = Collections.singletonList(dataClass);

      Set<ConstraintViolation<Object>> violations = validate(clazz);

      assertThat(violations).hasSize(1);
    }

    @Test
    void hasMessage() {
      ClassWithContainer clazz = new ClassWithContainer();
      DataClass dataClass = new DataClass();
      clazz.dataClasses = Collections.singletonList(dataClass);

      Set<ConstraintViolation<Object>> violations = validate(clazz);

      assertThat(first(violations).getMessage())
          .isEqualTo("The DataClass was not validated correctly");
    }
  }

  @Nested
  class WhenValid {
    @Test
    void doesNotHaveViolations() {
      ClassWithContainer clazz = new ClassWithContainer();
      DataClass dataClass = new DataClass();
      dataClass.setNonNullValue("No nulls here");
      clazz.dataClasses = Collections.singletonList(dataClass);

      Set<ConstraintViolation<Object>> violations = validate(clazz);

      assertThat(violations).isEmpty();
    }
  }

  private Set<ConstraintViolation<Object>> validate(ClassWithContainer clazz) {
    return validator.validate(clazz);
  }

  private class ClassWithContainer {
    private List<@ValidData DataClass> dataClasses;
  }
}
```

## `MODULE`

### What is it?

`ElementType.MODULE` is used to annotate a module, but is not possible to use for validation.

### How do we use + test it?

This isn't possible to use for validation.

On our annotation, we target `MODULE`:

```java
@Target({ElementType.MODULE})
```

And then if we want to annotate the package `me.jvt.hacking`, we'd create the file `src/main/java/me/jvt/hacking/module-info.java` like so:

```java
import me.jvt.hacking.ValidData;

@ValidData
module bean.validation.tdd.javax.main {
}
```

## `RECORD_COMPONENT`

### What is it?

`ElementType.RECORD_COMPONENT` is used to validate that individual components in the record, that is, each variable that is passed into our `record`, are deemed valid.

### How do we use + test it?

On our annotation, we target `RECORD_COMPONENT` _and_ `PARAMETER` (this is important both are added, otherwise validation won't be triggered):

```java
@Target({ElementType.RECORD_COMPONENT, ElementType.PARAMETER})
```

Then, we can annotate the components (parameters passed to the constructor):

```java
public record RecordDataClass(@ValidId String id) {}
```

To test it we can trigger `ExecutableValidator#validateConstructorParameters`:

```java
@Nested
class RECORD_COMPONENT_Validation {

  @Nested
  class WhenInvalid {
    @Test
    void hasViolation() {
      Set<ConstraintViolation<Object>> violations = validate(null);

      assertThat(violations).hasSize(1);
    }

    @Test
    void hasMessage() {
      Set<ConstraintViolation<Object>> violations = validate(null);

      assertThat(first(violations).getMessage()).isEqualTo("The ID should be non-null");
    }
  }

  @Nested
  class WhenValid {
    @Test
    void doesNotHaveViolations() {
      Set<ConstraintViolation<Object>> violations = validate("foo");

      assertThat(violations).isEmpty();
    }
  }

  @NotNull
  @Target({ElementType.RECORD_COMPONENT, ElementType.PARAMETER})
  @Retention(RetentionPolicy.RUNTIME)
  @Constraint(validatedBy = {})
  @ReportAsSingleViolation
  @Documented
  @interface ValidId {
    String message() default "The ID should be non-null";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
  }

  public record RecordDataClass(@ValidId String id) {}

  private Set<ConstraintViolation<Object>> validate(String id) {
    Constructor<RecordDataClass> constructor;
    try {
      // or `.getDeclaredConstructor` if `private`/package-private `record` class
      constructor = RecordDataClass.class.getConstructor(String.class);
    } catch (NoSuchMethodException e) {
      throw new IllegalStateException("Could not find Constructor", e);
    }

    Object[] args = {id};
    return executableValidator.validateConstructorParameters(constructor, args);
  }
}

```

### How do we use + test it?

# Other notes

I've found that, while writing UUID that I'd recommend [writing abstract tests](/posts/2021/08/11/abstract-test-class/) as there's a lot of duplicated code, and often the most that's duplicated is the actual setup / means to verify the data class under test.
