---
title: "Extract a Private Key from a Java Keystore"
description: "How to export an asymmetric `PrivateKeyEntry` entry from a Java keystore."
tags:
- blogumentation
- java
- keystore
- certificates
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-03-20T23:57:00+0000
slug: "extract-private-key-java-keystore"
---
I've written in the past about [extracting a symmetric key from a Java keystore]({{< ref 2019-08-02-extract-secret-key-java-keystore >}}), but didn't have anything to say how to do it with an asymmetric key.

Stealing shamelessly from [_How to export private key from a keystore of self-signed certificate_ on Stack Overflow](https://stackoverflow.com/questions/2640691/how-to-export-private-key-from-a-keystore-of-self-signed-certificate/2641032#2641032):

```sh
# create a more portable PKCS12 store
keytool -v -importkeystore \
  -srckeystore keystore.jks \
  -srcalias mykey \
  -srcstorepass password \
  -destkeystore keystore.p12 \
  -deststorepass password \
  -deststoretype PKCS12
# dump the keys
openssl pkcs12 -in keystore.p12 -nocerts -nodes
Enter Import Password:
MAC verified OK
Bag Attributes
    friendlyName: mykey
    localKeyID: 54 69 6D 65 20 31 32 37 31 32 37 38 35 37 36 32 35 37
Key Attributes: <No Attributes>
-----BEGIN PRIVATE KEY-----
MIIE.....
...
...
...
-----END PRIVATE KEY-----
```

(Noting that the passwords do not need to be the same)

If you want to import from a non-JKS store, remember to add the appropriate `-srcstoretype` argument when creating your new PKCS12 keystore.
