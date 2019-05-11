---
title: "Beyond Rest: The Future of Web APIs"
description: "A writeup of the meetup talking about what could come next for APIs."
categories:
- events
tags:
- events
- openapi
- internet-of-things
- apis
- graphql
- containers
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-03-22T00:00:00+00:00
slug: "beyond-rest"
---
This is a writeup of the event [_Beyond Rest: The Future of Web APIs_](https://www.eventbrite.co.uk/e/beyond-rest-the-future-of-web-apis-tickets-54846386017#) at [BJSS](https://www.bjss.com). The overarching theme was looking ahead to what could be replacing REST APIs, and was split up into a number of talks on different aspects of it.

# Beyond Rest: The Future of Web APIs

The talk started off by talking about how they've recently been doing a fair few talks about REST interfaces, but actually want to think ahead to what could be next. Usually this would be bolted onto the end of a presentation, but this time they wanted to spend a whole evening on the topic.

We usually think of there being three ages of the World Wide Web:

1. The Information Age
1. The Social Web
1. The Semantic Web

But the next age will be The Intelligent Web, which will be all about decentralised and the Internet of Things. It will be a revolution of adaptive technology that reacts to the requirements it has. We'll be moving to microservices (or nanoservices in the case of Functions-As-A-Service) in a fully commoditised setup, looking at a specification-driven strategy with tools like Swagger/OpenAPI.

But integrating services unfortunately isn't always easy - we need to make sure that we can handle the volumes of data, decompose our monoliths to microservices, retain compliance within regulations and ensure we're upskilling to handle it.

The audience shared some "war stories" from the past, such as relying on an API that has no API versioning and constantly pushes breaking changes, to an API that responds with a `200 OK` with an `error` in the response body - boo!!

So why did we start using REST? It was more easily discoverable, as well as already having the HTTP standards in place to reduce the barrier to work with it. Nicer URLs due to the REST model helped, and because there weren't many alternatives, it was quite an easy choice.

(We then had a quick aside about the differences between doing "pure REST" and what happens when it's not quite to the word of the spec)

And then we spoke about how REST/RESTful APIs fall short:

- REST is just a pattern, not a framework or standard, unlike SOAP, which means you can't just pull down a dependency and have a nice interoperable API
- It's ideal for Create Read Update Delete (CRUD) interactions, but can be hard to model complex business workflows / meaning, or where there are queuing systems i.e. if I send a `POST /payments`, does that initiate a payment? Does it record the fact that a payment had been made?
  - working in a model where you `POST /payments` encourages you to mirror your RDBMS, which isn't ideal!
  - CRUD can also be hard to audit and debug
- Using [Hypermedia As The Engine Of Application State (HATEOAS)](https://en.wikipedia.org/wiki/HATEOAS) is a "pipe dream", because it's hard to design, and then implement, properly
- Making JSON commonplace is not ideal as it's not machine readable i.e. you can't have a link to something else, it has to be a string representation that is then interpreted as a link

And on top of that, it means that you now have to:

- Review the API design before it's implemented, making sure it is of a sufficient quality and is well-designed
- Make it discoverable using Swagger or OpenAPI documentation formats
- Provide documentation aside from just "here are the endpoints and response codes"
- Add sufficient authentication and authorization on top of the endpoints
- Look at the usage models and tune performance

So we need to move away from REST, but need a better alternative. We want to keep:

- a uniform interface for services implementing it
- client-server interactions
- stateless communication
- leverage HTTP - cache, common protocol, tolerant to change, easy to test
- lightweight payloads

But remember that we still need to migrate a lot of (now legacy) services!

We then spoke a little about the different moves to Open API platforms (different from OpenAPI documentation), such as PSD2 in Banking, or the Government Digital Service (GDS) who mandate open standards - with no exemptions!

Having open standards makes it so much easier to work with, both as a producer and a consumer. There was a great call to action - we should contribute to existing standards if they're deficient i.e. don't have our use cases, but also if there _isn't_ a standard, we should be the ones setting it up and pushing for it!

We spoke a little about how it would be good to create commoditized software, but unfortunately that won't happen because you can't "build once" as there are always different use cases.

# Deploying to Cloud with Containers (w/ Azure)

Next we had a demo of being able to easily push a .NET Core application into a container and have it running in Azure, to show just how easy it can be.

The session started with showing how we evolved from physical servers to Virtual Machines, then onto containers and now we're looking at running a process or as small as a function.

Then it took us through the process for building the app, placing it into a container, and getting it all the way to Azure - the final demo did this all in ~120s!

# IoT Eye for the Web API Guy

Next we had a look at the various pieces that make up the Internet of Things.

It was interesting to hear about how software for IOT devices need to be designed for *everything going wrong*. For instance, what happens if a device isn't used for ~20 years and then comes online? You can't just remove old APIs/protocols. It needs to be resilient to upgrades that may or may not fail, as it could be i.e. in the side of a volcano where you can't easily access it.

Standards are needed but aren't currently the best standards and i.e. Zigbee isn't actually interoperable between Zigbee devices as there are various types.

We also heard a little about how lots of IOT devices rely a lot on centralised cloud computing processing, which is a shame because these devices may not have a stable connection. It's much better to do things on-chip to avoid paying for network, compute and storage, as well as the minefield of regulations such as GDPR which you may not have much control of if you're working globally.

# Machine-to-Machine APIs

The next session started with a talking about how people are fallible and i.e. read or write documentation incorrectly. But if it's in a machine-readable format, the machine with implement the API correctly.

The use of API versioning may not even be required because if people aren't in the way, the consumer can automagically work with the new contracts.

We talked again about how JSON isn't machine readable and that we should instead use something like [JSON-LD](https://json-ld.org/), [HL7 FHIR](https://www.hl7.org/fhir/) or [OData](https://www.odata.org/), all of which _can_ be machine-readable which means (in theory) they _can_ integrate without a human. We have [schema.org](https://schema.org) which already has some standardises formats for various data types, as well as [microformats2](http://microformats.org/wiki/microformats2) for HTML.

The idea is that down the line we could have AI/Machine Learning that can predict what sort of data it will need to achieve a task, and at runtime build the integration and start using it.

This would mean we'd need a registry of vocabulary to allow the machines to initiate communication, and then perform a discovery phase to understand what the remote service provides. Once the APIs were discovered, it could build the model for interacting with it, and be off.

This likely won't be for a decade or two, but is quite interesting to think about.

Talking of data interchange, we learned about how OData / JSON-LD are the best practice for building/consuming APIs,as it helps develop the service logic. They help with all sorts of important pieces, like media types, HTTP methods, the actual formats of request/response, and even async processing, which is a bring-your-own-pattern in REST (and difficult because HTTP is meant to be stateless). And they're fully extensible, so you can add your own preferences on top.

The biggest takeaway of this section was the question:

> What are you trying to solve? Is it a pattern, protocol, or format you're trying to solve?

Each of these have different options, so without knowing what you want, you'll likely go the wrong route and design - there is no right answer, but some are more suited than others.

# GraphQL

We then had a session on using [GraphQL](https://graphql.org/), which is a library opposed to a standard/protocol. GraphQL is a declerative description of data requirements you want from another service (which looks somewhat similar to SQL), and is optimised for client performance.

For instance, you may want to request the first name for all your customers. Most likely with a RESTful API you would request all 1 million records, which would include all sorts of other data you don't care about, and then you'd loop through it and collect just what you wanted.

You _may_ be able to request the API only sends back that field, but it could still need to pull all the data out of the DB only to send back what you want (which is also true in GraphQL!)

It's all about making the server do the hard work, so the client gets a nicer piece of work, with less JSON processing, and more control over the APIs - this is a huge win for i.e. IOT devices. It has the potential to reduce state management, depending on how it's set up.

Unfortunately GraphQL is not a silver bullet or panacea; it has its usage patterns and disadvantages:

- it's not cacheable, whereas you _can_ cache a `GET` request in a RESTful API
- it's still focussed on data, not on operations i.e. make a payment
- it's not a solution for your poor API design - it may make things worse!
