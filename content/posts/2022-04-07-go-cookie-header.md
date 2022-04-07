---
title: "Parsing the `Cookie` and `Set-Cookie` headers with Go"
description: "How to parse the value of a `Cookie` or `Set-Cookie` header to a JSON\
  \ object."
date: "2022-04-07T10:18:06+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1511998478343417859"
tags:
- "blogumentation"
- "go"
- "http"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-cookie-header"
---
When working with HTTP services, you're likely to encounter cookies for passing around state.

Although we could inspect the `Cookie` or `Set-Cookie` headers by hand, it's easier to have a tool automagically parse them for us, as they're not the easiest to read.

I've created the following Go program, with helper methods to parse the values of the headers, following [this StackOverflow](https://stackoverflow.com/a/33926065) post:

```go
package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

func cookieHeader(rawCookies string) []*http.Cookie {
	header := http.Header{}
	header.Add("Cookie", rawCookies)
	req := http.Request{Header: header}
	return req.Cookies()
}

func setCookieHeader(cookie string) []*http.Cookie {
	header := http.Header{}
	header.Add("Set-Cookie", cookie)
	req := http.Response{Header: header}
	return req.Cookies()
}

func prettyPrint(cookies []*http.Cookie) error {
	b, err := json.Marshal(cookies)
	if err != nil {
		return err
	}

	var prettyJSON bytes.Buffer
	if err := json.Indent(&prettyJSON, b, "", "  "); err != nil {
		return err
	}

	fmt.Println(prettyJSON.String())
	return nil
}

func main() {
	cookies := cookieHeader("indieauth-authentication=eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NDg4NDYwNzYsInByb2ZpbGVfdXJsIjoiaHR0cHM6XC9cL3d3dy5qdnQubWVcLyJ9.; redirect_uri=/authorize/consent?client_id=https://www-editor.jvt.me&request_uri=urn:ietf:params:oauth:request_uri:fS6ri8Ue8S")
	err := prettyPrint(cookies)
	if err != nil {
		log.Fatal(err)
	}

	cookies = setCookieHeader("indieauth-authentication=eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NDkyMzQ3NjIsInByb2ZpbGVfdXJsIjoiaHR0cHM6XC9cL3d3dy5zdGFnaW5nLmp2dC5tZVwvIn0.v_0JC3xuGZN0e1CzN-bxexJ5JYDQsEUYWF4UPcILi98; Secure; HttpOnly")
	err = prettyPrint(cookies)
	if err != nil {
		log.Fatal(err)
	}
}
```

This produces the following JSON (pretty printed for readability):

```json
[
  {
    "Name": "indieauth-authentication",
    "Value": "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NDg4NDYwNzYsInByb2ZpbGVfdXJsIjoiaHR0cHM6XC9cL3d3dy5qdnQubWVcLyJ9.",
    "Path": "",
    "Domain": "",
    "Expires": "0001-01-01T00:00:00Z",
    "RawExpires": "",
    "MaxAge": 0,
    "Secure": false,
    "HttpOnly": false,
    "SameSite": 0,
    "Raw": "",
    "Unparsed": null
  },
  {
    "Name": "redirect_uri",
    "Value": "/authorize/consent?client_id=https://www-editor.jvt.me\u0026request_uri=urn:ietf:params:oauth:request_uri:fS6ri8Ue8S",
    "Path": "",
    "Domain": "",
    "Expires": "0001-01-01T00:00:00Z",
    "RawExpires": "",
    "MaxAge": 0,
    "Secure": false,
    "HttpOnly": false,
    "SameSite": 0,
    "Raw": "",
    "Unparsed": null
  }
]
[
  {
    "Name": "indieauth-authentication",
    "Value": "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NDkyMzQ3NjIsInByb2ZpbGVfdXJsIjoiaHR0cHM6XC9cL3d3dy5zdGFnaW5nLmp2dC5tZVwvIn0.v_0JC3xuGZN0e1CzN-bxexJ5JYDQsEUYWF4UPcILi98",
    "Path": "",
    "Domain": "",
    "Expires": "0001-01-01T00:00:00Z",
    "RawExpires": "",
    "MaxAge": 0,
    "Secure": true,
    "HttpOnly": true,
    "SameSite": 0,
    "Raw": "indieauth-authentication=eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NDkyMzQ3NjIsInByb2ZpbGVfdXJsIjoiaHR0cHM6XC9cL3d3dy5zdGFnaW5nLmp2dC5tZVwvIn0.v_0JC3xuGZN0e1CzN-bxexJ5JYDQsEUYWF4UPcILi98; Secure; HttpOnly",
    "Unparsed": null
  }
]
```
