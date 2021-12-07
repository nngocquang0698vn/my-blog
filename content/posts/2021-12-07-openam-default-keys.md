---
title: "Extracting the Default Private / Secret Keys from OpenAM/Forgerock AM"
description: "How to retrieve the contents of the private or secret keys from an OpenAM/Forgerock AM installation."
tags:
- blogumentation
- openam
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-07T17:48:20+0000
slug: "openam-default-keys"
---
[OpenAM](https://en.wikipedia.org/wiki/OpenAM) is a very widely deployed Identity and Access Management solution.

Whether it's using a no-longer-maintained version from [the original Forgerock supported Open Source codebase](https://github.com/OpenRock/OpenAM) or the [OpenIdentityPlatform fork](https://github.com/OpenIdentityPlatform/OpenAM), or you're using the [Forgerock Access Management platform](https://www.forgerock.com/platform/access-management), you may be needing to get access to the default private keys that are baked into the product.

This hopefully isn't going to be required for your primary usage (i.e. in production) because you'll be following best practices and not using a private key that's effectively world-readable 😳 But you may, as a member of the [red team](https://en.wikipedia.org/wiki/Red_team), have found a case where a server is still using these keys, and therefore can launch an attack using these keys, or you may want to create a Proof of Concept and want to utilise the default keys as they're already handily available.

As well as being provisioned onto the server when installing (Open)AM, they're actually baked into the WAR file that's used.

For example we'll look at `OpenAM-ServerOnly-14.6.4.war`, but they should be available in similar places in the commercial version:

```sh
# via https://www.jvt.me/posts/2020/02/25/unzip-jar/
unzip -l OpenAM-ServerOnly-14.6.4.war | grep keystore
        0  2021-07-28 09:18   WEB-INF/template/keystore/
     7097  2021-07-28 08:39   WEB-INF/template/keystore/keystore.jceks
     1795  2021-07-28 09:18   WEB-INF/template/keystore/README
     3568  2021-07-28 08:39   WEB-INF/template/keystore/keystore.jks
```

```sh
$ keytool -list -keystore keystore.jks -storepass changeit
Keystore type: JKS
Keystore provider: SUN

Your keystore contains 2 entries

rsajwtsigningkey, 19 May 2016, PrivateKeyEntry,
Certificate fingerprint (SHA-256): 8A:10:C2:13:8B:CC:23:EF:D6:C4:8F:74:F8:E8:B2:90:36:C2:58:E8:31:19:84:C4:15:F5:77:72:54:93:8A:C0
test, 17 Jul 2008, PrivateKeyEntry,
Certificate fingerprint (SHA-256): 39:DD:8A:4B:0F:47:4A:15:CD:EF:7A:41:C5:98:A2:10:FA:90:5F:4B:8F:F4:08:04:CE:A5:52:9F:47:E7:CF:29

$ keytool -list -keystore keystore.jceks -storepass changeit
Keystore type: JCEKS
Keystore provider: SunJCE

Your keystore contains 4 entries

rsajwtsigningkey, 24 May 2016, PrivateKeyEntry,
Certificate fingerprint (SHA-256): 32:3F:C1:67:72:9A:45:ED:F7:BC:44:5A:B8:64:79:07:CA:72:B0:77:B1:D4:3C:AC:6C:E6:C3:A7:8D:13:69:3D
selfserviceenctest, 18 Mar 2016, PrivateKeyEntry,
Certificate fingerprint (SHA-256): 80:2C:51:80:1D:B7:6A:2D:F4:78:E8:6C:71:20:E3:48:9F:06:D8:D2:C4:9E:9A:EF:2A:D2:07:10:90:B4:2F:F1
selfservicesigntest, 18 Mar 2016, SecretKeyEntry,
test, 18 Mar 2016, PrivateKeyEntry,
Certificate fingerprint (SHA-256): 79:6E:10:FE:06:D1:26:EE:E2:F6:87:95:64:06:0C:6F:29:68:D9:22:CC:2E:37:91:82:D0:94:21:D1:06:13:D1
```

You'll notice that we've got a mix of key types - we've got `PrivateKeyEntry` and `SecretKeyEntry` that we need to expose.

Fortunately, it's straightforward to extract these, so we can follow [_Extract a Private Key from a Java Keystore_](https://www.jvt.me/posts/2020/03/20/extract-private-key-java-keystore/) and [_Extract a Secret Key from a Java Keystore_](https://www.jvt.me/posts/2019/08/02/extract-secret-key-java-keystore/) to grab the keys and use them for whatever benign or nefarious reasons we want!
