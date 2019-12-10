---
title: "Converting a JSON Web Key to a X.509 `.pem` file (in Node.JS)"
description: "Converting a JSON Web Key (JWK) to an X.509 PEM file, using the `node-jose` library."
tags:
- blogumentation
- pki
- nodejs
- x509
- pem
- jwks
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-10T18:20:19+0000
slug: "node-jwk-to-x509-pem"
image: /img/vendor/nodejs.png
---
Yesterday I was looking at what search traffic comes to my site, and found that I get a number of hits from folks searching for "converting a JSON Web Key / JWKS to a PEM file".

This links in nicely with my article [_Converting X.509 and PKCS#8 `.pem` file to a JWKS (in Node.JS)_]({{< ref "2019-01-10-x509-pkcs8-pem-key-to-jwks-node" >}}), but I didn't have anything set up for the other way around, so I thought I'd write that up!

# The Keys

Let us say that we have the two [JSON Web Key](https://tools.ietf.org/html/rfc7517) formatted keys, `private.jwk`:

```json
{
  "kty": "RSA",
  "kid": "288WlRQvku-zrHFmvcAW86jnTF3qsMoEUKEbteI2K4A",
  "n": "qV-fGqTo8r6L52sIJpt44bxLkODaF0_wvIL_eYYDL55H-Ap-b1q4pd4YyZb7pARor_1mob6sMRnnAr5htmO1XucmKBEiNY-12zza0q9smjLm3-eNqq-8PgsEqBz4lU1YIBeQzsCR0NTa3J3OHfr-bADVystQeonSPoRLqSoO78oAtonQWLX1MUfS9778-ECcxlM21-JaUjqMD0nQR6wl8L6oWGcR7PjcjPQAyuS_ASTy7MO0SqunpkGzj_H7uFbK9Np_dLIOr9ZqrkCSdioA_PgDyk36E8ayuMnN1HDy4ak_Q7yEX4R_C75T0JxuuYio06hugwyREgOQNID-DVUoLw",
  "e": "AQAB",
  "d": "hndR21ddUYqRi9JfkDcSSzSwUX8R5jwjBaaCqLoKQX3J6VR7eHBv889VooXplheh_UaSeorkLb9Atd7ruF-EmKmuk1S28gr79-hiWa3H7MvIm647vGz0Z9VbhxQpDm9vLVtILbyYh1DVyRzHjOm9n4UyNmQfqolMjzF81_p6DUfpkMcDBJSlsTmRKMWPG0u8mFm8aB9ZftbryPO36QOny7g4_M8SZG1yxGTbypjyDTP9WqMmHpaC-66gLszjyxwEbVh69m-HsDEs7Qg9oMVG2FiwtDSXIApwfLk2v2Yk4-TeAD49rZzw-QcJ0yqPeVdq8cgyFOhwX-cPtQIm8X7AgQ",
  "p": "0bNpJzzOOgzpqaWkb-5PuUgY9AedUsnze24AtukXaN9VY7e5BLYcbE11RGeyj8kkhpotvZQ6WrYEfvSkfxBvoVc1q86FXiqlpwmUL-_jO4BbgESOK9eaWP1iWmWNrZpqwdnIeF3VZHfCIoFxRV_Tb_Sp8UNSueFgCH6IVJlfwSE",
  "q": "zsTarRYo9lLE8XvzpGzpjtrOHsnLuk2n5GXP6M2X89BL8yc8_5Fp99m_Em9vGAOhZBK9ActZuZEGSVVhfV1ImGw17tLyQZSCAvSzQpZSYpT9EDeZgn_oSorfUgMKppm1X4rl5Yz7lMR1khljdKt_X6gFA6ADL2h_ARK1bBRjr08",
  "dp": "lOfqTmN-KXiL39xwdM7rq6zHk1lo3KXtEIOfXEMOTXjxQJrwdaj_a-Rg1g8wm6uAFVicDFeaTFmdvazothWsvwuXYAWJbMGp2YASyytz1wehcea8ceNqhbB_y6L7RQA2uKp2EQrIgcwMfcYe8d1G3eQFXP2qW7XvJHj9Q92ZQiE",
  "dq": "E7TDOpfQE5nT10f-8n7Gy6yi1GBbIEhiZewmIoPlpYEGnAfzUlAjj1GbWkBwkBNYgFcg2FjvFjZyKO8QOYh4cL5vbXGBUSq8MVfs9b2p4Gdervr9kGhsVR5jJkfP7gzcMlzkiDoliAopQmFVDzuBCjbTM4M-inglEo8b508SKRU",
  "qi": "aJsDBhxQFDbpQr20TjgxImwBslVP9xIauy3ncCmjHix6Fc1l51gL71V1OWGnXaStGfoWy0gKkUnJuU3_X_xA_QwzAXPJYa-juRlD8BxTf7rmR_HC-XiVdyNnkU3afHtK4nShS2EuN2EXOrYDrbQoA13_a6Itk_55vDpJ3jciwS8"
}
```

And `public.jwk`:

```json
{
  "kty": "RSA",
  "kid": "288WlRQvku-zrHFmvcAW86jnTF3qsMoEUKEbteI2K4A",
  "n": "qV-fGqTo8r6L52sIJpt44bxLkODaF0_wvIL_eYYDL55H-Ap-b1q4pd4YyZb7pARor_1mob6sMRnnAr5htmO1XucmKBEiNY-12zza0q9smjLm3-eNqq-8PgsEqBz4lU1YIBeQzsCR0NTa3J3OHfr-bADVystQeonSPoRLqSoO78oAtonQWLX1MUfS9778-ECcxlM21-JaUjqMD0nQR6wl8L6oWGcR7PjcjPQAyuS_ASTy7MO0SqunpkGzj_H7uFbK9Np_dLIOr9ZqrkCSdioA_PgDyk36E8ayuMnN1HDy4ak_Q7yEX4R_C75T0JxuuYio06hugwyREgOQNID-DVUoLw",
  "e": "AQAB"
}
```

# The Code

The core of the code is below which is a command-line tool which takes two arguments - the path to the file we want to convert, and whether we want to dump the private key, too. This defaults to `false` as it can be dangerous to leak a private key - I've triple checked that the files above have been freshly generated!

```js
const jose = require('node-jose');
const fs = require('fs');

const args = process.argv.slice(2);

const key = fs.readFileSync(args[0]);

var DUMP_PRIVATE_KEY = ('true' == args[1]);

jose.JWK.asKey(key)
  .then(function(key) {
    console.log(key.toPEM(DUMP_PRIVATE_KEY));
  });
```

# The Result

This gives us the public key by default, even if we give it the private key:

```
# get our public from the private key
$ node jwk-to-pem.js private.jwk
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqV+fGqTo8r6L52sIJpt4
4bxLkODaF0/wvIL/eYYDL55H+Ap+b1q4pd4YyZb7pARor/1mob6sMRnnAr5htmO1
XucmKBEiNY+12zza0q9smjLm3+eNqq+8PgsEqBz4lU1YIBeQzsCR0NTa3J3OHfr+
bADVystQeonSPoRLqSoO78oAtonQWLX1MUfS9778+ECcxlM21+JaUjqMD0nQR6wl
8L6oWGcR7PjcjPQAyuS/ASTy7MO0SqunpkGzj/H7uFbK9Np/dLIOr9ZqrkCSdioA
/PgDyk36E8ayuMnN1HDy4ak/Q7yEX4R/C75T0JxuuYio06hugwyREgOQNID+DVUo
LwIDAQAB
-----END PUBLIC KEY-----
# get our public from the public key
$ node jwk-to-pem.js public.jwk
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqV+fGqTo8r6L52sIJpt4
4bxLkODaF0/wvIL/eYYDL55H+Ap+b1q4pd4YyZb7pARor/1mob6sMRnnAr5htmO1
XucmKBEiNY+12zza0q9smjLm3+eNqq+8PgsEqBz4lU1YIBeQzsCR0NTa3J3OHfr+
bADVystQeonSPoRLqSoO78oAtonQWLX1MUfS9778+ECcxlM21+JaUjqMD0nQR6wl
8L6oWGcR7PjcjPQAyuS/ASTy7MO0SqunpkGzj/H7uFbK9Np/dLIOr9ZqrkCSdioA
/PgDyk36E8ayuMnN1HDy4ak/Q7yEX4R/C75T0JxuuYio06hugwyREgOQNID+DVUo
LwIDAQAB
-----END PUBLIC KEY-----
# allow outputting the private key
$ node jwk-to-pem.js private.jwk true
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAqV+fGqTo8r6L52sIJpt44bxLkODaF0/wvIL/eYYDL55H+Ap+
b1q4pd4YyZb7pARor/1mob6sMRnnAr5htmO1XucmKBEiNY+12zza0q9smjLm3+eN
qq+8PgsEqBz4lU1YIBeQzsCR0NTa3J3OHfr+bADVystQeonSPoRLqSoO78oAtonQ
WLX1MUfS9778+ECcxlM21+JaUjqMD0nQR6wl8L6oWGcR7PjcjPQAyuS/ASTy7MO0
SqunpkGzj/H7uFbK9Np/dLIOr9ZqrkCSdioA/PgDyk36E8ayuMnN1HDy4ak/Q7yE
X4R/C75T0JxuuYio06hugwyREgOQNID+DVUoLwIDAQABAoIBAQCGd1HbV11RipGL
0l+QNxJLNLBRfxHmPCMFpoKougpBfcnpVHt4cG/zz1WihemWF6H9RpJ6iuQtv0C1
3uu4X4SYqa6TVLbyCvv36GJZrcfsy8ibrju8bPRn1VuHFCkOb28tW0gtvJiHUNXJ
HMeM6b2fhTI2ZB+qiUyPMXzX+noNR+mQxwMElKWxOZEoxY8bS7yYWbxoH1l+1uvI
87fpA6fLuDj8zxJkbXLEZNvKmPINM/1aoyYeloL7rqAuzOPLHARtWHr2b4ewMSzt
CD2gxUbYWLC0NJcgCnB8uTa/ZiTj5N4APj2tnPD5BwnTKo95V2rxyDIU6HBf5w+1
AibxfsCBAoGBANGzaSc8zjoM6amlpG/uT7lIGPQHnVLJ83tuALbpF2jfVWO3uQS2
HGxNdURnso/JJIaaLb2UOlq2BH70pH8Qb6FXNavOhV4qpacJlC/v4zuAW4BEjivX
mlj9Ylplja2aasHZyHhd1WR3wiKBcUVf02/0qfFDUrnhYAh+iFSZX8EhAoGBAM7E
2q0WKPZSxPF786Rs6Y7azh7Jy7pNp+Rlz+jNl/PQS/MnPP+RaffZvxJvbxgDoWQS
vQHLWbmRBklVYX1dSJhsNe7S8kGUggL0s0KWUmKU/RA3mYJ/6EqK31IDCqaZtV+K
5eWM+5TEdZIZY3Srf1+oBQOgAy9ofwEStWwUY69PAoGBAJTn6k5jfil4i9/ccHTO
66usx5NZaNyl7RCDn1xDDk148UCa8HWo/2vkYNYPMJurgBVYnAxXmkxZnb2s6LYV
rL8Ll2AFiWzBqdmAEssrc9cHoXHmvHHjaoWwf8ui+0UANriqdhEKyIHMDH3GHvHd
Rt3kBVz9qlu17yR4/UPdmUIhAoGAE7TDOpfQE5nT10f+8n7Gy6yi1GBbIEhiZewm
IoPlpYEGnAfzUlAjj1GbWkBwkBNYgFcg2FjvFjZyKO8QOYh4cL5vbXGBUSq8MVfs
9b2p4Gdervr9kGhsVR5jJkfP7gzcMlzkiDoliAopQmFVDzuBCjbTM4M+inglEo8b
508SKRUCgYBomwMGHFAUNulCvbROODEibAGyVU/3Ehq7LedwKaMeLHoVzWXnWAvv
VXU5YaddpK0Z+hbLSAqRScm5Tf9f/ED9DDMBc8lhr6O5GUPwHFN/uuZH8cL5eJV3
I2eRTdp8e0ridKFLYS43YRc6tgOttCgDXf9roi2T/nm8OkneNyLBLw==
-----END RSA PRIVATE KEY-----
```
