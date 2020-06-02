---
title: "Generating JWK Thumbprints with Node.JS"
description: "How to generate JWK thumbprints with Node.JS."
tags:
- blogumentation
- nodejs
- jwk
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-02T22:34:56+0100
slug: "jwk-thumprint-node"
---
As mentioned in [_How are Open Banking Key Ids (`kid`) Generated?_]({{< ref 2020-06-02-open-banking-key-id >}}), Open Banking use the JWK thumbprints as defined by [RFC7638: JSON Web Key (JWK) Thumbprint](https://tools.ietf.org/html/rfc7638).

But these may be used in other circumstances, so it's worth knowing how to generate them. Instead of hand-rolling the generation process, we can re-use the excellent [node-jose](https://github.com/cisco/node-jose):

```js
const fs = require('fs');
const jose = require('node-jose');

const args = process.argv.slice(2);

const publicKey = fs.readFileSync(args[0]);
const hash = args[1] || 'SHA-256';

(async () => {
  const key = await jose.JWK.asKey(publicKey, 'pem');
  key.thumbprint(hash).
    then(function(print) {
      console.log(jose.util.base64url.encode(print));
    });
})();
```

This allows us to run the following:

```sh
node thumb.js path/to/public.pem       # to use default hash algorithm
node thumb.js path/to/public.pem SHA-1 # to specify our own
```
