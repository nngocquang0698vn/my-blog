---
title: "Unit Testing Auth0 Rules"
description: "How to write unit tests for your Auth0 Rules, without running it on an Auth0 tenant."
tags:
- blogumentation
- auth0
- unit-testing
- testing
- javascript
- nodejs
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-10-01T20:42:09+0100
slug: "unit-test-auth0-rule"
image: https://media.jvt.me/3f2f6fc169.png
---
This is a blog post I was meant to write _two years ago_. I was planning on writing it as part of [Auth0's Guest Author Program](https://auth0.com/guest-authors) but my time was limited and I ended up (very rightfully) annoying the folks at Auth0.

I looked at the code tonight and realised it's in a good place, so I thought I'd get a blog post up so if anyone happens to be looking for it, they get my solution which is still very much working.

# What are Auth0 Rules?

Auth0's Rules [are defined by their documentation](https://auth0.com/docs/rules):

> Rules are JavaScript functions that execute when a user authenticates to your application.

They're a great way to provide some value-add on top of some of the other great things that Auth0 supports, and may be for some specific functionality you need.

# Why?

This is a post in of itself, but having confidence that your code works should be pretty high on your priority list, especially as this code is underpinning your identity solution!

When building [a hack at Hackference's hackathon using Auth0](/posts/2018/12/09/hackference-2018/#hackathon), I found that, similar to my [TykJS Middleware testing article](/posts/2018/12/10/testing-tykjs-middleware/), it wasn't super obvious how to test that the rules worked.

In the [spirit of Blogumentation](/posts/2017/06/25/blogumentation/) I'm writing up my experiences as well as providing a how-to with a permissive license so you too can unit test your Auth0 Rules.

# How?

I wrote this code at the time I was planning to do the blog post, in late 2018. At the time (and still, today) I am not a Node developer, so the code below won't be following some best practices. I'd appreciate feedback!

Examples for the below code snippets can be found at [<i class="fa fa-gitlab"></i> jamietanna/unit-test-auth0-rule](https://gitlab.com/jamietanna/unit-test-auth0-rules).

Note that the below code has not been written in a way to provide a nicer test harness like [auth0-rules-testharness](https://www.npmjs.com/package/auth0-rules-testharness) - this is largely due to my lack of experience with Node and Auth0's Rules, but it'd be great to see it evolve into something better.

Auth0 have written [their own example for how to unit test Rules](https://auth0.com/docs/best-practices/rules-testing-best-practices), which follows a similar pattern (with a slightly better setup) too, but at the time I wrote these solutions didn't exist.

## `banned-client-ids`

Let's take the following example Rule, which is quite straightforward:

```js
function (user, context, callback) {
  if (context.clientID === "BANNED_CLIENT_ID") {
    return callback(new UnauthorizedError('Access to this application has been temporarily revoked'));
  }

  callback(null, user, context);
}
```

We have a bit of boilerplate to read the source file, and prepare the test harness:

```js
var fs = require('fs');

// parentheses required to make it a callable function. Only read it once for a
// slightly lower cost of I/O read usage
var contents = "(" + fs.readFileSync('banned-client-ids.js') + ")";

// because we need to hook in our global `configuration` variable, as well as
// mock out our external dependencies such as other modules
function execute_rule(user, context, callback, configuration) {
  // `eval` is required so the `configuration` variable is set correctly for
  // each execution of the Rule
  var rule = eval(contents);
  // return to the caller anything the rule has returned, although any return
  // values must be actually passed through `callback`
  return rule(user, context, callback);
}

describe('banned-client-ids.js', function() {
  // these variables to be cleared before each and every test (rather than
  // each `describe` block), so has to be in a `beforeEach` keep these three
  // set (and cleared) for each iteration
  var user = {};
  var context = {};
  var configuration = {};
  var callback = null;

  beforeEach(function() {
    user = {};
    context = {};
    configuration = {};
    callback = jasmine.createSpy('callback(a, b, c)')
      .and
      .callFake(function() {
        return 'callback';
      });
  });

  // the tests
});
```

In this case, we know we're going to throw an `UnauthorizedError`, so we need to add a fake implementation before writing our test:

```js
// required class to inject into the Rule for testing error states
function UnauthorizedError(message) {
  this.message = message;
}

// ...


it('throws error if client ID is banned', function() {
  context = {
    clientID: 'BANNED_CLIENT_ID'
  };

  var ret = execute_rule(user, context, callback, configuration);
  expect(ret).toBe('callback'); // make sure the `return` is triggered, otherwise it may fall through

  expect(callback).toHaveBeenCalledWith(jasmine.any(UnauthorizedError));
  var callbackArgs = callback.calls.argsFor(0);
  var error = callbackArgs[0];
  expect(error.message).toBe('Access to this application has been temporarily revoked');;
});
```

And a happy path test:

```js
it('succeeds if client ID is not banned', function() {
  context = {
    clientId: 'BANNED_CLIENT_ID'
  };
  var ret = execute_rule(user, context, callback, configuration);
  expect(ret).toBe(undefined); // verify that we don't do any `return`s

  expect(callback).toHaveBeenCalledWith(null, {}, context);
});
```

## `notify-slack.js`

If we take the following example Rule from Auth0:

```js
function(user, context, callback) {
  // short-circuit if the user signed up already, i.e. the user has logged in more
  // than once or is using a refresh token
  if (context.stats.loginsCount > 1 || context.protocol === 'oauth2-refresh-token') {
    return callback(null, user, context);
  }

  // get your slack's hook url from: https://slack.com/services/10525858050
  var SLACK_HOOK = configuration.SLACK_HOOK;

  var slack = require('slack-notify')(SLACK_HOOK);
  var message = 'New User: ' + (user.name || user.email) + ' (' + user.email + ')';
  var channel = '#some_channel';

  slack.success({
   text: message,
   channel: channel
  });

  // don’t wait for the Slack API call to finish, return right away (the request will continue on the sandbox)`
  callback(null, user, context);
}
```

Again, we need some boilerplate, but this time it's slightly different because we:

- need to mock out the external library dependency for `slack-notify`
- want to verify that the right `SLACK_HOOK` is sent to the module

This gives us the following:

```js
var fs = require('fs');
var mock = require('mock-require');

// parentheses required to make it a callable function. Only read it once for a
// slightly lower cost of I/O read usage
var contents = "(" + fs.readFileSync('notify-slack.js') + ")";

// because we need to hook in our global `configuration` variable, as well as
// mock out our external dependencies such as other modules
function execute_rule(user, context, callback, configuration) {
  // any modules that we test should be suitably mocked, so we don't need to
  // rely on their implementations in this unit test
  mock('slack-notify', function(SLACK_HOOK) {
    // verify we have the correct `SLACK_HOOK` called by our Rule
    expect(SLACK_HOOK).toBe(configuration.SLACK_HOOK);
    return fakeSlackNotify;
  });

  // `eval` is required so the `configuration` variable is set correctly for
  // each execution of the Rule
  var rule = eval(contents);
  // return to the caller anything the rule has returned, although any return
  // values must be actually passed through `callback`
  return rule(user, context, callback);
}

var fakeSlackNotify = null;

describe('notify-slack.js', function() {
  // these variables to be cleared before each and every test (rather than
  // each `describe` block), so has to be in a `beforeEach` keep these three
  // set (and cleared) for each iteration
  var user = {};
  var context = {};
  var configuration = {};
  var callback = null;

  beforeEach(function() {
    user = {};
    context = {};
    configuration = {};
    callback = jasmine.createSpy('callback(a, b, c)')
      .and
      .callFake(function() {
        return 'callback';
      });
    fakeSlackNotify = jasmine.createSpyObj('slack-notify', ['success']);
  });

  // the tests
});
```

We then have the ability to write a number of tests to exercise that the various codepaths are exercised correctly:

```js
describe('does not notify slack', function() {
  it('if user has logged in more than once', function() {
    context = {
      stats: {
        loginsCount: 2
      }
    };
    var ret = execute_rule(user, context, callback);
    expect(ret).toBe('callback');
    expect(callback).toHaveBeenCalledWith(null, user, context);

    expect(fakeSlackNotify.success).toHaveBeenCalledTimes(0);
  });

  it('if login is via OAuth2 refresh token', function() {
    context = {
      protocol: 'oauth2-refresh-token',
      stats: {
      }
    };
    var ret = execute_rule(user, context, callback);
    expect(ret).toBe('callback');
    expect(callback).toHaveBeenCalledWith(null, user, context);

    expect(fakeSlackNotify.success).toHaveBeenCalledTimes(0);
  });
});

describe('notifies slack', function() {
  it('if login count is 0', function() {
    configuration = {
      SLACK_HOOK: 'https://example.com/slack'
    };
    user = {
      email: 'doesnt@matter',
      name: 'John Smith'

    };
    context = {
      protocol: 'oauth2-login',
      stats: {
        loginsCount: 0
      }
    };
    var ret = execute_rule(user, context, callback, configuration);
    expect(ret).toBe(undefined);

    // note that we don't care in this case how it was called, just that
    // we do have a call
    expect(fakeSlackNotify.success).toHaveBeenCalledTimes(1);
    expect(callback).toHaveBeenCalledWith(null, user, context);
  });

  it('if login count is 1', function() {
    configuration = {
      SLACK_HOOK: 'https://example.com/slack'
    };
    user = {
      email: 'doesnt@matter',
      name: 'John Smith'

    };
    context = {
      protocol: 'oauth2-login',
      stats: {
        loginsCount: 1
      }
    };
    var ret = execute_rule(user, context, callback, configuration);
    expect(ret).toBe(undefined);

    // note that we don't care in this case how it was called, just that
    // we do have a call
    expect(fakeSlackNotify.success).toHaveBeenCalledTimes(1);
    expect(callback).toHaveBeenCalledWith(null, user, context);
  });

  it('with the user\'s name if `user.name` is set', function() {
    configuration = {
      SLACK_HOOK: 'https://example.com/slack'
    };
    user = {
      email: 'user@example.com',
      name: 'wibble'

    };
    context = {
      protocol: 'oauth2-login',
      stats: {
        loginsCount: 0
      }
    };
    var ret = execute_rule(user, context, callback, configuration);
    expect(ret).toBe(undefined);

    expect(fakeSlackNotify.success).toHaveBeenCalledWith({
      text: 'New User: wibble (user@example.com)',
      channel: '#some_channel'
    });
    expect(callback).toHaveBeenCalledWith(null, user, context);
  });

  it('with the user\'s email if `user.name` is not set', function() {
    configuration = {
      SLACK_HOOK: 'https://example.com/slack'
    };
    user = {
      email: 'user@example.com',
    };
    context = {
      protocol: 'oauth2-login',
      stats: {
        loginsCount: 0
      }
    };
    var ret = execute_rule(user, context, callback, configuration);
    expect(ret).toBe(undefined);

    expect(fakeSlackNotify.success).toHaveBeenCalledWith({
      text: 'New User: user@example.com (user@example.com)',
      channel: '#some_channel'
    });
    expect(callback).toHaveBeenCalledWith(null, user, context);
  });
});
```

And that's it! It turns out it's not _as difficult_ as it could be, but due to the Rule being a function that isn't `export`ed, it takes a little bit of working around.
