---
title: "Viewing X.509 PEM Certificate Details with OpenSSL"
description: How to convert an X.509 PEM file to a human-readable format using `openssl` commands.
categories:
- blogumentation
- certificates
tags:
- blogumentation
- certificates
- command-line
- pem
- openssl
date: 2018-11-02T00:00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: viewing-x509-pem-openssl
---
Let's say that we have a certificate in a file, such as `cert.pem`:

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

We want to determine what the cert is for, but don't speak raw X.509, so we can use OpenSSL to help us here.

```
$ openssl x509 -in cert.cer -noout -text
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            03:dd:6a:fc:5e:96:e2:01:6b:4e:07:5d:1d:5b:fc:c5:b6:62
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3
        Validity
            Not Before: Oct 12 05:51:59 2018 GMT
            Not After : Jan 10 05:51:59 2019 GMT
        Subject: CN = www.jvt.me
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:f1:de:15:c2:81:6b:b2:59:49:67:11:f1:b0:d0:
                    52:4f:7d:6c:09:b3:5b:bf:eb:89:30:12:48:8c:fe:
                    61:cb:98:c6:4f:68:ff:65:39:ab:93:ca:53:7a:66:
                    a1:1f:55:0d:c8:3f:2f:c0:7f:e1:18:8f:c2:da:82:
                    34:d9:0f:87:ec:58:25:86:6c:41:3a:1d:1c:b7:93:
                    1d:97:c1:5a:e8:f8:7a:eb:b5:30:b6:bf:d1:6f:40:
                    a4:87:ce:9e:a3:47:1a:72:fd:35:d4:ec:3e:7c:eb:
                    6d:2c:77:fa:14:47:41:a2:c2:35:4d:c3:63:6f:c9:
                    c9:70:61:da:7e:52:1f:a5:df:8c:8d:8d:f6:47:35:
                    1d:51:78:13:40:43:1f:06:f8:0b:5b:97:8e:0f:d1:
                    dd:b3:a2:bd:f0:fb:6d:40:b1:b4:8b:5d:7b:22:cd:
                    6b:18:90:0c:ea:a6:77:ce:4c:d4:d5:ae:a0:04:0e:
                    08:ce:c7:e5:92:ca:51:e4:ce:af:73:0e:2b:b5:ca:
                    18:af:ab:27:f5:37:7e:8a:28:67:53:53:2e:91:eb:
                    c9:36:43:62:70:c7:de:9b:7e:95:7f:f1:8b:4f:51:
                    81:14:44:66:12:8a:84:e4:6c:e5:6f:38:ca:7d:62:
                    f8:01:5e:1a:cd:a5:27:23:cc:6a:1d:ce:c5:b1:a4:
                    6c:87
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage:
                TLS Web Server Authentication, TLS Web Client Authentication
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Subject Key Identifier:
                A8:47:3B:22:98:5B:56:AB:76:57:E7:1F:15:75:5F:37:09:91:55:67
            X509v3 Authority Key Identifier:
                keyid:A8:4A:6A:63:04:7D:DD:BA:E6:D1:39:B7:A6:45:65:EF:F3:A8:EC:A1

            Authority Information Access:
                OCSP - URI:http://ocsp.int-x3.letsencrypt.org
                CA Issuers - URI:http://cert.int-x3.letsencrypt.org/

            X509v3 Subject Alternative Name:
                DNS:www.jvt.me
            X509v3 Certificate Policies:
                Policy: 2.23.140.1.2.1
                Policy: 1.3.6.1.4.1.44947.1.1.1
                  CPS: http://cps.letsencrypt.org
                  User Notice:
                    Explicit Text: This Certificate may only be relied upon by Relying Parties and only in accordance with the Certificate Policy found at https://letsencrypt.org/repository/

            CT Precertificate SCTs:
                Signed Certificate Timestamp:
                    Version   : v1 (0x0)
                    Log ID    : E2:69:4B:AE:26:E8:E9:40:09:E8:86:1B:B6:3B:83:D4:
                                3E:E7:FE:74:88:FB:A4:8F:28:93:01:9D:DD:F1:DB:FE
                    Timestamp : Oct 12 06:51:59.907 2018 GMT
                    Extensions: none
                    Signature : ecdsa-with-SHA256
                                30:44:02:20:40:1B:0F:40:86:BA:7C:87:9A:2C:2A:B3:
                                D2:46:E3:99:62:F2:66:11:D9:4E:96:02:DC:78:35:57:
                                4D:1C:0C:8E:02:20:34:6C:14:15:DE:62:30:65:61:E7:
                                44:C1:E9:7F:0A:D4:3B:81:8A:62:32:E7:9A:10:6A:64:
                                39:E2:6F:10:C2:41
                Signed Certificate Timestamp:
                    Version   : v1 (0x0)
                    Log ID    : 29:3C:51:96:54:C8:39:65:BA:AA:50:FC:58:07:D4:B7:
                                6F:BF:58:7A:29:72:DC:A4:C3:0C:F4:E5:45:47:F4:78
                    Timestamp : Oct 12 06:51:59.923 2018 GMT
                    Extensions: none
                    Signature : ecdsa-with-SHA256
                                30:45:02:20:38:82:53:95:CC:20:80:F7:81:0E:9C:40:
                                12:2D:61:E2:FC:62:2F:5E:E1:97:B6:E6:04:E0:ED:7E:
                                2E:9A:E8:98:02:21:00:ED:43:38:07:6C:BE:65:49:FB:
                                D1:98:D6:D2:B7:AE:2E:E7:73:47:8F:08:08:F3:CC:AF:
                                90:B1:C6:0C:A7:AA:04
    Signature Algorithm: sha256WithRSAEncryption
         0a:e4:3d:93:68:4a:b1:7d:18:ae:33:8f:ac:5a:a6:eb:b9:6d:
         2f:20:71:72:ba:46:96:e2:5e:87:f6:51:65:8e:8b:6f:c6:a2:
         8d:15:98:e0:4b:c1:ab:b1:bb:7a:d9:04:d9:d4:d5:60:a0:61:
         f5:ac:95:fc:10:0c:71:b4:22:2a:60:b0:d9:b3:20:1f:84:3f:
         56:6c:3e:03:00:3e:b4:0a:1f:f7:a5:ef:d4:a9:c6:bc:00:b0:
         e5:86:13:09:11:81:0f:92:b3:ec:aa:38:e6:52:83:a6:4b:82:
         c5:89:26:22:dd:4c:16:a7:b0:83:51:b8:fb:7a:48:65:7a:b2:
         d4:bd:d0:f3:33:1c:47:51:bf:e6:d0:7c:63:49:53:dd:df:23:
         51:70:2a:27:04:3a:80:cb:26:2d:a9:9d:5d:78:34:9c:5e:4a:
         c5:e2:ad:b1:fe:51:6f:e6:55:6c:83:95:88:e4:3e:2a:e6:94:
         f3:cb:1d:bd:5f:51:9d:0a:10:a3:f5:2e:26:79:d4:22:41:29:
         6f:b0:fe:a6:23:da:78:38:e3:d0:f3:ea:14:9a:90:02:fa:30:
         04:6a:5b:0a:77:68:bf:f4:bd:97:02:8b:a1:19:ed:00:86:da:
         22:e8:2c:cc:92:d2:7f:30:3a:43:02:1f:43:a6:7a:8d:d0:fe:
         d1:de:f1:80
```

We can see all sorts of interesting information, such as the `Subject: CN = www.jvt.me`, and that `X509v3 Subject Alternative Name: DNS:www.jvt.me`.
