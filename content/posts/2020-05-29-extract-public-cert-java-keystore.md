---
title: "Extract a Public Cert from a Java Keystore/Truststore"
description: "How to export the public certificate from a Java keystore."
tags:
- blogumentation
- java
- keystore
- certificates
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-29T22:07:13+0100
slug: "extract-public-cert-java-keystore"
---
It can be useful to pull the public certificate out of a Java keystore (maybe called a truststore in this case, as it may just store public certs).

We can pull the cert out by running the following, which will return the X509 PEM-encoded certificate:

```sh
keytool -list -alias selfsigned -rfc -keystore keystore.jks -storepass password | \
  sed -n -e '/BEGIN\ CERTIFICATE/,/END\ CERTIFICATE/ p'
```
