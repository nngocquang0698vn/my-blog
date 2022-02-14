---
title: "Getting Started with jMolecules and the (Classical) Onion Architecture, with a Spring Boot project"
description: "A guided example of converting a Spring Boot project to the Onion Architecture pattern."
tags:
- blogumentation
- java
- architecture
- spring-boot
- onion-architecture
- jmolecules
- archunit
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-28T13:45:16+0000
slug: spring-boot-onion-architecture
image: https://media.jvt.me/9e93be1ba5.png
---
When you're starting on a fresh project, choosing a means for structuring your codebase is a difficult choice, as there are quite a few alternatives, and each of them have trade-offs, and at the end of the day, we're still trying to deliver the same thing.

<span class="h-card"><a class="u-url" href="https://kislayverma.com/">Kislay Verma</a></span>'s article ["how to organize your code"](https://kislayverma.com/programming/how-to-organize-your-code/) touches on this, and the benefits we can have by building the right architecture.

I've trialled a few ways of structuring projects, but generally default to the plain stack. Sometimes I'll put the underlying logic into a `-core` library, but it's never quite as well defined as doing it in terms of a complete Domain layer.

At [last week's jChampions](https://www.youtube.com/watch?v=IzLHmPNmLLw), I learned about [jMolecules](https://github.com/xmolecules/jmolecules), which provides a common language of how to programmatically, and conversationally discuss architecture, as well as some [ArchUnit rules](https://www.archunit.org/) to enforce the architecture rules.

jMolecules supports three styles of architecture out-of-the-box - Layered Architecture, Onion Architecture and Domain-Driven Design.

I'd recommend a read of <span class="h-card"><a class="u-url" href="https://herbertograca.com/">Herbert Graca</a></span>'s articles on [Layered Architecture](https://herbertograca.com/2017/08/03/layered-architecture/), [Onion Architecture](https://herbertograca.com/2017/09/21/onion-architecture/) and [Domain-Driven Design](https://herbertograca.com/2017/09/07/domain-driven-design/), as they're great reads.

I started off with giving the Layered Architecture a go with a couple of projects, and turned on the "strict" mode in jMolecules before finding that I really wasn't getting on with it. I was finding that there were too many levels of indirection, and it was quite complex to add new things without a cascade of effort. It turns out that this is the "Lasagna Architecture" anti-pattern (as noted by Herbert) and is a common reason folks don't use the "strict" model, or the Layered model at all.

Next, I moved onto the Onion Architecture, not least because I could talk about Onion Rings at work in a serious, work-related manner.

As well as giving a migration a go for [the Federated API Model at work](https://github.com/co-cddo/federated-api-model/pull/70), I also wanted to do this with a smaller project of my own that I could blog about regardless.

Code snippets can be found [in full in a sample project on GitLab](https://gitlab.com/jamietanna/spring-boot-onion-architecture-example).

# Before

Let's say that we have the following directory structure, which follows the stack model that Kislay mentions:

<details>

<summary>Package structure (before)</summary>

```
src
  |-main
  |  |-java
  |  |  |-me.jvt.hacking
  |  |  |  |-Application.java
  |  |  |  |-controller
  |  |  |  |  |-ApiController.java
  |  |  |  |-model
  |  |  |  |  |-ApiResponseContainer.java
  |  |  |  |  |-Api.java
  |  |  |  |-service
  |  |  |  |  |-NoopApiService.java
  |  |  |  |  |-ApiService.java
  |-test
  |  |-java
  |  |  |-me.jvt.hacking
  |  |  |  |-controller
  |  |  |  |  |-ApiControllerTest.java
  |  |  |  |-integration
  |  |  |  |  |-ApiControllerIntegrationTest.java
  |  |  |  |  |-ApplicationIntegrationTest.java
```

</details>

# Migrating

## Adding our ArchUnit tests

Let's start off by creating a very small ArchUnit test that enforces the Onion architecture:

```java
package me.jvt.hacking.architecture;

import com.tngtech.archunit.junit.AnalyzeClasses;
import com.tngtech.archunit.junit.ArchTest;
import com.tngtech.archunit.lang.ArchRule;
import org.jmolecules.archunit.JMoleculesArchitectureRules;

@AnalyzeClasses(packages = "me.jvt.hacking")
class ArchitectureLayeringTest {
  @ArchTest
  @SuppressWarnings("unused") // because I don't like IntelliJ warnings
  private final ArchRule onionArchitecture = JMoleculesArchitectureRules.ensureOnionClassical();
}
```

There are quite a few other ones I've added into the project to enforce the structure we want.

## Considering how our code maps to Onion rings

Before we can start migrating, we should think about the packages we've got and how they'd map to the onion rings:

<table>
  <tr>
    <th>
      Java Package/Class
    </th>
    <th>
      Onion Ring
    </th>
  </tr>
  <tr>
    <td>
      <code>me.jvt.hacking.controller</code>
    </td>
    <td>
      <em>Infrastructure Ring</em>
    </td>
  </tr>
  <tr>
    <td>
      <code>me.jvt.hacking.model</code>
    </td>
    <td>
      <em>Infrastructure Ring</em> and <em>Domain Model Ring</em>
    </td>
  </tr>
  <tr>
    <td>
      <code>me.jvt.hacking.service</code>
    </td>
    <td>
      <em>Application Ring</em> or <em>Domain Service Ring</em>
    </td>
  </tr>
</table>

While doing this, we notice that the `Api` object is reused between the Infrastructure and Domain model. Although that can be OK, the risk is that in the future we want to return different metadata, or with different field names in our HTTP layer, but then have to amend the underlying Domain object, which doesn't make sense, so we should split that `Api` object into different classes for different needs.

The example's `ApiService` isn't ideal, because it doesn't really do anything for business-logic so far, but the idea is that it would perform other checks such as validation of the underlying Domain Model objects, and retrieving them which means it'd be part of the Domain Service Ring. Alternatively, it could just delegate to Domain Service Ring objects / Domain Model Ring objects, so we could move it into the Application Ring.

## Creating packages

I'd recommend creating fresh packages, which clearly line up with our onion rings.

For the Application ring, we'll create `src/main/java/me/jvt/hacking/application/package-info.java`:

```java
@ApplicationServiceRing
package me.jvt.hacking.application;

import org.jmolecules.architecture.onion.classical.ApplicationServiceRing;
```

For the Domain Model ring, we'll create `src/main/java/me/jvt/hacking/domain/model/package-info.java`:

```java
@DomainModelRing
package me.jvt.hacking.domain.model;

import org.jmolecules.architecture.onion.classical.DomainModelRing;

```

For the Domain Service ring, we'll create `src/main/java/me/jvt/hacking/domain/service/package-info.java`:

```java
@DomainServiceRing
package me.jvt.hacking.domain.service;

import org.jmolecules.architecture.onion.classical.DomainServiceRing;
```


And for the Infrastructure ring, we'll create `src/main/java/me/jvt/hacking/infrastructure/package-info.java`:

```java
@InfrastructureRing
package me.jvt.hacking.infrastructure;

import org.jmolecules.architecture.onion.classical.InfrastructureRing;
```

## Moving packages

Finally, we need to set up our rings.

Most straightforward is the Infrastructure ring, which includes anything that deals with external parties and requests, such as our HTTP layer.

We can move our controller (and associated tests) as well as any HTTP response objects into the `infrastructure` package.

We also need to move our `Application`, which is the class annotated with `SpringBootApplication` into the application tier, as it's related to the way that the application is managed, but isn't as regularly changing as the Infrastructure Ring. Because it's no longer at the package root, we need to make sure `scanBasePackages` is set, and that Spring integration tests use `@ContextConfiguration` to make sure that we set up the integration tests accordingly.

We currently have Spring annotations on the `ApiService` which - at least in this contrive example - is going to be put into `DomainServiceRing`. Because the Domain ring is meant to be independent of the codebase that it's part of - as it contains core business models, rules and logic, we shouldn't be injecting in information about whether we are using Spring for Dependency Injection in our application, and need to remove it. This requires we wire in the `NoopApiService` with an `@Bean` configuration.

We then get the following setup:

# After

<details>

<summary>Package structure (after)</summary>

```java
src
  |-main
  |  |-java
  |  |  |-me.jvt.hacking
  |  |  |  |-application
  |  |  |  |  |-Application.java
  |  |  |  |  |-package-info.java
  |  |  |  |  |-SpringConfiguration.java
  |  |  |  |-domain
  |  |  |  |  |-model
  |  |  |  |  |  |-package-info.java
  |  |  |  |  |  |-Api.java
  |  |  |  |  |-service
  |  |  |  |  |  |-package-info.java
  |  |  |  |  |  |-NoopApiService.java
  |  |  |  |  |  |-ApiService.java
  |  |  |  |-infrastructure
  |  |  |  |  |-package-info.java
  |  |  |  |  |-models
  |  |  |  |  |  |-ApiResponseContainer.java
  |  |  |  |  |  |-Api.java
  |  |  |  |  |-controller
  |  |  |  |  |  |-ApiController.java
  |-test
  |  |-java
  |  |  |-me.jvt.hacking
  |  |  |  |-application
  |  |  |  |  |-infrastructure
  |  |  |  |  |-ApplicationIntegrationTest.java
  |  |  |  |-architecture
  |  |  |  |  |-ArchitectureLayeringTest.java
  |  |  |  |-infrastructure
  |  |  |  |  |-controller
  |  |  |  |  |  |-ApiControllerIntegrationTest.java
  |  |  |  |  |  |-ApiControllerTest.java
```

</details>

# Thoughts

It's a little bit of overhead to migrate, so it's better to start when we're on a fresh project, but I wouldn't say it's bad enough to avoid it if you're already part way down the architecture.

jMolecules makes it easier, and I've found that writing more ArchUnit tests helps further solidify our basis and understand what should and shouldn't be in each ring.

I'm also starting to use this at work, too, and am hoping it'll give us a bit more guardrails wise, and be more considered with the way we think about our software architecture.
