---
title: "Parsing URL Querystrings with Node.JS"
description: "How to easily parse a URL querystring with Node.JS."
tags:
- nodejs
- blogumentation
- nablopomo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-30T01:54:45+0000
slug: "node-parse-url-querystring"
image: /img/vendor/nodejs.png
series: nablopomo-2019
---
I've [previously written about _Parsing Key-Value URL Fragments with Node.JS_]({{< ref "2019-08-01-node-parse-url-fragment" >}}), but I realised earlier that I don't have an alternative for querystrings.

Following the same pattern, we can use the `url` module to actually parse our URL out, and then the `querystring` module to extract the key-value parameters for the querystring, instead of hand-rolling our own:

```js
const url = require('url');
const querystring = require('querystring');
const theUrl = 'https://example.com/auth/callback?code=foo&state=blah';
var querystringParams = querystring.parse(url.parse(theUrl).query);
console.log(querystringParams);
// Object: null prototype] { code: 'foo', state: 'blah' }
console.log(JSON.stringify(querystringParams, null, 4));
/*
{
    "code": "foo",
    "state": "blah"
}
*/
```

And for a handy one-liner:

```sh
$ echo 'https://example.com/auth/callback?code=foo&state=blah' | node -r fs -r querystring -r url -e 'console.log(JSON.stringify(querystring.parse(url.parse(fs.readFileSync("/dev/stdin", "utf-8")).query), null, 4))'
```
