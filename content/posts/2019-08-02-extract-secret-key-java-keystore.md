---
title: "Extract Secret Key Java Keystore"
description: "How to export a symmetric `SecretKey` entry from a Java keystore."
tags:
- blogumentation
- java
- keystore
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-08-02T23:43:03+0100
slug: "extract-secret-key-java-keystore"
---
Yesterday, I was trying to pull a shared secret (a `SecretKeyEntry` not a `PrivateKeyEntry`) out of a Java keystore.

I'd created it quite some time ago and annoyingly didn't have a copy of the secret stored anywhere. What I did have, however, was the `keystorepass` and the `keypass`, so wanted to pull the key out.

This was achievable using the below Java class:

```java
import java.io.FileInputStream;
import java.math.BigInteger;
import java.security.KeyStore;
import java.security.KeyStoreException;
import javax.crypto.SecretKey;

public class OutputSecretKey {
  public static void main(String[] args) throws Exception {
    final String fileName = args[0];
    final String alias = args[1];
    final char[] storepass = args[2].toCharArray();
    final char[] keypass = args[3].toCharArray();

    KeyStore ks = KeyStore.getInstance("JCEKS");

    try (FileInputStream fis = new FileInputStream(fileName)) {
      ks.load(fis, storepass);
      SecretKey secretKey = (SecretKey) ks.getKey(alias, keypass);
      String secretAsHex = new BigInteger(1, secretKey.getEncoded()).toString(16);
      System.out.println(hexToAscii(secretAsHex));
    }
  }

  /* https://www.baeldung.com/java-convert-hex-to-ascii */
  private static String hexToAscii(String hexStr) {
    StringBuilder output = new StringBuilder("");

    for (int i = 0; i < hexStr.length(); i += 2) {
      String str = hexStr.substring(i, i + 2);
      output.append((char) Integer.parseInt(str, 16));
    }

    return output.toString();
  }
}
```

This can then be run as follows:

```
$ java OutputSecretKey.java
$ java OutputSecretKey keystore.jceks alias thisisthekeystorepass thekeyhasthispassword
supersecretpassword
```

Note that this code has been adapted from [_How to display Java keystore SecretKeyEntry from command line_](https://stackoverflow.com/a/37491400/2257038) and [_Convert Hex to ASCII in Java_](https://www.baeldung.com/java-convert-hex-to-ascii).
