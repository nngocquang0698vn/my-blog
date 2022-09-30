---
title: "Appending to a Querystring using Go"
description: "How to append query parameters in a URL in Go."
tags:
- blogumentation
- go
- web
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-20T21:40:25+0000
slug: "go-append-querystring"
image: https://media.jvt.me/b41202acf7.png
---
As noted in [_Don't Just String Append to a Querystring_](/posts/2022/01/20/dont-append-querystring/), we should avoid using string concatenation, and instead use our URL library's functionality.

With Go, we'd parse the URL, amend the querystring, and then make sure we set the `RawQuery` to allow us to convert it back to a string:

```go
func addTracking(theUrl string) string {
	u, err := url.Parse(theUrl)
	if err != nil {
		panic(err)
	}

	queryString := u.Query()
	// append
	queryString.Add("utm_campaign", "the_tracking_campaign")
	// override
	queryString.Set("utm_campaign", "the_tracking_campaign")

	// make sure
	u.RawQuery = queryString.Encode()

	return u.String()
}
```
