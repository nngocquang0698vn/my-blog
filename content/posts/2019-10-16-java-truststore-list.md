---
title: "Listing the Contents of a Java Truststore"
description: "How to extract a list of trusted certificates from a Java Trust store."
tags:
- blogumentation
- java
- certificates
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-10-16T13:23:07+0100
slug: "java-truststore-list"
---
If you want to inspect what certificates your Java application/installation trusts, you'll want to look inside the trust store (commonly referred to as `cacerts`, but can be called different things too).

Note that depending on the permissions on the file, you may need to prefix this with `sudo`.

Also note that the output of the following commands is trimmed for brevity, only showing a single certificate.

# Providing the `storepass`

Note that it is possible to inspect the truststore's contents without providing the password for the store, but you will get the warning:

```
*****************  WARNING WARNING WARNING  *****************
* The integrity of the information stored in your keystore  *
* has NOT been verified!  In order to verify its integrity, *
* you must provide your keystore password.                  *
*****************  WARNING WARNING WARNING  *****************
```

This is very important to verify that it's actually set up as you'd expect, but you may not care, so can instead provide an empty password to not perform these validity checks.

# Listing Certificates and Their Fingerprints

By running the following command, we can get the list of certs, with the certificate alias for the certificate within the trust store, as well as a fingerprint:

```
$ keytool -list /path/to/truststore -storepass ${STOREPASS}
Keystore type: jks
Keystore provider: SUN

Your keystore contains 137 entries

digicertassuredidrootca, 13-Oct-2019, trustedCertEntry,
Certificate fingerprint (SHA1): 05:63:B8:63:0D:62:D7:5A:BB:C8:AB:1E:4B:DF:B5:A8:99:B2:4D:43
```

# Viewing the PEM-encoded Certificates

If you want to be able to view the certificate's information as well as the PEM-encoded certificate details, you will want to use the ["RFC style" output](https://docs.oracle.com/javase/7/docs/technotes/tools/solaris/keytool.html#EncodeCertificate):

```
$ keytool -list /path/to/truststore -storepass ${STOREPASS} -rfc
Keystore type: jks
Keystore provider: SUN

Your keystore contains 137 entries

Alias name: digicertassuredidrootca
Creation date: 13-Oct-2019
Entry type: trustedCertEntry

-----BEGIN CERTIFICATE-----
MIIDtzCCAp+gAwIBAgIQDOfg5RfYRv6P5WD8G/AwOTANBgkqhkiG9w0BAQUFADBl
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJv
b3QgQ0EwHhcNMDYxMTEwMDAwMDAwWhcNMzExMTEwMDAwMDAwWjBlMQswCQYDVQQG
EwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNl
cnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3QgQ0EwggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCtDhXO5EOAXLGH87dg+XESpa7c
JpSIqvTO9SA5KFhgDPiA2qkVlTJhPLWxKISKityfCgyDF3qPkKyK53lTXDGEKvYP
mDI2dsze3Tyoou9q+yHyUmHfnyDXH+Kx2f4YZNISW1/5WBg1vEfNoTb5a3/UsDg+
wRvDjDPZ2C8Y/igPs6eD1sNuRMBhNZYW/lmci3Zt1/GiSw0r/wty2p5g0I6QNcZ4
VYcgoc/lbQrISXwxmDNsIumH0DJaoroTghHtORedmTpyoeb6pNnVFzF1roV9Iq4/
AUaG9ih5yLHa5FcXxH4cDrC0kqZWs72yl+2qp/C3xag/lRbQ/6GW6whfGHdPAgMB
AAGjYzBhMA4GA1UdDwEB/wQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQW
BBRF66Kv9JLLgjEtUYunpyGd823IDzAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYun
pyGd823IDzANBgkqhkiG9w0BAQUFAAOCAQEAog683+Lt8ONyc3pklL/3cmbYMuRC
dWKuh+vy1dneVrOfzM4UKLkNl2BcEkxY5NM9g0lFWJc1aRqoR+pWxnmrEthngYTf
fwk8lOa4JiwgvT2zKIn3X/8i4peEH+ll74fg38FnSbNd67IJKusm7Xi+fT8r87cm
NW1fiQG2SVufAQWbqz0lwcy2f8Lxb4bG+mRo64EtlOtCt/qMHt1i8b5QZ7dsvfPx
H2sMNgcWfzd8qVttevESRmCD1ycEvkvOl77DZypoEd+A5wwzZr8TDRRu838fYxAe
+o0bJW1sj6W3YQGx0qMmoRBxna3iw/nDmVG3KwcIzi7mULKn+gpFL6Lw8g==
-----END CERTIFICATE-----
```

You can then go on to check the [fingerprint of the certificate]({{< ref "2019-04-03-openssl-fingerprint-x509-pem" >}}) or [view the certificate's details]({{< ref "2018-11-02-viewing-x509-pem-openssl" >}}).

# Viewing the Certificates and Further Details

If you wish to see a bit more information about the certs such as the owner, issuer, validity period and information about the algorithms, without [using OpenSSL]({{< ref "2018-11-02-viewing-x509-pem-openssl" >}}), you can use the verbose mode:

```
$ keytool -list /path/to/truststore -storepass ${STOREPASS} -v
Keystore type: jks
Keystore provider: SUN

Your keystore contains 137 entries

Alias name: digicertassuredidrootca
Creation date: 13-Oct-2019
Entry type: trustedCertEntry

Owner: CN=DigiCert Assured ID Root CA, OU=www.digicert.com, O=DigiCert Inc, C=US
Issuer: CN=DigiCert Assured ID Root CA, OU=www.digicert.com, O=DigiCert Inc, C=US
Serial number: ce7e0e517d846fe8fe560fc1bf03039
Valid from: Fri Nov 10 00:00:00 GMT 2006 until: Mon Nov 10 00:00:00 GMT 2031
Certificate fingerprints:
	 MD5:  87:CE:0B:7B:2A:0E:49:00:E1:58:71:9B:37:A8:93:72
	 SHA1: 05:63:B8:63:0D:62:D7:5A:BB:C8:AB:1E:4B:DF:B5:A8:99:B2:4D:43
	 SHA256: 3E:90:99:B5:01:5E:8F:48:6C:00:BC:EA:9D:11:1E:E7:21:FA:BA:35:5A:89:BC:F1:DF:69:56:1E:3D:C6:32:5C
Signature algorithm name: SHA1withRSA
Subject Public Key Algorithm: 2048-bit RSA key
Version: 3

Extensions:

#1: ObjectId: 2.5.29.35 Criticality=false
AuthorityKeyIdentifier [
KeyIdentifier [
0000: 45 EB A2 AF F4 92 CB 82   31 2D 51 8B A7 A7 21 9D  E.......1-Q...!.
0010: F3 6D C8 0F                                        .m..
]
]

#2: ObjectId: 2.5.29.19 Criticality=true
BasicConstraints:[
  CA:true
  PathLen:2147483647
]

#3: ObjectId: 2.5.29.15 Criticality=true
KeyUsage [
  DigitalSignature
  Key_CertSign
  Crl_Sign
]

#4: ObjectId: 2.5.29.14 Criticality=false
SubjectKeyIdentifier [
KeyIdentifier [
0000: 45 EB A2 AF F4 92 CB 82   31 2D 51 8B A7 A7 21 9D  E.......1-Q...!.
0010: F3 6D C8 0F                                        .m..
]
]
```
