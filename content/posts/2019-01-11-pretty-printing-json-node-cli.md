---
title: "Pretty Printing JSON using Node.JS on the Command Line"
description: "Using Node.JS's JSON module to pretty print JSON objects from the command line."
categories:
- blogumentation
tags:
- blogumentation
- nodejs
- json
- pretty-print
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-01-11T00:00:00
slug: "pretty-printing-json-node-cli"
image: /img/vendor/nodejs.png
---
I've previously written about [using Python to pretty print JSON]({{< ref 2017-06-05-pretty-printing-json-cli >}}) and [an alternative using Ruby]({{< ref 2018-06-18-pretty-printing-json-ruby-cli >}}), but another I've not yet spoke about is using Node.JS.

As we saw in [Converting X.509 and PKCS#8 `.pem` file to a JWKS (in Node.JS)]({{< ref 2019-01-10-x509-pkcs8-pem-key-to-jwks-node >}}), we can use `JSON.stringify` with an argument to denote how to pretty-print the JSON:

```js
const json = {
  wibble: 'bar'
};
console.log(JSON.stringify(json, null, 4));
```

However, we can turn this into a handy one-liner with the help of the `node` executable:

```sh
node -r fs -e 'console.log(JSON.stringify(JSON.parse(fs.readFileSync("/dev/stdin", "utf-8")), null, 4));'
```

This will take in data from `stdin`, and then output a pretty-printed JSON object! Note that we need to `JSON.parse` the result from `stdin` as it will be a String, not a JSON object.
