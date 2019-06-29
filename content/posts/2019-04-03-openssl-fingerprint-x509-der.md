---
title: "Viewing X.509 DER Certificate Fingerprints with OpenSSL"
description: "How to view an X.509 DER certificate's fingerprint using `openssl` commands."
tags:
- blogumentation
- certificates
- command-line
- der
- openssl
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-04-03T19:10:00+01:00
slug: "openssl-fingerprint-x509-der"
---
Let's say that we have a certificate in a file, such as `cert.crt`:

```
$ file cert.crt
cert.crt: data
```

If we want to get its fingerprint, we can run the following:

```
$ openssl x509 -in cert.crt -inform DER -noout -fingerprint
SHA1 Fingerprint=E0:A3:FE:07:AB:BA:A5:4D:C6:67:52:00:20:D1:DF:F9:1B:E7:B3:E7
```

Or if we want the SHA256 fingerprint:

```
$ openssl x509 -in cert.crt -inform DER -noout -fingerprint -sha256
SHA256 Fingerprint=B3:5D:6C:8A:56:A3:D0:F6:AE:F2:A8:60:C0:EE:3F:72:8A:80:F4:F6:32:49:13:DD:7D:B5:D0:2F:8F:66:26:6B
```
