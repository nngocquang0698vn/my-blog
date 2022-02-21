---
title: Pretty Printing JSON on the Command Line with Go
description: Using Go's JSON module to pretty print JSON objects from the command line.
tags:
- blogumentation
- go
- json
- pretty-print
date: 2022-02-21T17:18:19+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: go-json-pretty-print
series: pretty-print-json
image: https://media.jvt.me/b41202acf7.png
syndication:
- "https://brid.gy/publish/twitter"
---
As with [other posts in this series](/series/pretty-print-json/), it's useful to be able to quickly convert a JSON string to a pretty-printed version.

In today's installment, we'll do it using Go.

Adapting [the example from gosamples.dev](https://gosamples.dev/pretty-print-json/), we can use the `json.Indent` call to perform the coercion, [reading `stdin` using `io.ReadAll`](/posts/2022/02/21/go-stdin/), resulting in the following:

```go
package main

import (
	"bytes"
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
	stdin, err := io.ReadAll(os.Stdin)
	if err != nil {
		panic(err)
	}

	res, err := PrettyString(stdin)
	if err != nil {
		panic(err)
	}
	fmt.Println(strings.TrimSuffix(res, "\n"))
}
```

This then allows us to convert:

```json
{"key":[123,456],"key2":"value"}
```

To a pretty output:

```sh
go run main.go < file.json
```
