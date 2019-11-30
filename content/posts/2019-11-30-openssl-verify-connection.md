---
title: "Using the OpenSSL Command-Line to Verify an SSL/TLS Connection"
description: "How to use the `openssl` command-line to verify whether certs are valid."
tags:
- blogumentation
- openssl
- certificates
- command-line
- nablopomo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-30T00:20:53+0000
slug: "openssl-verify-connection"
series: nablopomo-2019
---
As I wrote in [_Trusting Self-Signed Certificates from Ruby_]({{< ref "2019-11-28-self-signed-certs-ruby" >}}), you'll sometimes have to interact with SSL/TLS certificates that aren't trusted by default by your browser / Operating System.

On Linux and some UNIX-based Operating Systems, OpenSSL is used for certificate validation, and usually is at least hooked into the global trust store.

If we want to validate that a given host has their SSL/TLS certificate trusted by us, we can use the `s_client` subcommand to perform a verification check (note that you'll need to `^C` to exit):

```sh
# on a successful verification
$ openssl s_client -quiet -connect jvt.me:443
depth=2 O = Digital Signature Trust Co., CN = DST Root CA X3
verify return:1
depth=1 C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3
verify return:1
depth=0 CN = jamietanna.co.uk
verify return:1
# on an unsuccessful verification
$ openssl s_client -quiet -connect keystore.openbanking.org.uk:443
depth=2 C = GB, O = OpenBanking, CN = OpenBanking Root CA
verify error:num=19:self signed certificate in certificate chain
verify return:1
depth=2 C = GB, O = OpenBanking, CN = OpenBanking Root CA
verify return:1
depth=1 C = GB, O = OpenBanking, CN = OpenBanking Issuing CA
verify return:1
depth=0 C = GB, O = OpenBanking, OU = Open Banking Directory, CN = keystore
verify return:1
read:errno=104
# for an expired cert
$ openssl s_client -quiet -connect expired.badssl.com:443
depth=2 C = GB, ST = Greater Manchester, L = Salford, O = COMODO CA Limited, CN = COMODO RSA Certification Authority
verify error:num=20:unable to get local issuer certificate
verify return:1
depth=1 C = GB, ST = Greater Manchester, L = Salford, O = COMODO CA Limited, CN = COMODO RSA Domain Validation Secure Server CA
verify return:1
depth=0 OU = Domain Control Validated, OU = PositiveSSL Wildcard, CN = *.badssl.com
verify error:num=10:certificate has expired
notAfter=Apr 12 23:59:59 2015 GMT
verify return:1
depth=0 OU = Domain Control Validated, OU = PositiveSSL Wildcard, CN = *.badssl.com
notAfter=Apr 12 23:59:59 2015 GMT
verify return:1
```

Notice that we get different `verify error`s to let us know the cert isn't valid.

And in case you've not seen it before, [BadSSL.com is a great resource for testing SSL/TLS configurations](/mf2/2019/11/72cs9/).
