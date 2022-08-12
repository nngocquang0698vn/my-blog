---
title: "Converting HTTP requests to Wiremock stubs, with Go"
description: "How to take an HTTP request and convert it into a Wiremock JSON mapping, on the command-line, in Go."
date: 2022-08-12T17:17:09+0100
tags:
- "blogumentation"
- "testing"
- "go"
- "wiremock"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/2a42816de8.png"
slug: wiremock-from-http
---
If you're using [Wiremock](http://wiremock.org/), sometimes you want to be able to quickly generate stub mappings from an existing server, rather than hand-crafting it yourself, to give you a like-for-like stub.

I've written the following - somewhat hacky - script to produce a Wiremock stub mapping from a given HTTP response.

This can either be plugged into a command-line tool like so, or could be used with an existing HTTP call, for instance when plugged into your existing HTTP clients that integrate with the upstream server.

```go
package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
)

type request struct {
	Method string `json:"method"`
	URL    string `json:"url"`
}

type response struct {
	Status  int               `json:"status"`
	Body    string            `json:"body"`
	Headers map[string]string `json:"headers"`
}

type wiremockStub struct {
	Request  request  `json:"request"`
	Response response `json:"response"`
}

func toHeaders(headers http.Header) map[string]string {
	h := make(map[string]string)
	for k, v := range headers {
		h[k] = v[0]
	}
	return h
}

func toRequestURL(requestURL *url.URL) string {
	u := requestURL.Path
	if requestURL.RawQuery != "" {
		u += "?" + requestURL.RawQuery
	}
	if requestURL.RawFragment != "" {
		u += "#" + requestURL.RawFragment
	}

	return u
}

func toWiremock(resp *http.Response) *wiremockStub {
  // NOTE: we don't have too much required in the request, just method and the URL path on the incoming request, but we could do more like basing on headers, HTTP Basic Auth, and body
	wmReq := request{
		Method: resp.Request.Method,
		URL:    toRequestURL(resp.Request.URL),
	}

	wmResp := response{
		Status:  resp.StatusCode,
		Headers: toHeaders(resp.Header),
	}

	defer resp.Body.Close()
	body, err := io.ReadAll(resp.Body)
	if err == nil {
		wmResp.Body = string(body)
	}

	return &wiremockStub{
		Request:  wmReq,
		Response: wmResp,
	}
}

func main() {
	url := os.Args[1]
	resp, err := http.Get(url)

	if err != nil {
		log.Fatal(err)
		return
	}

	s, err := json.Marshal(toWiremock(resp))
	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	}

	fmt.Println(string(s))
}
```

This can be run like so:

```sh
go run main.go "https://www-api.jvt.me/micropub?q=source&url=https://www.jvt.me/mf2/2022/04/odxjc/"
```

And produces the following pretty-printed JSON:

```json
{
  "request": {
    "method": "GET",
    "url": "/micropub?q=source&url=https://www.jvt.me/mf2/2022/04/odxjc/"
  },
  "response": {
    "body": "{\"type\":[\"h-entry\"],\"properties\":{\"syndication\":[\"https://brid.gy/publish/github\"],\"name\":[\"lestrrat-go/jwx at develop/v1\"],\"published\":[\"2022-04-12T12:53:47.383098795Z\"],\"category\":[\"go\",\"jose\",\"jwt\"],\"like-of\":[\"https://github.com/lestrrat-go/jwx\"],\"post-status\":[\"published\"]}}",
    "headers": {
      "Cache-Control": "no-cache, no-store, max-age=0, must-revalidate",
      "Content-Type": "application/json",
      "Date": "Fri, 12 Aug 2022 16:14:15 GMT",
      "Expires": "0",
      "Pragma": "no-cache",
      "Strict-Transport-Security": "max-age=15724800; includeSubDomains",
      "X-Content-Type-Options": "nosniff",
      "X-Frame-Options": "DENY",
      "X-Xss-Protection": "1; mode=block"
    },
    "status": 200
  }
}
```



