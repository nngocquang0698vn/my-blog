---
title: "Generating a Go HTTP Client from OpenAPI schemas"
description: "How to generate a Go HTTP client really quickly and easily, with no manual work, using the oapi-codegen project."
date: 2022-04-06T14:59:28+0100
syndication:
- "https://brid.gy/publish/twitter"
tags:
- "blogumentation"
- "go"
- openapi
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "generate-go-client-openapi"
---
It's possible that you're using OpenAPI specifications to describe the format of your API, and as noted in [_Use a (JSON) Schema for the Interface Portion of your RESTful API_](https://www.jvt.me/posts/2021/12/16/api-object-schema/) is something I really recommend for codifying part of your API documentation.

If you're on a Go project, you're hopefully [autogenerating your structs](/posts/2022/04/06/generate-go-struct-openapi/), but may still be manually wiring in the HTTP plumbing.

One of the benefits of using a very structured format like the format in OpenAPI specifications is that you can programmatically generate the types, client and server.

# Example OpenAPI specification

We'll base this on the OpenAPI specification demo from the [Petstore](https://petstore3.swagger.io/api/v3/openapi.json).

Note that if you have an OpenAPI schema that uses `$ref`s, we will need to [bundle the OpenAPI document](https://www.jvt.me/posts/2022/02/10/bundle-openapi/) into a single file.

# Generating the structs

We can take advantage of the great [oapi-codegen](https://github.com/deepmap/oapi-codegen) project, to give us a generator that we can use to produce our types.

We can install it as a command-line utility by running:

```sh
# optionally, pin to a version
go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen
```

This then allows us to use the really handy Go directive `go:generate` which we embed in (any) source file in the project:

```go
//go:generate oapi-codegen --package=main -generate=types -o ./petstore.gen.go https://petstore3.swagger.io/api/v3/openapi.json
```

This allows us to execute the `oapi-codegen` when we execute `go generate` on the command-line.

This then allows us to write the following code, which can utilise the generated code:

```go
package main

//go:generate oapi-codegen --package=main -generate=client,types -o ./petstore.gen.go https://petstore3.swagger.io/api/v3/openapi.json

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
)

func main() {
	c, err := NewClientWithResponses("https://petstore3.swagger.io/api/v3/")
	if err != nil {
		panic(err)
	}
	var status FindPetsByStatusParamsStatus
	status = "available"
	params := FindPetsByStatusParams{Status: &status}
	resp, err := c.FindPetsByStatusWithResponse(context.Background(), &params)
	if err != nil {
		panic(err)
	}
	pets := *resp.JSON200
	if len(pets) > 0 {
		fmt.Println(*pets[0].Id)
		fmt.Println(pets[0].Name)
	}
}
```
