---
title: "Setting up a directory for OpenSSL's `SSL_CERT_DIR`"
description: "How to configure a directory of trusted certificates for OpenSSL to trust."
tags:
- blogumentation
- openssl
- certificates
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-12-04T13:35:49+0000
slug: "openssl-certs-dir-setup"
---
As I mentioned in [_Trusting Self-Signed Certificates from Ruby_]({{< ref "2019-11-28-self-signed-certs-ruby" >}}), it is possible to use the `SSL_CERT_DIR` environment variable to specify where OpenSSL looks for certificates, instead of just pointing to a file with `SSL_CERT_FILE`, but I had some difficulty getting it working.

I managed to work out how to do it, with some help from the [man page for SSL_CTX_LOAD_VERIFY_LOCATIONS(3)](https://linux.die.net/man/3/ssl_ctx_load_verify_locations).

Taking the example of my Ruby post above, we'll add the cert for `keystore.openbanking.org.uk`, which uses an untrusted CA.

We can use the steps in [_Extracting SSL/TLS Certificate Chains Using OpenSSL_]({{< ref "2017-04-28-extract-tls-certificate" >}}) to extract the certificate, and output it as the file `keystore.openbanking.org.uk.pem`:

```sh
# create our new `SSL_CERT_DIR`
$ mkdir -p certs
# then get the certificate chain we want to trust
$ openssl s_client -showcerts -connect "keystore.openbanking.org.uk:443" < /dev/null 2>/dev/null |\
	sed -n -e '/BEGIN\ CERTIFICATE/,/END\ CERTIFICATE/ p' \
  > certs/keystore.openbanking.org.uk.pem
```

**NOTE**: You must only have one certificate per file, otherwise OpenSSL will fail to verify the given connection. I would recommend using the root-most CA you can get from OpenSSL, rather than the leaf certificate, or an intermediate. Because OpenSSL returns them in reverse order, you want to delete all but the last certificate in i.e. `certs/keystore.openbanking.org.uk.pem`.

Next we need to run [`c_rehash`](https://www.commandlinux.com/man-page/man1/c_rehash.1ssl.html) for OpenSSL to be able to work with the certificates programmatically:

```sh
$ cd certs
$ c_rehash .
```

Now we can use this new certs directory to trust lots of untrusted certs:

```sh
$ env SSL_CERT_DIR=certs ruby http.rb
# ...
# it works!
```
