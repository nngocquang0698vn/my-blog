---
title: "Generating HMAC Signatures on the Command Line with OpenSSL"
description: "How to generate HMAC signatures for a given string, using `openssl`."
tags:
- blogumentation
- cli
- openssl
- hmac
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-02-21T08:45:08+0000
slug: "openssl-hmac"
---
Proving authenticity of a message is important, even over transport methods such as HTTPS, as we may not be able to require full end-to-end encryption. One such method of producing a signature is using HMAC with a shared secret.

For instance, let us say that we want to use SHA256 as the hashing algorithm.

If using Java, we could write code similar to the below, leveraging the [commons-codec](https://mvnrepository.com/artifact/commons-codec/commons-codec) project:

```java
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.digest.HmacAlgorithms;
import org.apache.commons.codec.digest.HmacUtils;
// ...
String digest =
    new String(
        Base64.encodeBase64String(
            new HmacUtils(HmacAlgorithms.HMAC_SHA_256, "secret-key-here")
                .hmac("value-to-digest")));
// G73zFnFYggHRpmwuRFPgch6ctqEfyhZu33j5PQWYm+4=
```

However, this doesn't help when we want to script this from the command-line, and isn't as portable.

To do this we can utilise `openssl`:

```sh
$ echo -n "value-to-digest" | openssl dgst -sha256 -hmac "secret-key-here" -binary | openssl enc -base64 -A
// G73zFnFYggHRpmwuRFPgch6ctqEfyhZu33j5PQWYm+4=
```
