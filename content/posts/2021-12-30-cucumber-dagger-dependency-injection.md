---
title: "Using Dagger for Dependency Injection with Cucumber Tests"
description: "How and why to add Dagger for your Cucumber tests' dependency injection."
date: 2021-12-30T21:01:52+0000
tags:
- "blogumentation"
- "java"
- "cucumber"
- "dagger"
license_code: "MIT"
license_prose: "CC-BY-NC-SA-4.0"
slug: "cucumber-dagger-dependency-injection"
---
# Why Dependency Injection?

Cucumber is a great framework for building test automation tools with [human-readable language](/www.jvt.me/posts/2021/08/24/human-readable-gherkin/) and I've used it a fair bit in previous years with Java projects.

One thing you will eventually start to feel is the need for a good dependency injection framework, otherwise your code will be littered with re-creating the same objects to use them, or using things like `ThreadLocal` or `static`s to share state, which isn't ideal.

At the time of writing, Cucumber (7.1.0) still recommends using PicoContainer as the default dependency injection framework, and it's been blogged about a fair bit before, such as the wonderful <span class="h-card"><a class="u-url" href="https://angiejones.tech/">Angie Jones</a></span>' blog post [_Sharing State Between Cucumber Steps with Dependency Injection_](https://angiejones.tech/sharing-state-between-steps-in-cucumber-with-dependency-injection/).

However as [I've blogged about](/posts/2021/12/30/cucumber-picocontainer-gotcha/), PicoContainer isn't ideal because it requires zero-args constructors, which isn't always possible.

# Why Dagger?

although there are other dependency injection frameworks [called out in the Cucumber docs for _Sharing state between steps_](https://cucumber.io/docs/cucumber/state/), I instead recommend [Dagger](https://dagger.dev). As noted in [_Lightweight and Powerful Dependency Injection for JVM-based Applications with Dagger_](/posts/2021/10/19/dagger-java-lambda/), Dagger is a great, super lightweight framework that works really nicely, and is fairly easy to get set up in a project.

I'd very much recommend a read of that post for a bit more about why Dagger is great, and we'll discuss at the end of the post why you may not see it very often.

If you're comfortable with using Spring as your dependency injection framework, especially if using Spring Boot, I'd recommend continuing with it so we don't have to maintain two styles of dependency injection setup.

# Base setup

Example code can be found [on a branch on GitLab](https://gitlab.com/jamietanna/cucumber-dagger/).

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

# Migrating to Dagger

To be able to migrate to Dagger, we'd follow a similar setup as mentioned in my previous Dagger article, which is to set up the dependencies (in this example for Gradle, when running Cucumber tests from `src/test/resources`):

```diff
 dependencies {
+    testAnnotationProcessor("com.google.dagger:dagger-compiler:2.40.5")
+    testImplementation("com.google.dagger:dagger:2.40.5")
     testImplementation(platform("org.junit:junit-bom:5.8.2"))
     testImplementation(platform("io.cucumber:cucumber-bom:7.1.0"))

     testImplementation("io.cucumber:cucumber-java")
-    testImplementation("io.cucumber:cucumber-picocontainer")
     testImplementation("io.cucumber:cucumber-junit-platform-engine")
     testImplementation("org.junit.platform:junit-platform-suite")
     testImplementation("org.junit.jupiter:junit-jupiter")

```

Then we'd set up a `Config` class that would define which of the objects to be injected:

```java
package io.cucumber.skeleton.config;

import dagger.Component;
import io.cucumber.skeleton.Belly;

import javax.inject.Singleton;

@Singleton
@Component(modules = {ConfigModule.class})
public interface Config {
    Belly belly();
}
```

Which are produced by the configuration module:

```java
import dagger.Module;
import dagger.Provides;
import io.cucumber.skeleton.Belly;

import javax.inject.Singleton;

@Module
public class ConfigModule {

    private ConfigModule() {
        throw new UnsupportedOperationException("Utility class");
    }

    @Provides
    @Singleton
    public static Belly belly() {
        return new Belly();
    }
}
```

Which we need to modify the `StepDefinitions`, to utilise the new Dagger-built configuration:

```diff
 package io.cucumber.skeleton;

 import io.cucumber.java.en.Given;
+import io.cucumber.skeleton.config.DaggerConfig;

 public class StepDefinitions {

     private final Belly belly;

-    public StepDefinitions(Belly belly) {
-        this.belly = belly;
+    public StepDefinitions() {
+        this.belly = DaggerConfig.create().belly();
     }

     @Given("I have {int} cukes in my belly")
```

## Allowing step definition classes to be unit testable

Notice that this has resulted in us using zero-args constructor in the step definitions - unless we're [unit testing our steps](/posts/2018/11/07/unit-test-functional-tests/) this will be fine, and if we are, we can provide a test-only constructor to inject in mock configuration:

```java
package io.cucumber.skeleton;

import io.cucumber.java.en.Given;
import io.cucumber.skeleton.config.Config;
import io.cucumber.skeleton.config.DaggerConfig;

public class StepDefinitions {

    private final Belly belly;

    public StepDefinitions() {
        this(DaggerConfig.create());
    }

    StepDefinitions(Config config) {
        this.belly = config.belly();
    }

    @Given("I have {int} cukes in my belly")
    public void I_have_cukes_in_my_belly(int cukes) {
        belly.eat(cukes);
    }
}
```

## Configurability

As mentioned in [_Lightweight and Powerful Dependency Injection for JVM-based Applications with Dagger_](/posts/2021/10/19/dagger-java-lambda/#improved-handling-of-configuration), this can be improved by adding in a `Builder` that can then take environment specific configuration, allowing you to i.e. set up your tests to run differently against different environments.

# Caveats

Notice that there's no first-class support in Cucumber's dependency tree - this is because Dagger configuration is very personal to the project, so there's no out-of-the-box way to do it.

I'm going to [look at working with others on the Cucumber team](https://github.com/cucumber/cucumber-jvm/issues/2448) to see if there's a way we can do this, and even if it's not first-class support, there may be a way we can produce a dependency that makes it easier to utilise.
