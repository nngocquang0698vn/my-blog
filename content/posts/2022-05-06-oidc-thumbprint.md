---
title: "Getting the OpenID Connect thumbprint for AWS on the command-line with Go"
description: "How to automagically retrieve an OpenID Connect thumbprint for use with\
  \ AWS' OpenID Connect federated identity."
date: "2022-05-06T21:20:26+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1522674642506461185"
tags:
- "blogumentation"
- "go"
- "certificates"
- "aws"
- "oidc"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "oidc-thumbprint"
---
A few weeks back, I set up [OpenID Connect authentication between GitLab.com and AWS](https://docs.gitlab.com/ee/ci/cloud_services/index.html) for deploying my site, and it's been great. But today, I had my first failure due to this:

```
An error occurred (InvalidIdentityToken) when calling the AssumeRoleWithWebIdentity operation: OpenIDConnect provider's HTTPS certificate doesn't match configured thumbprint
```

Looking into it, GitLab.com appear to have rotated their HTTPS certificate, at which point the pinned certificate in AWS didn't match. Updating it was pretty straightforward using [AWS' official documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html), but I wanted something completely hands-off.

I ended up writing the following Go program, [packaged on GitLab](https://gitlab.com/tanna.dev/oidc-thumbprint), which can be run like so, and it will output the current OIDC fingerprint for use with AWS:

```sh
$ go install gitlab.com/tanna.dev/oidc-thumbprint@HEAD
$ oidc-thumbprint https://gitlab.com
```

The core code:

```go
package main

import (
	"crypto/sha1"
	"crypto/tls"
	"fmt"
	"log"
	"net/http"
	"net/url"
	"os"

	"github.com/zitadel/oidc/pkg/client"
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
	if len(os.Args) == 0 {
		panic(fmt.Errorf("requires argument: OIDC issuer"))
	}

	config, err := client.Discover(os.Args[1], &http.Client{})
	if err != nil {
		panic(err)
	}

	jwks := config.JwksURI
	parsed, err := url.Parse(jwks)
	if err != nil {
		panic(err)
	}

	var address string
	if parsed.Port() != "" {
		address = fmt.Sprintf("%s:%s", parsed.Hostname(), parsed.Port())
	} else {
		address = fmt.Sprintf("%s:443", parsed.Hostname())
	}
	fmt.Println(fingerprint(address))
}
```

And the `go.mod`:

```
module hacking.jvt.me/oidc-thumbprint

go 1.18

require github.com/zitadel/oidc v1.3.1

require (
	github.com/golang/protobuf v1.4.2 // indirect
	github.com/gorilla/schema v1.2.0 // indirect
	github.com/gorilla/securecookie v1.1.1 // indirect
	golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9 // indirect
	golang.org/x/net v0.0.0-20210405180319-a5a99cb37ef4 // indirect
	golang.org/x/oauth2 v0.0.0-20200902213428-5d25da1a8d43 // indirect
	golang.org/x/text v0.3.7 // indirect
	google.golang.org/appengine v1.6.6 // indirect
	google.golang.org/protobuf v1.25.0 // indirect
	gopkg.in/square/go-jose.v2 v2.6.0 // indirect
)
```
