---
title: "Creating Signed JWTs (JWS) with Node.JS"
description: "How to use the jsonwebtoken library to create a Signed JSON Web Token (JWS) with Node.JS."
tags:
- blogumentation
- nodejs
- cli
- jwt
- json
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-02-19T19:22:29+0000
slug: "sign-jwt-nodejs"
---
When you're working with JSON Web Tokens (JWTs), you'll _almost certainly_ be validating that the contents of the token is sent by the correct service by verifying the token's signature.

However, it's also helpful to be able to create these signed JWTs for yourself, which we can do using the [jsonwebtoken library][jsonwebtoken] (v8.5.1) Node.JS library (tested using v8.5.1):

```js
const fs = require('fs');
const jwt = require('jsonwebtoken');

const args = process.argv.slice(2);

const payload = fs
  .readFileSync(args[0])
  .toString();

const secretOrPrivateKey = fs
  .readFileSync(args[1])
  .toString()
  // required to handle newlines at the end of file, otherwise jsonwebtoken
  // doesn't like it!
  .replace(/\n$/, '');

const algorithm = args[2] || 'HS256';

console.log(jwt.sign(payload, secretOrPrivateKey, {algorithm: algorithm}));
```

Which we can run like so, and will output the JWS to the console:

```sh
$ node sign.js payload.json file-with-secret 'HS256'
$ node sign.js payload.json rsa.key 'RS256'
```
