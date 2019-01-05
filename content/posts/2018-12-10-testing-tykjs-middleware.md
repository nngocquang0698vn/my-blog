---
title: Unit Testing Your TYK (TYKJS) Middleware
description: Writing unit tests (in this case using Jasmine) for the TYK API Gateway's JavaScript middleware functionality.
categories:
- blogumentation
- tyk
- tykjs
tags:
- blogumentation
- tyk
- tykjs
- unit-testing
- testing
- javascript
- nodejs
image: /img/vendor/tyk.io.jpg
date: 2018-12-10
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: testing-tykjs-middleware
---
Since properly playing around with [Auth0] at Hackference, I've been looking into how to integrate this with tools like [`api.jvt.me`] and soon-to-be [IndieAuth] support to help me manage my personal identity services, and help me strive for Single Sign On everywhere!

But as I'll be starting to expose some potentially dangerous data, I have been looking at enforcing extra authorization, as well as looking at rate-limiting. While looking around, I've found the [TYK API Gateway], which looks pretty cool - it's written in Go, is pretty speedy, and has the ability to write custom [middleware] in JavaScript to provide my own custom rules.

While looking into it, I found very little documentation around how to actually test them, aside from "just try it and see if it works". Being very much in the quality-driven mindset and strong believers in TDD, this didn't really cut it - so I sought out a better solution.

In the [spirit of Blogumentation][blogumentation] I'm writing up my experiences as well as providing a how-to with a permissive license so you too can unit test your TYK middleware.

The source code for this article can be found at [<i class="fa fa-gitlab"></i> unit-test-tykjs][unit-test-tykjs], and unless specified otherwise, code snippets below are licensed Apache 2.0.

# The Middleware

Let's assume we've written a piece of middleware, such as [`samplePostProcessMiddleware` from the TYK repo][samplePostProcessMiddleware]:

```js
/*
 * NOTE: This file is licensed under the Mozilla Public License 2.0 (MPL-2.0)
 * which can be read in full at
 * https://github.com/TykTechnologies/tyk/blob/v2.7.4/LICENSE.md and the source
 * of this file can be seen at
 * https://github.com/TykTechnologies/tyk/blob/v2.7.4/middleware/samplePostProcessMiddleware.js
 */

// ---- Sample middleware creation by end-user -----
var samplePostProcessMiddleware = new TykJS.TykMiddleware.NewMiddleware({});

samplePostProcessMiddleware.NewProcessRequest(function(request, session) {
    // You can log to Tyk console output by calloing the built-in log() function:
    log("Running sample  POST PROCESSOR JSVM middleware")

    // Set and Delete headers in an outbound request
    request.SetHeaders["User-Agent"] = "Tyk-Custom-JSVM-Middleware";
    //request.DeleteHeaders.push("Authorization");

    // Change the outbound URL Path (only fragment, domain is fixed)
    // request.URL = "/get";

    // Add or delete request parmeters, these are encoded for the request as needed.
    request.AddParams["test_param"] = "My Teapot2";
    request.DeleteParams.push("delete_me");

    // Override the body:
    request.Body = "New Request body2"

    // You MUST return both the request and session metadata
    return samplePostProcessMiddleware.ReturnData(request, {});
});

// Ensure init with a post-declaration log message
log("Sample POST middleware initialised");
```

# Hooking in Unit Tests

In this example I'm using `jasmine@3.3.0`, as this was what I was most comfortable with at the time. It should be possible to use other testing frameworks to achieve a similar solution, but if you would like me to share an example using a different framework, [raise an issue on this repo][new-issue] and I'll look at creating it when I've got some time.

When writing tests, we should strive to not pollute our implementation code to make it easier to test as that can be a code smell. That being said, it is _also_ a code smell when our code is hard to test _without_ modifying it - so you need to listen to what your testing is telling you!

This meant I had some difficulty with working out how to include/execute the middleware without exposing the middleware function through i.e. Node's `module.exports`.

