---
title: Passing a private key as an environment variable
description: How to convert a PEM-encoded private key in a form to be stored in an environment variable.
tags:
- blogumentation
- shell
- certificates
date: 2023-02-11T21:21:49+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: pem-environment-variable
---
When working with private keys, one of the awkward things to deal with is how to pass them around to applications. If you're following a [twelve-factor app approach](https://12factor.net/config) where secrets are passed in via the environment variables, but as keys are multi-line there are a few options for how to wrap them into an environment varialbe.

One option is to replace the newlines with an escaped newline ([via](https://stackoverflow.com/questions/1251999/how-can-i-replace-each-newline-n-with-a-space-using-sed/1252191#1252191)):

```sh
sed ':a;N;$!ba;s/\n/\\n/g' pem.pem
```

Then, it can for instance consume it using the following Typescript code:

```typescript
const privateKey = (process.env.PRIVATE_KEY ?? '').replaceAll(/\\n/g, '\n')
```

Alternatively, we could base64-encode the key, which means we don't need to worry about (un)escaping newlines.
