---
title: "Verifying Signed JWTs (JWS) with Node.JS"
description: "How to use the jsonwebtoken and node-jose libraries to verify the signature of a Signed JSON Web Token (JWS) with Node.JS."
categories:
- blogumentation
tags:
- blogumentation
- node
- cli
- jwt
- json
image: /img/vendor/jwt.io.jpg
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-02-25
slug: "verify-signed-jwt-nodejs"
---
When you're working with JSON Web Tokens (JWTs), you'll _almost certainly_ be validating that the contents of the token is sent by the correct service by verifying the token's signature.

However if these are, for instance, access tokens, you **should not** be putting them into an online tool like [JWT.io] as you pose a risk of information leakage, as well as potentially compromising accounts!

Even though the website says it should be done client-side, it's still a bad practice to randomly copy-paste potentially dangerous data around.

So how do you easily validate the signature, without it touching an easy-to-use service? Below you can find a simple code snippet to do the work for you using Node.JS' [jsonwebtoken][jsonwebtoken] and [node-jose] libraries.

# Using jsonwebtoken

The below code will verify the signature and then return a process error code if the signature does not match, using the [jsonwebtoken library][jsonwebtoken] (v8.5.0):

```js
const fs = require('fs');
const jwt = require('jsonwebtoken');

const args = process.argv.slice(2);

const publicKey = fs.readFileSync(args[1]);

theJwt = fs
	.readFileSync(args[0])
	.toString()
	// required to handle newlines at the end of file, otherwise jsonwebtoken
	// doesn't like it!
	.replace(/\n$/, '');

try {
	jwt.verify(theJwt, publicKey);
} catch (e) {
	process.exit(1);
}
```

Which we can see in action below:

```
$ node sig.js valid.jwt public.pem
$ echo $?
0
$ node sig.js invalid.jwt public.pem
$ echo $?
1
```

# Using node-jose

The below code will verify the signature and then return a process error code if the signature does not match, using the [node-jose library][node-jose] (v1.1.1):

```js
const fs = require('fs');
const jose = require('node-jose');

const args = process.argv.slice(2);

const jwt = fs.readFileSync(args[0]).toString();
const publicKey = fs.readFileSync(args[1]);

(async () => {
	const key = await jose.JWK.asKey(publicKey, 'pem');
	const verifier = jose.JWS.createVerify(key);
	const verified = await verifier
		.verify(jwt)
		.catch(()=>{});
	// coerce to a truthy value
	const isVerified = !!verified;
	process.exit(false == isVerified);
})();
```

Which we can see in action below:

```
$ node sig.js valid.jwt public.pem
$ echo $?
0
$ node sig.js invalid.jwt public.pem
$ echo $?
1
```

As we can see, very straightforward!

Note: You will notice that this expects the `publicKey` to be a PEM file. If you wish to amend this, please consult the node-jose docs.

# Setup

The example data here has been adapted from data in [JWT.io].

The public key to be used for verification is:

```
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDdlatRjRjogo3WojgGHFHYLugd
UWAY9iR3fy4arWNA1KoS8kVw33cJibXr8bvwUAUparCwlvdbH6dvEOfou0/gCFQs
HUfQrSDv+MuSUMAe8jzKE4qW+jK+xQU9a03GUnKHkkle+Q0pX/g6jXZ7r1/xAK5D
o2kQ+X5xK9cipRgEKwIDAQAB
-----END PUBLIC KEY-----
```

And the private key that was used to sign the tokens is:

```
-----BEGIN RSA PRIVATE KEY-----
MIICWwIBAAKBgQDdlatRjRjogo3WojgGHFHYLugdUWAY9iR3fy4arWNA1KoS8kVw
33cJibXr8bvwUAUparCwlvdbH6dvEOfou0/gCFQsHUfQrSDv+MuSUMAe8jzKE4qW
+jK+xQU9a03GUnKHkkle+Q0pX/g6jXZ7r1/xAK5Do2kQ+X5xK9cipRgEKwIDAQAB
AoGAD+onAtVye4ic7VR7V50DF9bOnwRwNXrARcDhq9LWNRrRGElESYYTQ6EbatXS
3MCyjjX2eMhu/aF5YhXBwkppwxg+EOmXeh+MzL7Zh284OuPbkglAaGhV9bb6/5Cp
uGb1esyPbYW+Ty2PC0GSZfIXkXs76jXAu9TOBvD0ybc2YlkCQQDywg2R/7t3Q2OE
2+yo382CLJdrlSLVROWKwb4tb2PjhY4XAwV8d1vy0RenxTB+K5Mu57uVSTHtrMK0
GAtFr833AkEA6avx20OHo61Yela/4k5kQDtjEf1N0LfI+BcWZtxsS3jDM3i1Hp0K
Su5rsCPb8acJo5RO26gGVrfAsDcIXKC+bQJAZZ2XIpsitLyPpuiMOvBbzPavd4gY
6Z8KWrfYzJoI/Q9FuBo6rKwl4BFoToD7WIUS+hpkagwWiz+6zLoX1dbOZwJACmH5
fSSjAkLRi54PKJ8TFUeOP15h9sQzydI8zJU+upvDEKZsZc/UhT/SySDOxQ4G/523
Y0sz/OZtSWcol/UMgQJALesy++GdvoIDLfJX5GBQpuFgFenRiRDabxrE9MNUZ2aP
FaFp+DyAe+b4nDwuJaW2LURbr8AEZga7oQj0uYxcYw==
-----END RSA PRIVATE KEY-----
```

A JWS with a valid signature:

```
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.TCYt5XsITJX1CxPCT8yAV-TVkIEq_PbChOMqsLfRoPsnsgw5WEuts01mq-pQy7UJiN5mgRxD-WUcX16dUEMGlv50aqzpqh4Qktb3rk-BuQy72IFLOqV0G_zS245-kronKb78cPN25DGlcTwLtjPAYuNzVBAh4vGHSrQyHUdBBPM
```

Which has contents:

```json
{
	"alg": "RS256",
	"typ": "JWT"
}
{
	"sub": "1234567890",
	"name": "John Doe",
	"admin": true,
	"iat": 1516239022
}
```

A JWS with an invalid signature:

```
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkphbmUgRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.TCYt5XsITJX1CxPCT8yAV-TVkIEq_PbChOMqsLfRoPsnsgw5WEuts01mq-pQy7UJiN5mgRxD-WUcX16dUEMGlv50aqzpqh4Qktb3rk-BuQy72IFLOqV0G_zS245-kronKb78cPN25DGlcTwLtjPAYuNzVBAh4vGHSrQyHUdBBPM
```

Which has the contents:

```json
{
	"alg": "RS256",
	"typ": "JWT"
}
{
	"sub": "1234567890",
	"name": "Jane Doe",
	"admin": true,
	"iat": 1516239022
}
```

[JWT.io]: https://jwt.io
[node-jose]: https://www.npmjs.com/package/node-jose
[jsonwebtoken]: https://www.npmjs.com/package/jsonwebtoken
