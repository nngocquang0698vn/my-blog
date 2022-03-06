---
title: "Converting an `x5c` from a JSON Web Key to a PEM with Node.JS"
description: "How to convert a JWK's `x5c` to a PEM-formatted certificate with Node.JS."
tags:
- blogumentation
- nodejs
- jwks
- jwk
- certificates
- pem
- x509
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-03-06T11:33:56+0000
slug: x5c-to-pem-node
image: https://media.jvt.me/03019529e6.png
syndication:
- "https://brid.gy/publish/twitter"
---
The [JSON Web Key (JWK) specification, RFC7517](https://tools.ietf.org/html/rfc7517#appendix-B) defines the `x5c` parameter to a JWK as the X.509 certificate chain:

```json
{"kty":"RSA",
  "use":"sig",
  "kid":"1b94c",
  "n":"vrjOfz9Ccdgx5nQudyhdoR17V-IubWMeOZCwX_jj0hgAsz2J_pqYW08
  PLbK_PdiVGKPrqzmDIsLI7sA25VEnHU1uCLNwBuUiCO11_-7dYbsr4iJmG0Q
  u2j8DsVyT1azpJC_NG84Ty5KKthuCaPod7iI7w0LK9orSMhBEwwZDCxTWq4a
  YWAchc8t-emd9qOvWtVMDC2BXksRngh6X5bUYLy6AyHKvj-nUy1wgzjYQDwH
  MTplCoLtU-o-8SNnZ1tmRoGE9uJkBLdh5gFENabWnU5m1ZqZPdwS-qo-meMv
  VfJb6jJVWRpl2SUtCnYG2C32qvbWbjZ_jBPD5eunqsIo1vQ",
  "e":"AQAB",
  "x5c":
    ["MIIDQjCCAiqgAwIBAgIGATz/FuLiMA0GCSqGSIb3DQEBBQUAMGIxCzAJB
    gNVBAYTAlVTMQswCQYDVQQIEwJDTzEPMA0GA1UEBxMGRGVudmVyMRwwGgYD
    VQQKExNQaW5nIElkZW50aXR5IENvcnAuMRcwFQYDVQQDEw5CcmlhbiBDYW1
    wYmVsbDAeFw0xMzAyMjEyMzI5MTVaFw0xODA4MTQyMjI5MTVaMGIxCzAJBg
    NVBAYTAlVTMQswCQYDVQQIEwJDTzEPMA0GA1UEBxMGRGVudmVyMRwwGgYDV
    QQKExNQaW5nIElkZW50aXR5IENvcnAuMRcwFQYDVQQDEw5CcmlhbiBDYW1w
    YmVsbDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL64zn8/QnH
    YMeZ0LncoXaEde1fiLm1jHjmQsF/449IYALM9if6amFtPDy2yvz3YlRij66
    s5gyLCyO7ANuVRJx1NbgizcAblIgjtdf/u3WG7K+IiZhtELto/A7Fck9Ws6
    SQvzRvOE8uSirYbgmj6He4iO8NCyvaK0jIQRMMGQwsU1quGmFgHIXPLfnpn
    fajr1rVTAwtgV5LEZ4Iel+W1GC8ugMhyr4/p1MtcIM42EA8BzE6ZQqC7VPq
    PvEjZ2dbZkaBhPbiZAS3YeYBRDWm1p1OZtWamT3cEvqqPpnjL1XyW+oyVVk
    aZdklLQp2Btgt9qr21m42f4wTw+Xrp6rCKNb0CAwEAATANBgkqhkiG9w0BA
    QUFAAOCAQEAh8zGlfSlcI0o3rYDPBB07aXNswb4ECNIKG0CETTUxmXl9KUL
    +9gGlqCz5iWLOgWsnrcKcY0vXPG9J1r9AqBNTqNgHq2G03X09266X5CpOe1
    zFo+Owb1zxtp3PehFdfQJ610CDLEaS9V9Rqp17hCyybEpOGVwe8fnk+fbEL
    2Bo3UPGrpsHzUoaGpDftmWssZkhpBJKVMJyf/RuP2SmmaIzmnw9JiSlYhzo
    4tpzd5rFXhjRbg4zW9C+2qok+2+qDM1iJ684gPHMIY8aLWrdgQTxkumGmTq
    gawR+N5MDtdPTEQ0XfIBc2cJEUyMTY5MPvACWpkA6SdS4xSvdXK3IVfOWA=="]
}
```

However, the form above isn't necessarily the most human-readable format, so how can we convert that to a more readable X.509 certificate, [for use with OpenSSL](/posts/2018/11/02/viewing-x509-pem-openssl/).

To do so, we can parse it using the [node-jose](https://www.npmjs.com/package/node-jose) library, convert it to a certificate, then dump the X509 certificate with its headers:

```javascript
const crypto = require('crypto')
const jose = require('node-jose')
const fs = require('fs')

const keystore = jose.JWK.createKeyStore();
keystore.add(fs.readFileSync('file.jwk'), 'json')
  .then(function(k) {
    const jwk = k.toObject();
    const cert = new crypto.X509Certificate(Buffer.from(jwk.x5c[0], 'base64'))
    console.log(cert.toString());
  });
```

Notice that we're not really using anything much from the parsed JWK, so we could just parse it as JSON.
