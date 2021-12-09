---
title: "Writing Better Wiremock Stubs"
description: "How to improve the specificity of Wiremock tests to allow for not clobbering other scenarios, and enabling scalable test runs."
tags:
- software-quality
- software-testing
- quality-engineering
- testing
- wiremock
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-06-01T14:50:43+0100
slug: "better-wiremock-stubbing"
series: writing-better-tests
image: "https://media.jvt.me/2a42816de8.png"
---
As mentioned in [_Default Your Tests to run in Parallel_](/posts/2021/06/01/parallel-tests/), I recommend looking to run tests in parallel by default, as it can unlock a few benefits, not least for speed!

Once such benefit is that we rearchitect our test code to not assume that we'll have the only access to the service, and its dependencies.

Although this may not be quite true locally (where you're unlikely to have another developer testing against the app on your machine), when you're deployed into a Cloud environment, it's not necessarily true that you'll be the only one using that environment. There could be someone running a local set of tests against the environment, whilst you've got a set of tests running on i.e. Jenkins, while you've also got a Product Owner walking through the journey while they try to accept a story.

Making assumptions that only one thing runs at once can be quite a risky assumption to make, and lead to working hard on building more painful solutions like "locking" environments, or adding in change management over your tests/deployments, when we can instead work to make our tests better.

In my case at work, we've got a number of deployments which don't need to be fully integrated with their dependencies, so instead they talk to a component which stubs its nearest neighbours. For this, we mostly use [Wiremock](http://wiremock.org), although this approach should definitely work with other stubbing frameworks.

# Specific Stub Mappings

Something that I commonly see - and have written myself in the past - is code that sets up a stub for the test scenario, then after the scenario runs, it clears the stubs in Wiremock so it's back to the default set of stubs configured.

This means that, for the duration of that test case, you're causing anyone using that stub issues. This could be that you're faking data, which someone else using the service may not be expecting, or on the worse side, you may be testing error conditions so be purposefully break your service for others using it.

A better solution for this is to use Wiremock's conditional stubbing to your advantage.

If you're using a service that expects a header `x-tracking-id`, and then passes that header to the dependencies, we could have a before hook in our test to generate a new `x-tracking-id`, then pass it through to the stub setup:

```diff
-stubFor(get(urlEqualTo("/some/thing"))
+stubFor(get(urlEqualTo("/some/thing").withHeader("x-tracking-id", world.getTrackingId()))
   .willReturn(aResponse()
     .withHeader("Content-Type", "text/plain")
     .withBody("Hello world!")
   )
 );
```

Then, when our call is received, it'll only match that specific case, otherwise will fall back to i.e. the default stubs.

Also, because there's nothing being changed in the "happy path" state, there's no need to clean up all the stubs. If you wanted to be a good citizen, you could take the stub ID that's returned from Wiremock and delete it after a test case.

# Conditional Use of a Proxy

Another nice use of Wiremock is its [proxying capabilities](http://wiremock.org/docs/proxying/). In the example where you have a system where you want to test a service that integrates with others, but you only want to test its integration sometimes.

Using the above configuration for more specific mappings, we can then set it up to proxy to the real integration when we want to prove the integration works, but only for that specific request, and otherwise we'll use the default stubs.

This can make it really nice to selectively test your environment's integration.
