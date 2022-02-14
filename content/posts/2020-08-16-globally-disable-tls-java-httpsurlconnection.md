---
title: "Globally Disable TLS Checks with Java for `HttpsURLConnection`"
description: "How to disable TLS checks when using `HttpsURLConnection`s in Java."
tags:
- blogumentation
- java
- certificates
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-08-16T16:03:11+0100
slug: "globally-disable-tls-java-httpsurlconnection"
image: https://media.jvt.me/7e70383567.png
---
I am going to preface this article with a very strong note that **this is not a good idea**. It is horribly insecure, and will cause you problems if used without really contemplating the repercussions.

Today I've been integrating [fusionauth-jwt](https://github.com/fusionauth/fusionauth-jwt/) into [jwks-ical](https://gitlab.com/jamietanna/jwks-ical). Because I don't know how folks are going to have their certificates set up, I wanted to ensure that TLS validation was disabled when I first set up the project.

As fusionauth-jwt provides no hooks into it to customise the `HttpsURLConnection`, I needed some way to globally configure this.

By adapting [this answer from StackOverflow](https://stackoverflow.com/a/5297100/2257038), we are able to globally set it, so when the library reaches through to create a new connection it will have certificate validation disabled:

```java
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.X509TrustManager;

private void trustEveryone() {
  try {
    SSLContext context = SSLContext.getInstance("TLS");
    HttpsURLConnection.setDefaultHostnameVerifier(
        (hostname, session) -> true);
    context.init(
        null,
        new X509TrustManager[] {
          new X509TrustManager() {
            public void checkClientTrusted(X509Certificate[] chain, String authType)
                throws CertificateException {}

            public void checkServerTrusted(X509Certificate[] chain, String authType)
                throws CertificateException {}

            public X509Certificate[] getAcceptedIssuers() {
              return new X509Certificate[0];
            }
          }
        },
        new SecureRandom());
    HttpsURLConnection.setDefaultSSLSocketFactory(context.getSocketFactory());
  } catch (Exception e) {
    e.printStackTrace();
  }
}
```
