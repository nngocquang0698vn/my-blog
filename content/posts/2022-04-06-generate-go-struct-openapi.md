---
title: "Generating Go structs from OpenAPI schemas"
description: "How to generate Go structs really quickly and easily, with no manual\
  \ work, using the oapi-codegen project."
date: "2022-04-06T14:32:08+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1511707009837682690"
tags:
- "blogumentation"
- "go"
- "openapi"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "generate-go-struct-openapi"
---
It's possible that you're using OpenAPI specifications to describe the format of your API, and as noted in [_Use a (JSON) Schema for the Interface Portion of your RESTful API_](https://www.jvt.me/posts/2021/12/16/api-object-schema/) is something I really recommend for codifying part of your API documentation.

If you're on a Go project, it may be that you're currently manually translating from OpenAPI data types to structs, which is time consuming and has the risk of drifting between your definitions and implementations.

One of the benefits of using a very structured format like the format in OpenAPI specifications is that you can programmatically generate the structs.

# Example OpenAPI specification

We'll base this on the OpenAPI specification demo from the [Petstore](https://petstore3.swagger.io/api/v3/openapi.json).

Note that if you have an OpenAPI schema that uses `$ref`s, we will need to [bundle the OpenAPI document](https://www.jvt.me/posts/2022/02/10/bundle-openapi/) into a single file.

# Generating the structs

We can take advantage of the great [oapi-codegen](https://github.com/deepmap/oapi-codegen) project, to give us a generator that we can use to produce our types.

**Update 2023-12-30**: Since writing this post, I've become a maintainer on oapi-codegen.

I'd recommend you manage the install of the `oapi-codegen` CLI via [a `tools.go`](https://www.jvt.me/posts/2022/06/15/go-tools-dependency-management/), but alternatively you could use `go install`:

```sh
go install github.com/deepmap/oapi-codegen/v2/cmd/oapi-codegen@latest
# optionally, pin to a version
go install github.com/deepmap/oapi-codegen/v2/cmd/oapi-codegen@v2.0.0
```

This then allows us to use the really handy Go directive `go:generate` which we embed in (any) source file in the project:

```go
//go:generate go run github.com/deepmap/oapi-codegen/v2/cmd/oapi-codegen --config=config.yaml https://petstore3.swagger.io/api/v3/openapi.json
// alternatively, if you've not used a `tools.go`:
//go:generate oapi-codegen --config=config.yaml https://petstore3.swagger.io/api/v3/openapi.json
```

This requires we have the following `config.yaml`:

```yaml
package: main
generate:
  models: true
output: petstore.gen.go
```

This allows us to execute the `oapi-codegen` when we execute `go generate` on the command-line.

This then allows us to write the following code, which can utilise the generated code:

```go
package main

//go:generate go run github.com/deepmap/oapi-codegen/v2/cmd/oapi-codegen --config=config.yaml https://petstore3.swagger.io/api/v3/openapi.json

import (
	"encoding/json"
	"fmt"
)

func main() {
	var u User
	err := json.Unmarshal([]byte(`
{
	"email": "example@example.com",
	"id": 123
}
	`), &u)
	if err != nil {
		panic(err)
	}
	fmt.Println(u)
	fmt.Println(*u.Email)
	fmt.Println(*u.Id)
}
```

This allows us to run:

```sh
$ go generate
$ go mod tidy
# then, the resulting output is
$ go run main.go petstore.gen.go
{0xc0000103e0 <nil> 0xc0000183d0 <nil> <nil> <nil> <nil> <nil>}
example@example.com
123
```

And produces models such as:

```go
// Pet defines model for Pet.
type Pet struct {
	Category  *Category `json:"category,omitempty"`
	Id        *int64    `json:"id,omitempty"`
	Name      string    `json:"name"`
	PhotoUrls []string  `json:"photoUrls"`

	// Status pet status in the store
	Status *PetStatus `json:"status,omitempty"`
	Tags   *[]Tag     `json:"tags,omitempty"`
}

// PetStatus pet status in the store
type PetStatus string
```
