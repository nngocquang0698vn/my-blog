---
title: "Making Your Gherkin Scenarios Written Using Human-Readable Language"
description: "A lukewarm take about why you should use natural language, so someone not-as-technical can read it and still derive value."
tags:
- software-testing
- cucumber
- communication
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-08-24T22:40:09+0100
slug: "human-readable-gherkin"
series: writing-better-tests
image: /img/vendor/cucumber.png
---
Functional Acceptance Tests are often a testing phase that can be used to be (one of) the final checks of functionality for an application, determining whether it meets the needs of the business.

Because we would be expecting our Product Owners to be involved in determining whether this is correctly performed, and they are less likely to be engineers, we need to produce tests that are readable across levels of technical expertise. Due to the focus on human language, rather than semantics of a programming language, [Gherkin](https://cucumber.io/docs/gherkin/reference/) is very popular as the language for functionality, in conjunction with [Cucumber](https://cucumber.io/).

At Capital One, we use Cucumber very heavily across our applications, but depending on the team, the scenarios can be at differing levels of readability.

This is made more difficult when working with backend services teams, as our acceptance tests are often a little more technical than they need to be, because we often see the consumers of our scenarios as engineering teams, not Product Owners - which is generally not the best idea.

I've worked before on services where we write Cucumber scenarios that use a lot of technical terminology (such as talking about HTTP headers or including URLs of endpoints to call), as a way to make it easier for us to write new scenarios, but this does lead to our scenarios then being difficult to read, especially to someone not-as-technical.

More recently, I've been striving to make our Cucumber scenarios much more human readable - even in cases where it means we as developers need to work a little harder, as we need to perform a bit more plumbing to make the natural language map to technical intent.

This is probably quite a lukewarm take as in the testing community, using human-readable Gherkin is a widely agreed practice, but I really like using it to communicate value to folks in the business who may be not-as-technical.

It's giving the team a good exercise in how to make it clear to a human, not an engineer, what the functionality is doing, and allows us to think of it in terms of business functionality.

One of the services my team owns is to allow partners/aggregators to perform credit card quotations on behalf of prospective customers. As part of this, we have a sandbox environment which has a number of test scenarios pre-baked, to allow our consumers to test common scenarios like "the customer gets declined" or "the customer requests a balance transfer, but doesn't get it for the amount they've requested".

Previously, the documentation we had for this, that was shared with our consumers, was a spreadsheet of fields and data, which was not the most readable. Although this would generally go to the engineers integrating with the service, there would also be a Product Owner on the consumers' side who'd need to accept the journey works from their own side, and having them transposing a spreadsheet to data in a form is a little painful.

While doing some recent rearchitecting of the service, I took some time to invest in creating a set of Cucumber steps that would make it possible to provide human-readable scenarios, with the intent that these could be shared, instead of the spreadsheet, and everyone - from engineers to Product Owner, on both sides of the discussion - would know what was going on.

Although I was hopeful that this work would be beneficial, last week we did some work to add some new testing scenarios, and we were able to share simply the scenarios, and no other context, to our Product Owners, and they were able to sign off on the changes. It was really great to see the benefits of writing something like:


```gherkin
Given I provide my name as Jamie Tanna
And I provide my date of birth as ...
# ...
When I submit my details
Then I am pre-approved for the CCS18 product
```

Instead of what we had previously, which was a lot more technically complex, although easier for engineers to extend:

```gherkin
Given I set $.individual.name to Jamie Tanna
And I set $.individual.dateOfBirth to ...
# ...
When I send a POST request to /uk/quotations
Then I receive the product CCS18 with likelihood value of 100
```

Remembering that there are lots of people involved in the process of these tests are hugely important, and writing human-readable scenarios benefits your team - as they need to invest in technical writing skills, and consider the business value of a change - as well as folks outside of the team, who aren't as close to the technical complexities of the work.
