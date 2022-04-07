---
title: "Parsing the `Cookie` and `Set-Cookie` headers with Go"
description: "How to parse the value of a `Cookie` or `Set-Cookie` header to a JSON object."
date: 2022-04-07T10:18:06+0100
syndication:
- "https://brid.gy/publish/twitter"
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

I've created the following Go program, with helper methods to parse the values of the headers, which requires we construct an HTTP response as a string and then retrieve the cookies, like so:

```go
package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strings"
)

func cookieHeader(rawCookies string) ([]*http.Cookie, error) {
	rawRequest := fmt.Sprintf("GET / HTTP/1.0\r\nCookie: %s\r\n\r\n", rawCookies)

	req, err := http.ReadRequest(bufio.NewReader(strings.NewReader(rawRequest)))
	if err != nil {
		return nil, err
	}

	return req.Cookies(), nil
}

func setCookieHeader(cookie string) ([]*http.Cookie, error) {
	rawResponse := fmt.Sprintf("HTTP/1.1 200 OK\r\nSet-Cookie: %s\r\n\r\n", cookie)

	resp, err := http.ReadResponse(bufio.NewReader(strings.NewReader(rawResponse)), nil)
	if err != nil {
		return nil, err
	}

	return resp.Cookies(), nil
}

func prettyPrint(cookies []*http.Cookie, err error) error {
	if err != nil {
		return err
	}

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
	cookies, err := cookieHeader("indieauth-authentication=eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NDg4NDYwNzYsInByb2ZpbGVfdXJsIjoiaHR0cHM6XC9cL3d3dy5qdnQubWVcLyJ9.; redirect_uri=/authorize/consent?client_id=https://www-editor.jvt.me&request_uri=urn:ietf:params:oauth:request_uri:fS6ri8Ue8S")
	err = prettyPrint(cookies, err)
	if err != nil {
		log.Fatal(err)
	}

	cookies, err = setCookieHeader("indieauth-authentication=eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NDkyMzQ3NjIsInByb2ZpbGVfdXJsIjoiaHR0cHM6XC9cL3d3dy5zdGFnaW5nLmp2dC5tZVwvIn0.; Secure; HttpOnly")
	err = prettyPrint(cookies, err)
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