[Stephen Galbraith](https://lifewithcode.blogspot.com/), as he always does, had a great solution to this, which was to find a way to inject in a fake version of the `TykJS` class and let it be called to register the middleware and allow us to call it without i.e. `export`ing the function.

```js
/*
 * Fake the call to create a `NewMiddleware`:
 * `samplePostProcessMiddleware = new TykJS.TykMiddleware.NewMiddleware({});`
 */
TykJS = {
  TykMiddleware: {
    NewMiddleware: function() {
      return testHarness;
    }
  }
};
```

Note that we've left it as a global variable (without the `var`) so it correctly gets populated into the namespace of the middleware file, otherwise we receive an error similar to:

```
Suite error: samplePostProcessMiddleware
  Message:
    ReferenceError: TykJS is not defined
  Stack:
        at <Jasmine>
        at Object.<anonymous> (/home/jamie/workspaces/tyk/testing/samplePostProcessMiddleware.js:2:35)
        at Module._compile (internal/modules/cjs/loader.js:707:30)
        at Object.Module._extensions..js (internal/modules/cjs/loader.js:718:10)
        at Module.load (internal/modules/cjs/loader.js:605:32)
        at tryModuleLoad (internal/modules/cjs/loader.js:544:12)
        at Function.Module._load (internal/modules/cjs/loader.js:536:3)
        at Module.require (internal/modules/cjs/loader.js:643:17)
        at require (internal/modules/cjs/helpers.js:22:18)
        at Suite.<anonymous> (/home/jamie/workspaces/tyk/testing/spec/spec.js:49:36)
        at <Jasmine>
No specs found
Finished in 0.004 seconds
```

Now, we need to actually specify what the `testHarness` we're returning is. This will let us capture the `callback` that is being registered, so we can then invoke it separately. We also need to expose the `ReturnData` function, which TYKJS middleware expects to call, and may as well return the data in the same way that Tyk does (internally):

```js
/*
 * A fake `NewMiddleware` to make it easier for us to test. `NewProcessRequest`
 * and `ReturnData` are required by the fake `TykJS` to hook in the middleware,
 * and then return the correctly formatted response object to TYK's JSVM.
 */
var testHarness = {
  // captured to allow us to invoke it separately
  callback: null,
  NewProcessRequest: function(callback) {
    this.callback = callback;
  },
  ReturnData: function(request, metadata) {
    return {
      Request: request,
      SessionMeta: metadata
    };
  }
};
```

Now we have our test harness hooked in, we need to add our full test case!

```js
// https://stackoverflow.com/a/5533226/2257038
function obj_length(obj) {
  return Object.keys(obj).length;
}

describe('samplePostProcessMiddleware', function() {
  var req = null;
  beforeEach(function() {
    // fake out the `req` object that gets passed into the middleware
    // function for the requirements of our test the schema of the
    // `Request` object can be found at
    // https://tyk.io/docs/customise-tyk/plugins/javascript-middleware/middleware-scripting-guide/#the-request-object
    req = {
      AddParams: {},
      DeleteParams: [],
      SetHeaders: {},
      Body: ''
    }
  });

  var samplePostProcessMiddleware = require('../samplePostProcessMiddleware');
  it('affects our incoming request', function() {
    // given

    // when
    var ret = testHarness.callback(req, {});

    // then
    expect(obj_length(ret.Request.SetHeaders)).toEqual(1);
    expect(ret.Request.SetHeaders['User-Agent']).toEqual('Tyk-Custom-JSVM-Middleware');

    expect(obj_length(ret.Request.AddParams)).toEqual(1);
    expect(ret.Request.AddParams['test_param']).toEqual('My Teapot2');

    expect(obj_length(ret.Request.DeleteParams)).toEqual(1);
    expect(ret.Request.DeleteParams[0]).toEqual('delete_me');

    expect(ret.Request.Body).toEqual('New Request body2');

    expect(ret.SessionMeta).toEqual({});
  });
});
```

Running this gives us an error, oops!

```
Suite error: samplePostProcessMiddleware
  Message:
    ReferenceError: log is not defined
  Stack:
        at <Jasmine>
        at Object.<anonymous> (/home/jamie/workspaces/tyk/testing/samplePostProcessMiddleware.js:27:1)
        at Module._compile (internal/modules/cjs/loader.js:707:30)
        at Object.Module._extensions..js (internal/modules/cjs/loader.js:718:10)
        at Module.load (internal/modules/cjs/loader.js:605:32)
        at tryModuleLoad (internal/modules/cjs/loader.js:544:12)
        at Function.Module._load (internal/modules/cjs/loader.js:536:3)
        at Module.require (internal/modules/cjs/loader.js:643:17)
        at require (internal/modules/cjs/helpers.js:22:18)
        at Suite.<anonymous> (/home/jamie/workspaces/tyk/testing/spec/spec.js:57:36)
        at <Jasmine>
No specs found
Finished in 0.005 seconds
Randomized with seed 47303 (jasmine --random=true --seed=47303)
```

We'll hook in a Jasmine spy so we can verify that calls to the `log` function works - we only spy and not stub because we don't ever have i.e. a return value from `log`, so there's nothing we need to verify there. We simply need to make the following changes:

```diff
+/*
+ * Spy on the `log` function to ensure that it's called correctly. Don't bother
+ * stubbing as we're only expecting calls to it, not return values from it.
+ */
+log = jasmine.createSpy('log()');
+
 // https://stackoverflow.com/a/5533226/2257038
 function obj_length(obj) {
   return Object.keys(obj).length;
 }

 describe('samplePostProcessMiddleware', function() {
   var req = null;
   beforeEach(function() {
     // fake out the `req` object that gets passed into the middleware
     // function for the requirements of our test the schema of the
     // `Request` object can be found at
     // https://tyk.io/docs/customise-tyk/plugins/javascript-middleware/middleware-scripting-guide/#the-request-object
     req = {
       AddParams: {},
       DeleteParams: [],
       SetHeaders: {},
       Body: ''
     }
   });

   var samplePostProcessMiddleware = require('../samplePostProcessMiddleware');
   it('affects our incoming request', function() {
     // given

     // when
     var ret = testHarness.callback(req, {});

     // then
+    expect(log).toHaveBeenCalledWith("Sample POST middleware initialised");
+    expect(log).toHaveBeenCalledWith("Running sample  POST PROCESSOR JSVM middleware");
+
     expect(obj_length(ret.Request.SetHeaders)).toEqual(1);
     expect(ret.Request.SetHeaders['User-Agent']).toEqual('Tyk-Custom-JSVM-Middleware');
```

This then gives us a green test run, woo!

```
1 spec, 0 failures
Finished in 0.012 seconds
Randomized with seed 62316 (jasmine --random=true --seed=62316)
```

And that's it, it's as simple as injecting in some fake code, and leaving our existing code untouched.

[middleware]: https://tyk.io/docs/customise-tyk/plugins/javascript-middleware/javascript-api/
[TYK API Gateway]: https://tyk.io/
[samplePostProcessMiddleware]: https://github.com/TykTechnologies/tyk/blob/v2.7.4/middleware/samplePostProcessMiddleware.js
[unit-test-tykjs]: https://gitlab.com/jamietanna/unit-test-tykjs
[new-issue]: https://gitlab.com/jamietanna/jvt.me/issues/new
[blogumentation]: {{< ref 2017-06-25-blogumentation >}}
[Auth0]: https://auth0.com/
[`api.jvt.me`]: /projects/api.jvt.me
[IndieAuth]: https://indieweb.org/indieauth
