---
title: "Gotcha: PicoContainer requires Zero-Argument Constructors"
description: "A little gotcha around using PicoContainer (with Cucumber) where it\
  \ may not be usable unless you have zero-arg constructors."
date: "2021-12-30T21:01:52+0000"
tags:
- "blogumentation"
- "java"
- "cucumber"
- "picocontainer"
license_code: "MIT"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/be422b5aa6.png
slug: "cucumber-picocontainer-gotcha"
---
At the time of writing, Cucumber (7.1.0) still recommends using PicoContainer as the default dependency injection framework.

Although this works for a lot of cases that folks are building for, there is unfortunately a big gotcha that I've hit a few times, and have since avoided using PicoContainer due to this problem.

Let us say that we're following a common practice of using constructor injection for objects, such as the below code snippet:

```java
package io.cucumber.skeleton;

import io.cucumber.java.en.Given;

public class StepDefinitions {

    private final Belly belly;

    public StepDefinitions(Belly belly) {
        this.belly = belly;
    }

    @Given("I have {int} cukes in my belly")
    public void I_have_cukes_in_my_belly(int cukes) {
        belly.eat(cukes);
    }
}
```

And the following `Belly` class definition:

```java
package io.cucumber.skeleton;

public class Belly {
    public void eat(int cukes) {

    }
}
```

(Example code can be found [on a branch on GitLab](https://gitlab.com/jamietanna/cucumber-dagger/-/blob/defect/picocontainer/src/test/java/io/cucumber/skeleton/StepDefinitions.java))

This works absolutely fine, as our `Belly` class can be instantiated with the implicit zero-args constructor that Java provides.

However, if we make our `Belly` class require some configuration via the constructor, such as:

```diff
 package io.cucumber.skeleton;

 public class Belly {
+
+    public Belly(int initial) {
+        // TODO: something with initial
+    }
+
     public void eat(int cukes) {

     }
 }
```

We notice that running this leads to the following error when executing the tests:

```
RunCucumberTest > Cucumber > Belly > io.cucumber.skeleton.RunCucumberTest.Belly - a few cukes STANDARD_OUT

    Scenario: a few cukes               # io/cucumber/skeleton/belly.feature:3
      Given I have 42 cukes in my belly # io.cucumber.skeleton.StepDefinitions.I_have_cukes_in_my_belly(int)
          org.picocontainer.injectors.AbstractInjector$UnsatisfiableDependenciesException: io.cucumber.skeleton.Belly has
            unsatisfied dependency 'class java.lang.Integer' for constructor
            'public io.cucumber.skeleton.Belly(int)' from org.picocontainer.DefaultPicoContainer@2f05be7f:2<|
```

Unfortunately, PicoContainer's reliance on a zero-args constructor has been broken, which means we can no longer use this class.

It may not be so much of a problem if we've written all the code we're injecting, so can add convenience zero-args constructors with default implementations, but it's very unlikely to be the case that we're not using any dependencies.

Yes, we could create i.e. a `Config` object that provides a container for the dependencies, but this then results in not-great dependency injection, and means we're sidestepping good dependency injection for the case of our library.

A common solution to this is to create default wrapper objects for each of our classes, i.e. a `BellyWrapper` which produces a zero-args contructor.

If you hit this, I recommend looking at the other options, such as [those called out in the Cucumber docs for _Sharing state between steps_](https://cucumber.io/docs/cucumber/state/), or my article on using [_Using Dagger for Dependency Injection with Cucumber Tests_](/posts/2021/12/30/cucumber-dagger-dependency-injection/).

See also [discussion on the Cucumber issue tracker](https://github.com/cucumber/cucumber-jvm/issues/2449).
