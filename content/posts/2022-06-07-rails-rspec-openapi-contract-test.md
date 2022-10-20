---
title: "Setting up OpenAPI Contract Tests with a Rails and RSpec codebase"
description: "How to run OpenAPI-driven contract tests against a Rails API."
date: "2022-06-07T21:43:17+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1534276774741278721"
tags:
- "blogumentation"
- "ruby"
- "rails"
- "openapi"
- "testing"
- "contract-testing"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/7be186e7a3.png"
slug: "rails-rspec-openapi-contract-test"
---
I've recently been working on retrofitting an existing Rails application with an [OpenAPI](https://openapis.org) specification, as a way to better understand and interact with the service.

Thanks to the excellent post [_Validating requests and responses using OpenAPI specification with Committee_](https://nicolasiensen.github.io/2022-04-18-validating-requests-and-responses-using-openapi-specification-with-committee/), I learned about how to get [the committee gem](https://github.com/interagent/committee) to perform the testing validation against a fresh Rails app.

However, the assumption in the post above is that it relies on a non-RSpec driven testing lifecycle, which is fairly common, but the codebase I'm using relies on [rspec-rails](https://github.com/rspec/rspec-rails).

We can continue to follow the post above, but before we generate the scaffolding for the `city` type, we can start by installing rspec-rails and setting it up:

```sh
bundle add rspec-rails && bundle install
bin/rails generate rspec:install
```

In this rspec-rails codebase, we were using [Controller specs](https://relishapp.com/rspec/rspec-rails/docs/controller-specs) which only test the controller through method calls, which are an excellent way to test the controller itself.

Unfortunately, these don't work with Committee, as they're _too_ lightweight. We need to instead use the [Request spec](https://relishapp.com/rspec/rspec-rails/v/5-1/docs/request-specs/request-spec), which allows us to execute all (Rack) middleware that is set up for our application, which would include Committee.

If we run the scaffolding command:

```sh
bin/rails g scaffold city name:string latitude:float longitude:float demonym:string website:string
```

We then get a generated request spec which validates that for valid operations, we'll get a valid response.

This still requires us to write the different cases required, but that's it - you're now contract testing 🚀
