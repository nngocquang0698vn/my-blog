---
title: "Better Chef Reporting for Automated Pipelines"
description: "How to get better machine-parseable reports for your Chef Pipelines."
date: 2021-03-29T19:39:21+0100
tags:
- "blogumentation"
- "chef"
- "jenkins"
- "test-kitchen"
- "rubocop"
- "cookstyle"
- "rspec"
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
slug: "chef-build-reporting"
image: /img/vendor/chef-logo.png
---
When building your Chef cookbooks, you likely will want an automated pipeline which allows you to enforce a quality bar for how your cookbooks are developed.

However, you probably want a little more visibility than "did that build succeed", and want to be able to drill into exactly what failed. To do this, across many automated build platforms, like Jenkins, you want to produce a (well) supported machine-parseable format.

One of the most commonly usable formats is the JUnit output format, made popular with the Java testing library JUnit.

Fortunately, all of the Chef tools that we would want to use in a pipeline support the JUnit report format.

# Cookstyle

Because Cookstyle is built upon the wonderful [Rubocop](https://rubocop.org/), which means we can use the inbuild formatters that Rubocop provides, such as [the built-in JUnit formatter](https://docs.rubocop.org/rubocop/formatters.html#junit-style-formatter):

```sh
rubocop --format junit --out test-reports/junit.xml
# or, only show failed Cops
rubocop --format junit --out test-reports/junit.xml --display-only-failed
```

# RSpec

Unfortunately [RSpec](https://rspec.info/) doesn't, out of the box, support JUnit format, but there's a great gem `rspec_junit_formatter` which when installed, allows us to run:

```sh
rspec --format RspecJunitFormatter --out test-reports/rspec.xml
```

# Test Kitchen + InSpec

Test Kitchen fortunately supports JUnit format results [out-of-the-box](https://github.com/inspec/kitchen-inspec#custom-outputs):

```yaml
verifier:
  name: inspec
  reporter:
    - cli
    - junit:path/to/results/%{platform}_%{suite}_inspec.xml
```
