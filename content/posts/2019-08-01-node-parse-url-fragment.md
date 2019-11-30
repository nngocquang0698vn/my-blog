---
title: "Parsing Key-Value URL Fragments with Node.JS"
description: "How to easily parse a URL fragment containing key-value pairs of data, with Node.JS."
tags:
- nodejs
- blogumentation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-08-01T18:08:15+0100
slug: "node-parse-url-fragment"
image: /img/vendor/nodejs.png
---
Although the URL fragment isn't defined explicitly as a key-value pair, there are times where it may be, for instance during the [OAuth2 Implicit Grant](https://tools.ietf.org/html/rfc6749#section-4.2) or the [OpenID Connect Hybrid Flow](https://openid.net/specs/openid-connect-core-1_0.html#HybridFlowAuth).

We can use the `url` module to actually parse our URL out, and then the `querystring` module to extract the key-value parameters for the fragment, instead of hand-rolling our own:

```js
const url = require('url');
const querystring = require('querystring');
const theUrl = 'https://example.com/auth/callback#code=foo&state=blah';
var fragmentParams = querystring.parse(url.parse(theUrl).hash.replace('#', ''));
console.log(fragmentParams);
// Object: null prototype] { code: 'foo', state: 'blah' }
console.log(JSON.stringify(fragmentParams, null, 4));
/*
{
    "code": "foo",
    "state": "blah"
}
*/
```

Also note that yes, this should be received by your browser, not by some Node code which runs on the backend, but for the purpose I've been testing it with, the Node code for it was important.

And for a handy one-liner:

```sh
$ echo 'https://example.com/auth/callback#code=foo&state=blah' | node -r querystring -r url -e 'console.log(JSON.stringify(querystring.parse(url.parse(fs.readFileSync("/dev/stdin", "utf-8")).hash.replace("#", "")), null, 4))'
```
