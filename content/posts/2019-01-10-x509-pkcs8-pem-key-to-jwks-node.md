---
title: "Converting X.509 and PKCS#8 `.pem` file to a JWKS (in Node.JS)"
description: "Converting X.509 and PKCS#8 files to JWKS format, using the `node-jose` library."
categories:
- blogumentation
- pki
tags:
- blogumentation
- pki
- nodejs
- x509
- pkcs8
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-01-10
slug: "x509-pkcs8-pem-key-to-jwks-node"
---
When working with public/private keypairs, it's most likely you'll be dealing with files most commonly ending in `.pem` (X.509 certificates). However, there are cases where you'll want to convert your traditionally formatted file to a JWKS format.

Note that **I know this is hacky** but it works, so y'know, I'm okay with that. If I just wanted to convert an X.509 key, [`rsa-pem-to-jwk`](https://github.com/OADA/rsa-pem-to-jwk) would be up to scratch, but unfortunately doesn't support PKCS#8 at this time.

# The Keys

We have two files, `x509.pem`:

```
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

And `pkcs8.key`:

```
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCpX58apOjyvovn
awgmm3jhvEuQ4NoXT/C8gv95hgMvnkf4Cn5vWril3hjJlvukBGiv/WahvqwxGecC
vmG2Y7Ve5yYoESI1j7XbPNrSr2yaMubf542qr7w+CwSoHPiVTVggF5DOwJHQ1Nrc
nc4d+v5sANXKy1B6idI+hEupKg7vygC2idBYtfUxR9L3vvz4QJzGUzbX4lpSOowP
SdBHrCXwvqhYZxHs+NyM9ADK5L8BJPLsw7RKq6emQbOP8fu4Vsr02n90sg6v1mqu
QJJ2KgD8+APKTfoTxrK4yc3UcPLhqT9DvIRfhH8LvlPQnG65iKjTqG6DDJESA5A0
gP4NVSgvAgMBAAECggEBAIZ3UdtXXVGKkYvSX5A3Eks0sFF/EeY8IwWmgqi6CkF9
yelUe3hwb/PPVaKF6ZYXof1GknqK5C2/QLXe67hfhJiprpNUtvIK+/foYlmtx+zL
yJuuO7xs9GfVW4cUKQ5vby1bSC28mIdQ1ckcx4zpvZ+FMjZkH6qJTI8xfNf6eg1H
6ZDHAwSUpbE5kSjFjxtLvJhZvGgfWX7W68jzt+kDp8u4OPzPEmRtcsRk28qY8g0z
/VqjJh6WgvuuoC7M48scBG1YevZvh7AxLO0IPaDFRthYsLQ0lyAKcHy5Nr9mJOPk
3gA+Pa2c8PkHCdMqj3lXavHIMhTocF/nD7UCJvF+wIECgYEA0bNpJzzOOgzpqaWk
b+5PuUgY9AedUsnze24AtukXaN9VY7e5BLYcbE11RGeyj8kkhpotvZQ6WrYEfvSk
fxBvoVc1q86FXiqlpwmUL+/jO4BbgESOK9eaWP1iWmWNrZpqwdnIeF3VZHfCIoFx
RV/Tb/Sp8UNSueFgCH6IVJlfwSECgYEAzsTarRYo9lLE8XvzpGzpjtrOHsnLuk2n
5GXP6M2X89BL8yc8/5Fp99m/Em9vGAOhZBK9ActZuZEGSVVhfV1ImGw17tLyQZSC
AvSzQpZSYpT9EDeZgn/oSorfUgMKppm1X4rl5Yz7lMR1khljdKt/X6gFA6ADL2h/
ARK1bBRjr08CgYEAlOfqTmN+KXiL39xwdM7rq6zHk1lo3KXtEIOfXEMOTXjxQJrw
daj/a+Rg1g8wm6uAFVicDFeaTFmdvazothWsvwuXYAWJbMGp2YASyytz1wehcea8
ceNqhbB/y6L7RQA2uKp2EQrIgcwMfcYe8d1G3eQFXP2qW7XvJHj9Q92ZQiECgYAT
tMM6l9ATmdPXR/7yfsbLrKLUYFsgSGJl7CYig+WlgQacB/NSUCOPUZtaQHCQE1iA
VyDYWO8WNnIo7xA5iHhwvm9tcYFRKrwxV+z1vangZ16u+v2QaGxVHmMmR8/uDNwy
XOSIOiWICilCYVUPO4EKNtMzgz6KeCUSjxvnTxIpFQKBgGibAwYcUBQ26UK9tE44
MSJsAbJVT/cSGrst53Apox4sehXNZedYC+9VdTlhp12krRn6FstICpFJyblN/1/8
QP0MMwFzyWGvo7kZQ/AcU3+65kfxwvl4lXcjZ5FN2nx7SuJ0oUthLjdhFzq2A620
KANd/2uiLZP+ebw6Sd43IsEv
-----END PRIVATE KEY-----
```

These are both the same private key, just in different formats.

# The Code

The core of the code is below which is a command-line tool which takes two arguments - the path to the file we want to convert, and whether we want to dump the private key, too. This defaults to `false` as it can be dangerous to leak a private key - I've triple checked that the files above have been freshly generated!

```js
const jose = require('node-jose');
const fs = require('fs');

const args = process.argv.slice(2);

const key = fs.readFileSync(args[0]);
const keystore = jose.JWK.createKeyStore();

var DUMP_PRIVATE_KEY = ('true' == args[1]);

keystore
  .add(key, 'pem')
  .then(function(_) {
    const jwks = keystore.toJSON(DUMP_PRIVATE_KEY);
    console.log(JSON.stringify(jwks, null, 4));
  });
```

# The Result

This gives us a nice, [pretty-printed]({{< ref 2019-01-11-pretty-printing-json-node-cli >}}) JWKS that we can then use with other tooling - yay!

```
# get our public
$ node pem-to-jwks.js x509.pem
{
    "keys": [
        {
            "kty": "RSA",
            "kid": "288WlRQvku-zrHFmvcAW86jnTF3qsMoEUKEbteI2K4A",
            "n": "qV-fGqTo8r6L52sIJpt44bxLkODaF0_wvIL_eYYDL55H-Ap-b1q4pd4YyZb7pARor_1mob6sMRnnAr5htmO1XucmKBEiNY-12zza0q9smjLm3-eNqq-8PgsEqBz4lU1YIBeQzsCR0NTa3J3OHfr-bADVystQeonSPoRLqSoO78oAtonQWLX1MUfS9778-ECcxlM21-JaUjqMD0nQR6wl8L6oWGcR7PjcjPQAyuS_ASTy7MO0SqunpkGzj_H7uFbK9Np_dLIOr9ZqrkCSdioA_PgDyk36E8ayuMnN1HDy4ak_Q7yEX4R_C75T0JxuuYio06hugwyREgOQNID-DVUoLw",
            "e": "AQAB"
        }
    ]
}
# get our private
$ node pem-to-jwks.js x509.pem true
{
    "keys": [
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
    ]
}
```

And for our PKCS#8 key:

```
# get our public
$ node pem-to-jwks.js pkcs8.key
{
    "keys": [
        {
            "kty": "RSA",
            "kid": "288WlRQvku-zrHFmvcAW86jnTF3qsMoEUKEbteI2K4A",
            "n": "qV-fGqTo8r6L52sIJpt44bxLkODaF0_wvIL_eYYDL55H-Ap-b1q4pd4YyZb7pARor_1mob6sMRnnAr5htmO1XucmKBEiNY-12zza0q9smjLm3-eNqq-8PgsEqBz4lU1YIBeQzsCR0NTa3J3OHfr-bADVystQeonSPoRLqSoO78oAtonQWLX1MUfS9778-ECcxlM21-JaUjqMD0nQR6wl8L6oWGcR7PjcjPQAyuS_ASTy7MO0SqunpkGzj_H7uFbK9Np_dLIOr9ZqrkCSdioA_PgDyk36E8ayuMnN1HDy4ak_Q7yEX4R_C75T0JxuuYio06hugwyREgOQNID-DVUoLw",
            "e": "AQAB"
        }
    ]
}
# get our private
$ node pem-to-jwks.js pkcs8.key true
{
    "keys": [
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
    ]
}

```
