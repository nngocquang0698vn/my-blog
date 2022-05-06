---
title: "Getting the fingerprint of a certificate in Go"
description: "How to retrieve an X.509 thumbprint from a remote server, in Go."
date: 2022-05-06T21:20:26+0100
syndication:
- "https://brid.gy/publish/twitter"
tags:
- "blogumentation"
- "go"
- "certificates"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-cert-fingerprint"
---
If you need to get the fingerprint for a given certificate, we can use [OpenSSL](https://www.jvt.me/posts/2019/04/03/openssl-fingerprint-x509-pem/) to do it, but we may also want to do the same in Go.

We can adapt [this StackOverflow answer](https://stackoverflow.com/a/64402683) and [this blog post](https://blog.abhi.host/blog/2020/02/01/Get-certificate-fingerprint-in-golang/) to produce the following:

```go
package main

import (
	"crypto/sha1"
	"crypto/tls"
	"fmt"
	"log"
)

func fingerprint(address string) string {
	conf := &tls.Config{
		InsecureSkipVerify: true, // as it may be self-signed
	}

	conn, err := tls.Dial("tcp", address, conf)
	if err != nil {
		log.Println("Error in Dial", err)
		return ""
	}
	defer conn.Close()
	cert := conn.ConnectionState().PeerCertificates[0]
	fingerprint := sha1.Sum(cert.Raw)
	return fmt.Sprintf("%x", fingerprint) // to make sure it's a hex string
}

func main() {
	fmt.Println(fingerprint("google.com:443"))
}
```
