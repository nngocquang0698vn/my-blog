---
title: "Lessons Learned from Running Java in Serverless Environments like AWS Lambda"
description: "Some recommendations for running Java as a Serverless application language, for instance on AWS Lambda or Google Cloud Functions."
tags:
- java
- aws
- aws-lambda
- serverless
- google-cloud
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-11-17T17:21:49+0000
slug: "java-serverless-learnings"
---
Recently, some colleagues and I were talking about the use of Java for AWS Lambda, and after our discussion I thought I'd write up some of my experience over the last few years for posterity.

This includes experiences I've had running on AWS Lambda and Google Cloud Functions.

# Learnings

## Prerequisite reading

Firstly, <span class="h-card"><a class="u-url" href="https://github.com/SeanOToole">Sean</a></span>, one of my ex-colleagues at Capital One, wrote an excellent post [_AWS Lambda Java Tutorial: Best Practices to Lower Cold Starts_](https://www.capitalone.com/tech/cloud/aws-lambda-java-tutorial-reduce-cold-starts/) which I'd thoroughly recommend reading before carrying on with this post, as I'll be building on top of it for this post.

This stripped down Lambda approach was the basis for a number of the more recent services I had running on Lambda, and made an impressive difference to the overall performance of our Lambdas.

## Load profile is important for Lambda performance

One of the first applications I encountered with AWS Lambda was a multi-endpoint Jersey web application, which interacted with a persistence tier.

This application was being developed in this way as an exercise to see what building an application to avoid vendor lock-in could look like, while also delivering value to customers. This would produce two different JAR files, one to be used in AWS Lambda, and one for EC2.

Unfortunately the way it was built - primarily the fact that it was approached as an EC2-based application, that could also be run on Lambda, rather than vice-versa - meant it was not very performant. Because the load profile for the service in production was _incredibly_ infrequent, its performance was acceptable, and wasn't worth rearchitecting or improving other than tweaking its Lambda memory allocation.

Regardless, most folks saw only the headline, which was that Java Lambdas can be slow, and it definitely turned a few people off building Lambdas, at least with that pattern.

At the same time there was another application following this pattern that reasonably consistent traffic and had a constantly warm JVM, which was a much more performant application, so it highlighted the fact that the application we'd chosen wasn't ideal for the approach.

Off the back of this, there was investigations that led to the improvements that Sean had mentioned for alternate ways to run Lambdas.

## HTTP (routing) is hard

Although this isn't necessarily a Java-only problem, one thing you'll find is that going into Lambda and then having to do all the work that a web framework usually does for you gives you a real appreciation for it.

Prior to my work on Lambdas, I'd been working with Spring Boot and had gotten quite used to having a fully-fledged web framework. It's so much easier to build web applications with a web framework, especially for more complex routing, validation of requests, and correctly performing content-type negotiation. Even if it's not as much "magic" as Spring Boot, having a lot of things taken out of your hands is really helpful.

Because we were trying to limit the size of the classpath, we wanted to avoid using a heavier web framework, and ended up writing a homegrown, lightweight HTTP layer.

As we started using [server-driven content negotiation](/posts/2021/01/05/why-content-negotiation/), we started discovering more areas frameworks abstracted away from us to make our lives as developers easier. Although our use case was specifically for versioning, content negotiation is something that a number of API clients do automagically, such as Rest Assured,  so you need to be able to handle it.

Because I knew this was a problem that others would likely want to solve, I ended up [releasing two Open Source libraries for this](/posts/2021/01/11/content-negotiation-java/) which would manage the content negotiation process, as it can be complex, and we don't need every engineer working on Java Lambdas to need to write their own implementation!

These make it much easier to manage endpoint(s) that handle multiple media types, but even if you're only expecting `accept: application/json`, remember that it's _very_ likely that someone may send a more complex example!

Aside from content-type negotiation, there's also the need to add in pre (and maybe post) middleware to validate that the request is valid, and before long this all starts adding up with things that you need to write and maintain, for the benefit of a lighter classpath.

## It's called _functions_ as a service

The whole point of Serverless, or Functions as a Service, is that they're meant to be small chunks of functionality.

I've seen a single Lambda function deployed that handle multiple HTTP routes, rather than handling a specific piece of logic. Part of this was how deployment processes worked, or not using AWS API Gateway, but also it came out of the fact that using something like [Hexagonal Architecture](https://en.wikipedia.org/wiki/Hexagonal_architecture_(software)) with Java can be costly in terms of the cold start delays on each invocation down the chain.

It's worth having a read of [_Anti-patterns in Lambda-based applications: The Lambda monolith_](https://docs.aws.amazon.com/lambda/latest/operatorguide/monolith.html) and [_AWS Lambda — should you have few monolithic functions or many single-purposed functions?_](https://hackernoon.com/aws-lambda-should-you-have-few-monolithic-functions-or-many-single-purposed-functions-8c3872d4338f) to help shed a bit more light on what you can do instead.

## Choosing the right Dependency Injection framework

As Sean mentions, Dependency Injection can be really expensive. We'd tried going the route of "actually we don't need Dependency Injection", but then realised that for a lot of things, it made it much easier, especially when we were starting to have to stub out environment variables for unit test purposes.

Instead, moving to Dagger or Guice is a better option, and gives you real Dependency Injection. I've written [_Lightweight and Powerful Dependency Injection for JVM-based Applications with Dagger_](/posts/2021/10/19/dagger-java-lambda/) to explain how to switch to Dagger, and the benefits you'll reap from it, and would very much recommend using it.

## Managing JSON (de)serialisation better

As Sean mentions in his post, removing Reflection is important for improving Lambda performance.

Jackson is commonly used for JSON (de)serialisation in Java applications, but is Reflection based, so you want to avoid it if you can.

GSON is a common alternative, which [is included in the Lambda runtime](/posts/2021/11/17/aws-lambda-java-runtime/), and has quite a lot of users inside and outside of Serverless (although note that you really should make sure you keep it updated, rather than rely on the version available in Lambda, otherwise you risk being hit by security issues)

We started using [Moshi](https://github.com/square/moshi), and found that it was performant and had a pretty good developer experience. While investigating Moshi, we found that we couldn't use `aws-lambda-java-events`, as the events classes required the use of Joda Time, which is quite a heavy weight on the classpath.

This led us to curating a library with the different events we needed, which had the added bonus of a lighter classpath as we only needed to add the models we needed, as well as being able to improve the developer experience by providing builders with common headers, or easier means to append a header.

When using Moshi, you'll need to make sure you're careful of how you write them, as Moshi translates the field name to the JSON property, not using getters / `@JsonProperty` as is expected with Jackson.

And if you want the models to be usable across both, there's a bit of work that you'll need to do to make it possible, because some applications may need Jackson for other use cases. We found part way through the journey that making sure we had tests for all our classes for both Moshi and Jackson serialisation was important.

## Utilise cold start

As Sean mentions, there's increased performance for your application at cold start initialisation, so make sure you use it!

## Better testing with LocalStack

It's possible that you're using [LocalStack](https://localstack.cloud) for testing your Lambdas locally. There are a few things we've learned through using it for a couple of years that are useful to know.

### Make sure you pin

I'm a strong proponent of version pinning, as it's something that's bitten me quite a few times where teams haven't been pinning various dependencies, and have inevitably been burned. There is the risk that you can be stuck on older versions of software, but hopefully you also have tools like [WhiteSource Renovate](/posts/2021/09/26/whitesource-renovate-tips/) or Dependabot to keep you updated in a safer way, where you can check all your tests pass.

As LocalStack is still on a 0.x release, there's no stability promised between each release. But not only is that true between minor versions, but patch versions can change things pretty significantly too. Additionally, the `latest` Docker tag is what's just been pushed to the main branch, which means that you're on the bleeding edge, and the version you're using will be very different compared to someone who last pulled a day ago.

I'd recommend making sure that LocalStack is always version pinned, and that you upgrade safely when you're ready to.

### Cold starts with `docker-reuse`

While trying to track down why our local tests were performing poorly, I spotted that even when using the `docker-reuse` mode, Java was triggering a cold start on each invocation of the function.

I [raised an issue with LocalStack](https://github.com/localstack/localstack/issues/4123), and after a few months of me not updating my initial work on resolving it, a few folks in the community resolved it and it landed in `latest` this morning!

This will be a problem if you're pinned to an older version, but upgrading should save you some time when testing.

### No concurrency controls

As [a general rule](/posts/2021/06/01/parallel-tests/), I like to have my tests running in parallel. When applying this to the Lambdas we had, I found that they were running _even slower_ which seemed really odd, even after I'd locally solved the cold start issue.

Unfortunately the real culprit is [that it isn't possible to configure concurrency](https://github.com/localstack/localstack/issues/2483) which means that each Lambda can only be invoked once, so even if your tests are highly parallelised, they'll execute sequentially.

## Java 11, and beyond

We found that upgrading to Java 11 made ~20% difference to cold start, overall memory costs, as well as the developer experience boost.

On the services that we upgraded, there was very little to actually change, so it meant it was a very cost-effective upgrade!

## Splitting business logic from HTTP logic

This is already a pretty well-followed practice, but I thought I'd still mention that making sure the HTTP logic is separate to what's happening under the hood makes things easier to reason with, and allows for easier testing.

I've worked on some projects that haven't had this split as well, or that required mocking environment variables and serialising JSON to allow testing things hooked in correctly.

## Library-first works great, but leads to overhead

This isn't just a Java problem, but remember that if you're not using a framework or an existing i.e. HTTP layer, you're increasing the burden for maintain once.

The HTTP layer I mentioned was beneficial because it gave us a place to solve common requirements such as sending [HTTP Strict Transport Security (HSTS)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security) headers.

We built a good community around shared ownership and reusing code, and made a good effort to build library-first, instead of solving the problem locally. But the problem with lots of libraries and writing a lot of code ourselves was that it leads to more maintenance.

Try to adopt Open Source where possible, and release what you can as Open Source to help others, too!

## Don't try and keep the Lambda warm

One option to make sure Java Serverless applications stay performant is to keep them warm with a healthcheck endpoint.

Although this works, I think it's worth thinking about whether this is the right solution. By taking Serverless, which is meant to be "pay for only what you use", and injecting a lot more load onto your application than it needs, you're incurring a lot of cost for performances' sake.

Think about whether this is definitely the right stack, and that you're getting the benefits from using Java that you think you are.

# Is Java Right for you?

Hopefully after reading this you can make a more informed decision about whether Java is the right language.

There's definitely a few cons that are related to building on Serverless in general, but a number of the cons are specific to Java and its cold start problem.

Although you can tune the application for better performance, maybe think about whether your workload makes more sense as a persistent JVM on EC2 or ECS where you can save a lot of developer time and experience instead of shoehorning into Serverless unnecessarily.
