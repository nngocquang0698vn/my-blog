---
title: "Automating boilerplate/scaffolding code with custom code generation in Go"
description: "How to use Go's code generation tooling to add custom code generation\
  \ to your project."
date: "2022-06-26T08:39:28+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1540965219270381570"
tags:
- "blogumentation"
- "go"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "go-custom-generate"
---
# The problem

Let's say we're building a RESTful API and want to be able to produce several errors of the following consistent format. We want to create a specific type per error, so we can more easily write some code like so:

```go
err := NewErrInternal()

if e, ok := err.(*ErrInvalidRequest); ok {
  // respond with an HTTP 400 error
}
```

This switching on errors gives us control as the receiver of an error and process the error accordingly. An alternative for this would be to use a constant error, but that makes it difficult to add more context, or tweak the error message.

This would then mean we'd want to write the following code:

```go
type ErrBadRequest struct {
	message string
	cause   error
}

func (e *ErrBadRequest) Error() string {
	return e.message
}

func (e *ErrBadRequest) Unwrap() error {
	return e.cause
}

func NewErrBadRequest() error {
	return &ErrBadRequest{
		message: "There was a problem processing the request",
	}
}

func NewErrBadRequestWithMessage(message string) error {
	return &ErrBadRequest{
		message: message,
	}
}

func NewErrBadRequestWithCause(cause error) error {
	return &ErrBadRequest{
		message: "The was a problem processing the request",
		cause:   cause,
	}
}

func NewErrBadRequestWithMessageAndCause(message string, cause error) error {
	return &ErrBadRequest{
		message: message,
		cause:   cause,
	}
}
```

If we have to hand-write this every time we want to add a new error such as `ErrNotFound`, this will get a little bit cumbersome, and has the chance to lead to missing the addition of new methods, consistency, especially as we're likely to have different error types across the codebase.

Now, because this is fairly consistent between error types, we can actually wrap this into a custom generation tool.

# Scoping the solution

Firstly, we want to think about how we want to solve this generation.

In this case, we're going to want to generate multiple errors, so we probably want to introduce a configuration file, of the following format:

```yaml
output: errors.gen.go
package: errors
errors:
- name: BadRequest
  message: "There was a problem processing the request"
# and others!
```

We'll start by making sure that we invoke `go:generate` in i.e. `pkg/errors/generate.go`:

```go
//go:generate go run <insert-module-path>/cmd/error-codegen -config errors.yaml
package errors
```

This means that when we run `go generate ./...`, it'll regenerate the code.

Be careful here - we can't use shell redirection, it must be written to file from disk, so **this will not work**:

```go
// This will not work!
//go:generate go run <insert-module-path>/cmd/error-codegen --config errors.yaml > errors.gen.go
package errors
```

Now we need to write the code to glue it all together.

We can produce the following script:

```go
package main

import (
	"bytes"
	_ "embed"
	"flag"
	"go/format"
	"io/ioutil"
	"log"
	"os"
	"text/template"

	"gopkg.in/yaml.v3"
)

func must(err error) {
	if err != nil {
		log.Printf("There was an unexpected error: %s", err)
		os.Exit(1)
	}
}

//go:embed errors.tmpl
var errorsTemplate string

type config struct {
	Package string `yaml:"package"`
	Output  string `yaml:"output"`
	Errors  []struct {
		Name    string `yaml:"name"`
		Message string `yaml:"message"`
	} `yaml:"errors"`
}

func main() {
	configPathPtr := flag.String("config", "", "configuration file")
	flag.Parse()

	if configPathPtr == nil {
		log.Printf("Expected a configuration file, but received `nil`")
		os.Exit(1)
	}

	configPath := *configPathPtr
	b, err := ioutil.ReadFile(configPath)
	must(err)

	var config config

	err = yaml.Unmarshal(b, &config)
	must(err)

	t := template.Must(template.New("errors.go").Parse(errorsTemplate))

	var buf bytes.Buffer

	err = t.Execute(&buf, config)
	must(err)

	b, err = format.Source(buf.Bytes())
	must(err)

	ioutil.WriteFile(config.Output, b, 0644)
}
```

This then builds on top of the following `errors.tmpl`:

```go-text-template
package {{ .Package }}

{{ range .Errors }}

type Err{{ .Name }} struct {
	message string
	cause   error
}

func (e *Err{{ .Name }}) Error() string {
	return e.message
}

func (e *Err{{ .Name }}) Unwrap() error {
	return e.cause
}

func NewErr{{ .Name }}() error {
	return &Err{{ .Name }}{
		message: "{{ .Message }}",
	}
}

func NewErr{{ .Name }}WithMessage(message string) error {
	return &Err{{ .Name }}{
		message: message,
	}
}

func NewErr{{ .Name }}WithCause(cause error) error {
	return &Err{{ .Name }}{
    message: "{{ .Message }}",
		cause:   cause,
	}
}

func NewErr{{ .Name }}WithMessageAndCause(message string, cause error) error {
	return &Err{{ .Name }}{
		message: message,
		cause:   cause,
	}
}

{{ end }}
```

This is a fairly straightforward way to produce valid Go code, removing boilerplate and making it simpler to ship code! As we can perform it all through the project, or consume an external, shared, tool, it's pretty handy.
