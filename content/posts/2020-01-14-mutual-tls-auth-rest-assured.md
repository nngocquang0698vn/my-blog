---
title: "Performing Mutual TLS Authentication with Rest Assured (via Apache HTTP Client)"
description: "How to configure Rest Assured to perform Mutual TLS authentication against an API."
tags:
- blogumentation
- certificates
- mutual-tls
- java
- rest-assured
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-01-14T19:27:21+0000
slug: "mutual-tls-auth-rest-assured"
image: https://media.jvt.me/4041b6e524.png
---
It's possible that you want to perform mutual TLS authentication to further secure your APIs.

If you're writing a Java project, it's possible you're using [Rest Assured](http://rest-assured.io/) to interact with your API.

But it's not immediately obvious how we can actually set it up within Rest Assured. I've found that the [`auth()` method, which returns an `AuthenticationSpecification`](https://www.javadoc.io/static/io.rest-assured/rest-assured/4.0.0/io/restassured/specification/AuthenticationSpecification.html), **does not seem to work** ([I have raised an issue upstream](https://github.com/rest-assured/rest-assured/issues/1325)).

# The Solution

The solution, as per [rohitkadam19's reply on _How to make HTTPS GET call with certificate in Rest-Assured java_](https://stackoverflow.com/a/37436519) is to create a custom [`org.apache.http.conn.ssl.SSLSocketFactory`](http://hc.apache.org/httpcomponents-client-ga/httpclient/apidocs/org/apache/http/conn/ssl/SSLSocketFactory.html) that can be used by Rest Assured, which will provide the client certificates.

Note: This uses a deprecated setup, which as mentioned in [an issue thread on GitHub](https://github.com/rest-assured/rest-assured/issues/1325#issuecomment-1172911836) cannot yet be updated without work in Rest Assured.

I would recommend extracting this out into a couple of helper methods which can be found below:

```java
import io.restassured.RestAssured;
import io.restassured.config.RestAssuredConfig;
import io.restassured.config.SSLConfig;
import io.restassured.specification.RequestSpecification;
import java.io.FileInputStream;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import org.apache.http.HttpStatus;
import org.apache.http.conn.ssl.SSLSocketFactory;

// ...

/*
 * Example code
 */

public static void clientCertWithKeyStore()
    throws UnrecoverableKeyException, NoSuchAlgorithmException, KeyStoreException,
        KeyManagementException {
  clientCertSpecification(
          "/path/to/keystore.jks",
          "keystore-pass")
      .log()
      .all()
      .get("https://client.badssl.com/")
      .then()
      .log()
      .all()
      .statusCode(HttpStatus.SC_OK);
}

public static void clientCertWithTrustStore()
    throws UnrecoverableKeyException, NoSuchAlgorithmException, KeyStoreException,
        KeyManagementException {
  clientCertSpecification(
          "/path/to/keystore.jks",
          "keystore-pass",
          "/path/to/truststore.jks",
          "truststore-pass")
      .log()
      .all()
      .get("https://localhost:8443")
      .then()
      .log()
      .all()
      .statusCode(HttpStatus.SC_OK);
}

/*
 * Helper methods
 */

private static RequestSpecification clientCertSpecification(
    String keyStorePath, String keyStorePass)
    throws UnrecoverableKeyException, NoSuchAlgorithmException, KeyStoreException,
        KeyManagementException {
  return clientCertSpecification(keyStorePath, keyStorePass, null, null);
}

private static RequestSpecification clientCertSpecification(
    String keyStorePath, String keyStorePass, String trustStorePath, String trustStorePass)
    throws UnrecoverableKeyException, NoSuchAlgorithmException, KeyStoreException,
        KeyManagementException {
  return clientCertSpecification(
      keyStorePath,
      keyStorePass,
      KeyStore.getDefaultType(),
      trustStorePath,
      trustStorePass,
      KeyStore.getDefaultType());
}

private static RequestSpecification clientCertSpecification(
    String keyStorePath,
    String keyStorePass,
    String keyStoreType,
    String trustStorePath,
    String trustStorePass,
    String trustStoreType)
    throws UnrecoverableKeyException, NoSuchAlgorithmException, KeyStoreException,
        KeyManagementException {

  KeyStore keyStore = loadKeyStore(keyStorePath, keyStorePass.toCharArray(), keyStoreType);
  SSLSocketFactory clientAuthFactory = new SSLSocketFactory(keyStore, keyStorePass);
  if (null != trustStorePath) {
    KeyStore trustStore =
        loadKeyStore(trustStorePath, trustStorePass.toCharArray(), trustStoreType);
    clientAuthFactory = new SSLSocketFactory(keyStore, keyStorePass, trustStore);
  }

  SSLConfig sslConfig =
      RestAssuredConfig.config().getSSLConfig().with().sslSocketFactory(clientAuthFactory);
  RestAssuredConfig config = RestAssured.config().sslConfig(sslConfig);

  return RestAssured.given().config(config);
}

private static KeyStore loadKeyStore(String path, char[] password, String storeType) {
  KeyStore keyStore;
  try {
    keyStore = KeyStore.getInstance(storeType);
    keyStore.load(new FileInputStream(path), password);
  } catch (Exception ex) {
    throw new RuntimeException("Error while extracting the keystore", ex);
  }
  return keyStore;
}

private static KeyStore loadKeyStore(String path, char[] password) {
  return loadKeyStore(path, password, KeyStore.getDefaultType());
}
```

# Testing

So how can you actually test this thing works? [In January](/mf2/2020/01/d311z/) I found [mtls.dev](https://mtls.dev), a great resource for generating all the setup for performing MTLS (both client-side and server-side) as well as example code to run a simple server locally.

I'd thoroughly recommend using it, especially to validate that you've got Rest Assured set up correctly.

I have tested this with Rest Assured v3.3.0 and v4.3.0.

# Generating the Keystore

To generate the keystore, we need both our private key (`client-key.pem` in this example), and the corresponding public certificate (`client.pem` in this example).

We can then use `openssl` to generate a PKCS12 keystore:

```sh
openssl pkcs12 -export -inkey client-key.pem -in client.pem -out keystore.p12
```

# Generating the Truststore

To generate the truststore, we need the public certificate (be it a leaf, intermediate, or root certificate) for the server (`ca.pem` in this example). I have documented how you can do this with `openssl` in [_Extracting SSL/TLS Certificate Chains Using OpenSSL_](/posts/2017/04/28/extract-tls-certificate/).

We can then use the `keytool` command from our Java install to import/create a keystore:

```sh
keytool -import -alias ca -file ca.pem -keystore truststore.jks
```
