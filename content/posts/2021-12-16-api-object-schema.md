---
title: "Use a (JSON) Schema for the Interface Portion of your RESTful API"
description: "Why you should be using a well-defined (JSON) Schema for the data classes that your API consumers will need to utilise."
tags:
- api
- json-schema
- rest
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-16T09:36:51+0000
slug: "api-object-schema"
---
RESTful APIs are never built for the sake of it, but always have a consumer in mind - and hopefully many consumers over time.

When looking at integrating with someone else's API, I've seen stats before that indicate that most of the time taken to integrate is due to understanding how the API works and what parameters, headers, and request formats are required.

Fortunately lots of folks are documenting their APIs, either through separate API developer portals or through a machine-parseable format like OpenAPI, but it's not everyone, it's not always up-to-date, and it also doesn't always include the full request/response formats.

Since OpenAPI 3.1, you can now link out to JSON Schema definitions for describing the format of the request/response entities. JSON Schema is a great standard for providing a machine-parseable, but more-technical-human-readable, definition of how your data interchange format needs to work, and it's great to have it as a first-class citizen.

As well as just generally having something documented for your API's models, the schema being machine-parseable means that there are some great tools around it to make sure that the schemas work correctly. There's also [quicktype.io](https://quicktype.io/) which provides a hosted version of [an NPM package](https://github.com/quicktype/quicktype) that supports multiple languages, and is very neat, as well as [a number of others listed on the official JSON Schema website](http://json-schema.org/implementations.html#code-generation).

I'd _very_ strongly recommend getting started with this as soon as possible.

On a new project, it's straightforward to do because you are starting from a blank slate, so can look at creating the models through this means. It can also help if you're working in an API Design First manner, producing an OpenAPI document first, discussing with your consumers, and then starting work on your API, but doesn't need to be.

But when you've got an existing (pre-loved/legacy) system, how can you retrofit this? Fortunately there are also some tools out there that [can convert your existing models to schemas](https://json-schema.org/implementations.html#from-code) which can take some of the hard work away, but I'd say that if you can get good test coverage of the existing models, it's fairly straightforward to retrofit it.

For example, see [this small-scale migration on a project at work](https://github.com/co-cddo/federated-api-model/pull/11). We've had to make a few changes as things are a bit stricter with the new schema, but the structure of the objects are exactly the same, and our tests validating that still work.

As a consumer of APIs, it's _much_ easier to be able to integrate when you have a set of schemas available, as you can generate the models you need to utilise, confident that they'll work as they're (hopefully) being utilised in the same way on the server-side.

There are also other options besides JSON Schema that you can use, I just recommend it as it's a commonly used and well supported format for RESTful APIs.
