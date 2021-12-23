---
title: Test Driven Development for Your Spectral Rules, using Jest
description: How to write unit tests for Spectral API linting, in a test-driven development fashion.
tags:
- blogumentation
- spectral-test-harness
- spectral
- api
- unit-testing
- testing
- javascript
- nodejs
- tdd
date: 2021-12-22T18:38:32+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: spectral-jest
image: https://media.jvt.me/ba93c1e17a.png
---
[Spectral](https://github.com/stoplightio/spectral) is a great and really powerful tool for building automated style guides for your APIs.

As you're codifying your rules, however, you may find that you're itching for some faster feedback on the rules, to make sure that the rules actually apply to an API specification.

Although it's possible to run `spectral lint` against a predefined contract that fails the tests, then read the response from the command and check that the right rule is failing, it's not quite as speedy as having a feedback loop.

As I've been starting to build things with Spectral, I've felt the same, so found that setting up a handy test harness was really important to speed up my effectiveness, and make sure I'm actually writing rules correctly!

At first I was looking at shelling out to `spectral lint` and parsing the JUnit-formatted output, but it turns out there's a very good [JavaScript API](https://github.com/stoplightio/spectral/blob/develop/docs/guides/3-javascript.md) that we can use for this, alongside Jest.

# Example

The code can be found in full in an [example repo on GitLab](https://gitlab.com/jamietanna/spectral-jest).

**Update 2021-12-23**: [I have now released](/posts/2021/12/23/spectral-test-harness/) this test harness as [a separate NPM package](https://www.npmjs.com/package/@jamietanna/spectral-test-harness) which can be used, instead of needing to copy-paste code.

## Initial Setup

Firstly, let's create a test file to validate that our rules can apply against an OpenAPI spec, by creating the file `test/rules.test.js`:

```javascript
const { retrieveDocument, setupSpectral } = require('./testharness')

test('Empty document passes', async () => {
  const spectral = await setupSpectral()
  const document = retrieveDocument('empty/valid.yaml')

  const results = await spectral.run(document)

  expect(results).toHaveLength(0)
})
```

Notice that we've got a few helpers to set up the state of our tests, and then we validate that there aren't any issues.

To get this working, we need to create our `test/testharness.js` module to make it easier to set things up. I'd originally created this as `global` methods for Jest to utilise, but decided against it so it's a little less "magic".

```javascript
const { fetch } = require('@stoplight/spectral-runtime')
const { Spectral, Document } = require('@stoplight/spectral-core')
const Parsers = require('@stoplight/spectral-parsers')
const fs = require('fs')
const path = require('path')
// we need to add `dist/loader/node` as per convo on https://github.com/stoplightio/spectral/issues/1956#issuecomment-999643841
const { bundleAndLoadRuleset } = require('@stoplight/spectral-ruleset-bundler/dist/loader/node')

const retrieveRuleset = async (filePath) => {
  return await bundleAndLoadRuleset(path.resolve(filePath), { fs, fetch })
}

const retrieveDocument = (filePath) => {
  const resolved = path.resolve(path.join('test/testdata', filePath))
  const body = fs.readFileSync(resolved, 'utf8')
  return new Document(body, Parsers.Yaml, filePath)
}

const setupSpectral = async () => {
  const ruleset = await retrieveRuleset('ruleset.yaml')
  const spectral = new Spectral()
  spectral.setRuleset(ruleset)
  return spectral
}

module.exports = {
  retrieveDocument,
  setupSpectral
}
```

To make things easier, we've split into three core methods, utilising Spectral helpers to do the heavy lifting - such as the `bundleAndLoadRuleset` method from `@stoplight/spectral-ruleset-bundler` to parse our JSON/YAML configuration and convert it to a form that the Spectral JavaScript interface supports.

Note that you may run into `Cannot find module 'nimma/legacy'` errors, [which can be solved through Jest configuration](https://github.com/stoplightio/spectral/issues/2002), which can be seen in the `jest.config.js` in the sample repo.

At this point we can create an empty `ruleset.yaml` file:

```yaml
rules: {}
```

And we'll need to set up an empty file, `test/testdata/empty/valid.yaml`, as test data:

```yaml
```


We should now get a passing test - awesome!

## Adding Rules

Now, let's say that we want to introduce a rule that requires Semantic Versioning is used across APIs:

```yaml
# Via https://github.com/openapi-contrib/style-guides/blob/c5326037027afb8bd0ce5a5d4ad88be7b048ef64/openapi.yml#L55-L64
rules:
  # Authors: Lorna Mitchell  and @mheap
  semver:
    severity: error
    recommended: true
    message: Please follow semantic versioning. {{value}} is not a valid version.
    given: $.info.version
    then:
      function: pattern
      functionOptions:
        match: "^([0-9]+.[0-9]+.[0-9]+)$"
```

To start with, we'll need some failing tests in `test/semver.test.js`:

```javascript
const { retrieveDocument, setupSpectral } = require('./testharness')

describe('semver', () => {
  test('fails when not a number', async () => {
    const spectral = await setupSpectral()
    const document = retrieveDocument('semver/invalid.yaml')

    const results = await spectral.run(document)

    expect(results).toHaveLength(1)
    expect(results[0].code).toBe('semver')
  })

  test('passes when valid format', async () => {
    const spectral = await setupSpectral()
    const document = retrieveDocument('semver/valid.yaml')

    const results = await spectral.run(document)

    expect(results).toHaveLength(0)
  })
})
```

We'll create our test data files, `test/testdata/semver/invalid.yaml`

```yaml
info:
  version: 'foo'
```

And `test/testdata/semver/valid.yaml`

```yaml
info:
  version: 1.2.3
```

This now should give us failing tests, which we can fix by adding the rule to our `ruleset.yaml`:

```yaml
rules:
  # via https://github.com/openapi-contrib/style-guides/blob/c5326037027afb8bd0ce5a5d4ad88be7b048ef64/openapi.yml
  semver:
    severity: error
    recommended: true
    message: Please follow semantic versioning. {{value}} is not a valid version.
    given: $.info.version
    then:
      function: pattern
      functionOptions:
        match: "^([0-9]+.[0-9]+.[0-9]+)$"
```

## Extending other rules

One of the great things about using Spectral is that we can utilise others' rules on top of our own, i.e.:

```yaml
extends:
  - [spectral:oas, all]
rules:
  # via https://github.com/openapi-contrib/style-guides/blob/c5326037027afb8bd0ce5a5d4ad88be7b048ef64/openapi.yml
  semver:
    severity: error
    recommended: true
    message: Please follow semantic versioning. {{value}} is not a valid version.
    given: $.info.version
    then:
      function: pattern
      functionOptions:
        match: "^([0-9]+.[0-9]+.[0-9]+)$"
```

To make this work, we need to make sure that our specs each declare themselves as OpenAPI:

```diff
+openapi: 3.1
 info:
   version: 1.2.3
```

Then, we'll start to see failing tests:

```
 FAIL  test/rules.test.js
  ● Empty document passes

    expect(received).toHaveLength(expected)

    Expected length: 0
    Received length: 5
    Received array:  [{"code": "info-contact", "message": "Info object must have \"contact\" object.", "path": [], "range": {"end": {"character": 12, "line": 0}, "start": {"character": 0, "line": 0}}, "severity": 1, "source": "empty/valid.yaml"}, {"code": "info-description", "message": "Info \"description\" must be present and non-empty string.", "path": [], "range": {"end": {"character": 12, "line": 0}, "start": {"character": 0, "line": 0}}, "severity": 1, "source": "empty/valid.yaml"}, {"code": "oas3-api-servers", "message": "OpenAPI \"servers\" must be present and non-empty array.", "path": [], "range": {"end": {"character": 12, "line": 0}, "start": {"character": 0, "line": 0}}, "severity": 1, "source": "empty/valid.yaml"}, {"code": "oas3-schema", "message": "Object must have required property \"info\".", "path": [], "range": {"end": {"character": 12, "line": 0}, "start": {"character": 0, "line": 0}}, "severity": 0, "source": "empty/valid.yaml"}, {"code": "oas3-schema", "message": "\"openapi\" property type must be string.", "path": ["openapi"], "range": {"end": {"character": 12, "line": 0}, "start": {"character": 9, "line": 0}}, "severity": 0, "source": "empty/valid.yaml"}]

       7 |   const results = await spectral.run(document)
       8 |
    >  9 |   expect(results).toHaveLength(0)
         |                   ^
      10 | })
      11 |

      at Object.<anonymous> (test/rules.test.js:9:19)
```

These are due to our extended rules now failing, so we have two choices - either make all our specs valid (a reasonable choice) or amend our tests to only validate the specific rule is failing.

I'd recommend doing the former, but with the fact that we'll likely be adding more tests, each example spec for test cases will need to be more and more complex, so we should probably instead minimise our tests, for instance:

```javascript
const { retrieveDocument, setupSpectral, resultsForCode } = require('./testharness')

describe('semver', () => {
  test('fails when not a number', async () => {
    const spectral = await setupSpectral()
    const document = retrieveDocument('semver/invalid.yaml')

    const results = resultsForCode(await spectral.run(document), 'semver')

    expect(results.length).toBeGreaterThanOrEqual(1)
  })

  test('passes when valid format', async () => {
    const spectral = await setupSpectral()
    const document = retrieveDocument('semver/valid.yaml')

    const results = resultsForCode(await spectral.run(document), 'semver')

    expect(results).toHaveLength(0)
  })
})
```

And in `test/testharness.js`:

```javascript
// ...

function resultsForCode(results, code) {
  return results.filter((r) => r.code === code)
}

module.exports = {
  retrieveDocument,
  setupSpectral,
  resultsForCode
}
```

## Severity checking

If we want to make sure our `test/testdata/empty/valid.yaml` works, we should really verify that there are no errors in the spec, which requires we amend our test harness to add:

```javascript
const { DiagnosticSeverity } = require('@stoplight/types')

// ...

function resultsForSeverity (results, severity) {
  return results.filter((r) => DiagnosticSeverity[r.severity] === severity)
}

function getErrors (results) {
  return resultsForSeverity(results, 'Error')
}

function getWarnings (results) {
  return resultsForSeverity(results, 'Warn')
}

function getInformativeResults (results) {
  return resultsForSeverity(results, 'Information')
}

function getHints (results) {
  return resultsForSeverity(results, 'Hint')
}

module.exports = {
  retrieveDocument,
  setupSpectral,
  resultsForCode,
  resultsForSeverity,
  getErrors,
  getWarnings,
  getInformativeResults,
  getHints
}
```

Then, we can amend our `test/rules.test.js` to be:

```javascript
const { retrieveDocument, setupSpectral, getErrors } = require('./testharness')

test('Complete document passes', async () => {
  const spectral = await setupSpectral()
  const document = retrieveDocument('complete/valid.yaml')

  const results = getErrors(await spectral.run(document))

  expect(results).toHaveLength(0)
})
```

And note that our `test/testdata/empty/valid.yaml` is renamed to `test/testdata/complete/valid.yaml`, with contents:

```yaml
openapi: '3.0.0'
info:
  title: 'Example API'
  version: '0.0.0'
paths: {}
```
