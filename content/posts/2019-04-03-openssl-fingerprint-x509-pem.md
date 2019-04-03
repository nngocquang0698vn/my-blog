---
title: "Viewing X.509 PEM Certificate Fingerprints with OpenSSL"
description: "How to view an X.509 PEM certificate's fingerprint using `openssl` commands."
categories:
- blogumentation
- certificates
tags:
- blogumentation
- certificates
- command-line
- pem
- openssl
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-04-03T19:10:00+01:00
slug: "openssl-fingerprint-x509-pem"
---
Let's say that we have a certificate in a file, such as `cert.crt`:

```
-----BEGIN CERTIFICATE-----
MIIF/jCCBOagAwIBAgISA91q/F6W4gFrTgddHVv8xbZiMA0GCSqGSIb3DQEBCwUA
MEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQD
ExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMzAeFw0xODEwMTIwNTUxNTlaFw0x
OTAxMTAwNTUxNTlaMBUxEzARBgNVBAMTCnd3dy5qdnQubWUwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQDx3hXCgWuyWUlnEfGw0FJPfWwJs1u/64kwEkiM
/mHLmMZPaP9lOauTylN6ZqEfVQ3IPy/Af+EYj8LagjTZD4fsWCWGbEE6HRy3kx2X
wVro+HrrtTC2v9FvQKSHzp6jRxpy/TXU7D58620sd/oUR0GiwjVNw2NvyclwYdp+
Uh+l34yNjfZHNR1ReBNAQx8G+Atbl44P0d2zor3w+21AsbSLXXsizWsYkAzqpnfO
TNTVrqAEDgjOx+WSylHkzq9zDiu1yhivqyf1N36KKGdTUy6R68k2Q2Jwx96bfpV/
8YtPUYEURGYSioTkbOVvOMp9YvgBXhrNpScjzGodzsWxpGyHAgMBAAGjggMRMIID
DTAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMC
MAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFKhHOyKYW1ardlfnHxV1XzcJkVVnMB8G
A1UdIwQYMBaAFKhKamMEfd265tE5t6ZFZe/zqOyhMG8GCCsGAQUFBwEBBGMwYTAu
BggrBgEFBQcwAYYiaHR0cDovL29jc3AuaW50LXgzLmxldHNlbmNyeXB0Lm9yZzAv
BggrBgEFBQcwAoYjaHR0cDovL2NlcnQuaW50LXgzLmxldHNlbmNyeXB0Lm9yZy8w
FQYDVR0RBA4wDIIKd3d3Lmp2dC5tZTCB/gYDVR0gBIH2MIHzMAgGBmeBDAECATCB
5gYLKwYBBAGC3xMBAQEwgdYwJgYIKwYBBQUHAgEWGmh0dHA6Ly9jcHMubGV0c2Vu
Y3J5cHQub3JnMIGrBggrBgEFBQcCAjCBngyBm1RoaXMgQ2VydGlmaWNhdGUgbWF5
IG9ubHkgYmUgcmVsaWVkIHVwb24gYnkgUmVseWluZyBQYXJ0aWVzIGFuZCBvbmx5
IGluIGFjY29yZGFuY2Ugd2l0aCB0aGUgQ2VydGlmaWNhdGUgUG9saWN5IGZvdW5k
IGF0IGh0dHBzOi8vbGV0c2VuY3J5cHQub3JnL3JlcG9zaXRvcnkvMIIBAwYKKwYB
BAHWeQIEAgSB9ASB8QDvAHUA4mlLribo6UAJ6IYbtjuD1D7n/nSI+6SPKJMBnd3x
2/4AAAFmZwvSIwAABAMARjBEAiBAGw9Ahrp8h5osKrPSRuOZYvJmEdlOlgLceDVX
TRwMjgIgNGwUFd5iMGVh50TB6X8K1DuBimIy55oQamQ54m8QwkEAdgApPFGWVMg5
ZbqqUPxYB9S3b79Yeily3KTDDPTlRUf0eAAAAWZnC9IzAAAEAwBHMEUCIDiCU5XM
IID3gQ6cQBItYeL8Yi9e4Ze25gTg7X4umuiYAiEA7UM4B2y+ZUn70ZjW0reuLudz
R48ICPPMr5CxxgynqgQwDQYJKoZIhvcNAQELBQADggEBAArkPZNoSrF9GK4zj6xa
puu5bS8gcXK6RpbiXof2UWWOi2/Goo0VmOBLwauxu3rZBNnU1WCgYfWslfwQDHG0
IipgsNmzIB+EP1ZsPgMAPrQKH/el79SpxrwAsOWGEwkRgQ+Ss+yqOOZSg6ZLgsWJ
JiLdTBansINRuPt6SGV6stS90PMzHEdRv+bQfGNJU93fI1FwKicEOoDLJi2pnV14
NJxeSsXirbH+UW/mVWyDlYjkPirmlPPLHb1fUZ0KEKP1LiZ51CJBKW+w/qYj2ng4
49Dz6hSakAL6MARqWwp3aL/0vZcCi6EZ7QCG2iLoLMyS0n8wOkMCH0Omeo3Q/tHe
8YA=
-----END CERTIFICATE-----
```
If we want to get its fingerprint, we can run the following:

```
$ openssl x509 -in cert.crt -noout -fingerprint
SHA1 Fingerprint=6A:CB:26:1F:39:31:72:D8:7F:A3:99:7C:EC:86:56:97:59:A8:52:8A
```

Or if we want the SHA256 fingerprint:

```
$ openssl x509 -in cert.crt -noout -fingerprint -sha256
SHA256 Fingerprint=B9:76:75:E4:9A:53:F6:BA:37:AA:D5:D1:38:11:65:DD:1F:5D:9F:9C:DE:52:3C:38:28:B5:4D:B0:96:34:17:7F
```
