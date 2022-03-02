---
title: Pretty Printing JSON Web Tokens (JWTs) on the Command Line using Go
description: How to easily introspect and pretty print a signed JWT (JWS) or an encrypted JWT (JWE) on the command line using Go.
tags:
- blogumentation
- go
- command-line
- jwt
- json
- pretty-print
image: https://media.jvt.me/0b0440faeb.jpeg
date: 2022-02-26T20:54:40+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: pretty-printing-jwt-go
series: pretty-print-jwt
syndication:
- "https://brid.gy/publish/twitter"
---
Similar to my [previous articles in this series](/series/pretty-print-jwt/), you may want to create a command-line Go app to decode JWTs.

Let us use the following JWT in `example.jwt`, via JWT.io:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

As well as the following encrypted JWT (JWE) from [RFC7516: JSON Web Encryption (JWE)](https://tools.ietf.org/html/rfc7516#section-3.3):

```
eyJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkEyNTZHQ00ifQ.OKOawDo13gRp2ojaHV7LFpZcgV7T6DVZKTyKOMTYUmKoTCVJRgckCL9kiMT03JGeipsEdY3mx_etLbbWSrFr05kLzcSr4qKAq7YN7e9jwQRb23nfa6c9d-StnImGyFDbSv04uVuxIp5Zms1gNxKKK2Da14B8S4rzVRltdYwam_lDp5XnZAYpQdb76FdIKLaVmqgfwX7XWRxv2322i-vDxRfqNzo_tETKzpVLzfiwQyeyPGLBIO56YJ7eObdv0je81860ppamavo35UgoRdbYaBcoh9QcfylQr66oc6vFWXRcZ_ZT2LawVCWTIy3brGPi6UklfCpIMfIjf7iGdXKHzg.48V1_ALb6US04U3b.5eym8TW_c8SuK0ltJ3rpYIzOeDQz7TALvtu6UG9oMo4vpzs9tX_EFShS8iB7j6jiSdiwkIr3ajwQzaBtQD_A.XFBoMYUZodetZdvTiFvSkQ
```

This can be decoded using the following Go program, which takes input from `stdin` and outputs the decoded (but not verified) contents:

```go
package main

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"strings"
)

func PrettyString(str []byte) (string, error) {
	var prettyJSON bytes.Buffer
	if err := json.Indent(&prettyJSON, str, "", "  "); err != nil {
		return "", err
	}
	return prettyJSON.String(), nil
}

func main() {
	data, err := io.ReadAll(os.Stdin)
	if err != nil {
		panic(err)
	}

	segments := strings.Split(string(data), ".")
	for i, segment := range segments {
		if i == 2 {
			break
		}

		bytes, err := base64.RawURLEncoding.DecodeString(segment)
		if err != nil {
			fmt.Printf("Error decoding string: %s ", err.Error())
			return
		}

		pretty, err := PrettyString(bytes)
		if err != nil {
			panic(err)
		}

		fmt.Println(pretty)

		if i == 0 {
			// give us a generic object to interact with
			decoded := make(map[string](interface{}))
			err = json.Unmarshal([]byte(bytes), &decoded)
			if err != nil {
				panic(err)
			}
			// don't decode further if this is an encrypted JWT (JWE)
			if _, ok := decoded["enc"]; ok {
				break
			}
		}
	}
}
```
