---
title: "Debugging HTTP Client requests with Go"
description: "How to add debug logging to `http.Client` in Go."
tags:
- blogumentation
- go
date: 2023-03-11T10:08:37+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: go-debug-http
image: https://media.jvt.me/b41202acf7.png
---
Sometimes when you're integrating with APIs or web services, you need to debug the HTTP requests/responses that are occuring.

In [some toolchains it's part of configuration](https://stackoverflow.com/a/61049980/2257038), but in Go it's unfortunately not part of the standard library to globally turn on logging for the `http.Client.`

That being said, the Go standard library has `net/http/httputil` has the handy helper methods [`httputil.DumpRequestOut`](https://pkg.go.dev/net/http/httputil#DumpRequestOut) and [`httputil.DumpResponse`](https://pkg.go.dev/net/http/httputil#DumpResponse) which we can use alongside an implementation of [`http.RoundTripper`](https://pkg.go.dev/net/http#RoundTripper) to provide a logging HTTP client.

We can wrap this together with:

```go
package main

import (
	"fmt"
	"log"
	"net/http"
	"net/http/httputil"
	"net/url"
)

type loggingTransport struct{}

func (s *loggingTransport) RoundTrip(r *http.Request) (*http.Response, error) {
	bytes, _ := httputil.DumpRequestOut(r, true)

	resp, err := http.DefaultTransport.RoundTrip(r)
	// err is returned after dumping the response

	respBytes, _ := httputil.DumpResponse(resp, true)
	bytes = append(bytes, respBytes...)

	fmt.Printf("%s\n", bytes)

	return resp, err
}

func main() {
	client := http.Client{
		Transport: &loggingTransport{},
	}

	baseUrl := "https://..." // this would be filled in with i.e. a Request Bin style application

	resp, err := client.PostForm(baseUrl, url.Values{
		"name":    {"foo"},
		"content": {"baz", "bing"},
	})
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()

	fmt.Printf("resp.Status: %v\n", resp.Status)

	resp, err = client.Get(must(url.JoinPath(baseUrl, "/user")))
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()

	fmt.Printf("resp.Status: %v\n", resp.Status)

	// preferably don't mutate the global client!
	http.DefaultClient = &client

	resp, err = http.DefaultClient.Get(must(url.JoinPath(baseUrl, "/from-default-client")))
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()

	fmt.Printf("resp.Status: %v\n", resp.Status)
}

func must(s string, err error) string {
	if err != nil {
		log.Fatal(err)
	}
	return s
}
```

This then outputs:

<details>

<summary>Example output</summary>

```
POST / HTTP/1.1
Host: enzzopego73pb.x.pipedream.net
User-Agent: Go-http-client/1.1
Content-Length: 33
Content-Type: application/x-www-form-urlencoded
Accept-Encoding: gzip

content=baz&content=bing&name=fooHTTP/2.0 200 OK
Content-Length: 16
Access-Control-Allow-Origin: *
Content-Type: application/json; charset=utf-8
Date: Sat, 11 Mar 2023 10:06:43 GMT
X-Pd-Status: sent to primary
X-Powered-By: Express

{"success":true}
resp.Status: 200 OK
GET /user HTTP/1.1
Host: enzzopego73pb.x.pipedream.net
User-Agent: Go-http-client/1.1
Accept-Encoding: gzip

HTTP/2.0 200 OK
Content-Length: 16
Access-Control-Allow-Origin: *
Content-Type: application/json; charset=utf-8
Date: Sat, 11 Mar 2023 10:06:43 GMT
X-Pd-Status: sent to primary
X-Powered-By: Express

{"success":true}
resp.Status: 200 OK
GET /from-default-client HTTP/1.1
Host: enzzopego73pb.x.pipedream.net
User-Agent: Go-http-client/1.1
Accept-Encoding: gzip

HTTP/2.0 200 OK
Content-Length: 16
Access-Control-Allow-Origin: *
Content-Type: application/json; charset=utf-8
Date: Sat, 11 Mar 2023 10:06:43 GMT
X-Pd-Status: sent to primary
X-Powered-By: Express

{"success":true}
resp.Status: 200 OK
```

</details>
