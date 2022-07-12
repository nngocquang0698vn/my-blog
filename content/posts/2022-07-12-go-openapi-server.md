---
title: "Building a Go RESTful API with design-first OpenAPI contracts"
description: "How to use `oapi-codegen` to generate an RESTful API using design-first OpenAPI and code generation."
date: 2022-07-12T15:54:33+0100
syndication:
- https://brid.gy/publish/twitter
tags:
- blogumentation
- openapi
- go
- api
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/7be186e7a3.png"
slug: go-openapi-server
---
As mentioned in my post about [_Shipping services more quickly with design-first OpenAPI contracts_](https://www.jvt.me/posts/2022/06/27/roo-openapi-design-first/), I've recently been working on a fair bit of OpenAPI-driven design-first APIs, in Go. For more info on what that is, and why you'd want to do it, I'd recommend having a read of that post.

This has been using the Go library [oapi-codegen](https://github.com/deepmap/oapi-codegen/), and has been a truly excellent experience.

To give a bit more insight into how this works, so you too can be building services even more quickly, I thought I'd blogument it.

This post has a corresponding [repo on GitLab](https://gitlab.com/jamietanna/oapi-codegen-example-project).

# OpenAPI

Let's start with the OpenAPI document itself. This is slightly amended from the example from the Deliveroo post:

```yaml
# Example from https://deliveroo.engineering/2022/06/27/openapi-design-first.html
# © All-Rights-Reserved
openapi: 3.1.0
info:
  title: Care Request API
  version: 0.1.0
paths:
  "/request/{request-id}":
    get:
      summary: Get all requests
      operationId: getRequest
      parameters:
        - $ref: '#/components/parameters/RequestId'
        - $ref: '#/components/parameters/TracingId'
      responses:
        '200':
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/CareRequest'
        # we'd also add other response options here too
components:
  parameters:
    RequestId:
      name: request-id
      in: path
      required: true
      schema:
        $ref: '#/components/schemas/RequestId'
    TracingId:
      description: A unique tracing ID that can be used for end-to-end tracing
      name: tracing-id
      in: header
      required: false
      schema:
        type: string
        format: uuid
        pattern: "[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-4[a-fA-F0-9]{3}-[89abAB][a-fA-F0-9]{3}-[a-fA-F0-9]{12}"
  schemas:
    CareRequest:
      type: object
      properties:
        id:
          $ref: '#/components/schemas/RequestId'
        status:
          $ref: '#/components/schemas/RequestStatus'
    RequestId:
      type: string
      format: uuid
      pattern: "[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-4[a-fA-F0-9]{3}-[89abAB][a-fA-F0-9]{3}-[a-fA-F0-9]{12}"
    RequestStatus:
      type: string
      enum:
        - active
        - completed
```

# Generation

Now, we need to generate our server. Before we start, a quick word about my recommended package structure:

```sh
openapi.yaml              # the service's OpenAPI contract
tools.go                  # tracking the version of `oapi-codegen`'s CLI, via https://www.jvt.me/posts/2022/06/15/go-tools-dependency-management/
domain/
  services/
    carerequestservice.go # underlying business logic in a interface
server/
  server.go               # the code that creates an HTTP server from the generated code, preparing any router-specific configuration
  api/
    generate.go           # go:generate tags
    server.gen.go         # the generated output from oapi-codegen
    implementation.go     # the code you're writing to fulfil the contract of the server
```

To do this, `oapi-codegen` requires that we have a configuration file, for instance `server/api/oapi-codegen.yaml`:

```yaml
output: server.gen.go
package: api
generate:
  # other servers are available!
  gorilla-server: true
  models: true
  embedded-spec: true
```

Next, we need to prepare a `server/api/generate.go` which will trigger the generation via `go generate`:

```go
package api
//go:generate go run github.com/deepmap/oapi-codegen/cmd/oapi-codegen --config oapi-codegen.yaml ../../openapi.yaml
```

Running `go generate ./...` then gives us a freshly generated `server.gen.go`, which includes the various models required to interact with the API:

```go
// Defines values for RequestStatus.
const (
	Active    RequestStatus = "active"
	Completed RequestStatus = "completed"
)

// CareRequest defines model for CareRequest.
type CareRequest struct {
	Id     RequestId     `json:"id"`
	Status RequestStatus `json:"status"`
}

// RequestId defines model for RequestId.
type RequestId = openapi_types.UUID

// RequestStatus defines model for RequestStatus.
type RequestStatus string
```

We also have a `ServerInterface` to implement, which gives us a smaller interface to think about for how we implement our server, and plumbs in the parameters that our specification defines:

```go
// GetRequestParams defines parameters for GetRequest.
type GetRequestParams struct {
	// A unique tracing ID that can be used for end-to-end tracing
	TracingId *TracingId `json:"tracing-id,omitempty"`
}

// ServerInterface represents all server handlers.
type ServerInterface interface {
	// Get all requests
	// (GET /requests/{request-id})
	GetRequest(w http.ResponseWriter, r *http.Request, requestId RequestId, params GetRequestParams)
}
```

# Implementation

Now we've generated the base server, we need to actually implement the `ServerInterface`.

We can start by preparing our `server/api/implementation.go`:

```go
package api

import "net/http"

type careRequestApi struct{}

// Get all requests
// (GET /request/{request-id})
func (c *careRequestApi) GetRequest(w http.ResponseWriter, r *http.Request, requestId RequestId, params GetRequestParams) {
	panic("not implemented") // TODO: Implement
}
```

I'd then reach for TDD, and write the following tests, including [my library for OpenAPI validation](https://www.jvt.me/posts/2022/05/22/go-openapi-contract-test/):

```go
func TestCareRequestApi_GetRequest(t *testing.T) {
	mockService := mocks.NewMockCareRequestService(gomock.NewController(t))
	server := NewCareRequestApi(mockService)

	t.Run("when successful", func(t *testing.T) {
		found := domain.CareRequest{
			Id:     domain.RequestId(uuid.New()),
			Status: domain.RequestStatusActive,
		}

		mockService.EXPECT().GetRequestById(gomock.Any()).Return(&found, nil)

		requestId := uuid.New()
		rr := httptest.NewRecorder()
		req := httptest.NewRequest("GET", "/requests/"+requestId.String(), nil)

		server.GetRequest(rr, req, requestId, GetRequestParams{})

		t.Run("it returns 200", func(t *testing.T) {
			assert.Equal(t, 200, rr.Result().StatusCode)
		})

		t.Run("it matches OpenAPI", func(t *testing.T) {
			doc, err := GetSwagger()
			assert.NoError(t, err)

			_ = validator.NewValidator(doc).ForTest(t, rr, req)
			// validation happens in the background
		})
	})

	t.Run("when no request found", func(t *testing.T) {
		mockService.EXPECT().GetRequestById(gomock.Any()).Return(nil, nil)

		requestId := uuid.New()
		rr := httptest.NewRecorder()
		req := httptest.NewRequest("GET", "/requests/"+requestId.String(), nil)

		server.GetRequest(rr, req, requestId, GetRequestParams{})

		t.Run("it returns 404", func(t *testing.T) {
			assert.Equal(t, 404, rr.Result().StatusCode)
		})

		t.Run("it matches OpenAPI", func(t *testing.T) {
			doc, err := GetSwagger()
			assert.NoError(t, err)

			_ = validator.NewValidator(doc).ForTest(t, rr, req)
			// validation happens in the background
		})
	})

	t.Run("when an error returned from service", func(t *testing.T) {
		mockService.EXPECT().GetRequestById(gomock.Any()).Return(nil, fmt.Errorf("uh oh"))

		requestId := uuid.New()
		rr := httptest.NewRecorder()
		req := httptest.NewRequest("GET", "/requests/"+requestId.String(), nil)

		server.GetRequest(rr, req, requestId, GetRequestParams{})

		t.Run("it returns 500", func(t *testing.T) {
			assert.Equal(t, 500, rr.Result().StatusCode)
		})
	})
}
```

Once these are written, we can construct the implementation, resulting in the following code:

```go
type careRequestApi struct {
	service services.CareRequestService
}

func NewCareRequestApi(service services.CareRequestService) ServerInterface {
	return &careRequestApi{
		service: service,
	}
}

// Get all requests
// (GET /requests/{request-id})
func (c *careRequestApi) GetRequest(w http.ResponseWriter, r *http.Request, requestId RequestId, params GetRequestParams) {
	found, err := c.service.GetRequestById(domain.RequestId(requestId))
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	if found == nil {
		w.WriteHeader(http.StatusNotFound)
		return
	}

	response := CareRequest{
		Id:     uuid.UUID(found.Id),
		Status: RequestStatus(found.Status),
	}
	bytes, err := json.Marshal(response)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.Header().Add("content-type", "application/json")
	w.Write(bytes) // NOTE that we should handle the error here
	w.WriteHeader(http.StatusOK)
}
```

# Serving traffic

Once we've created this, we would produce a method like so, to prepare a generic `http.Handler` which can then be used when running the application:

```go
func NewHandler() http.Handler {
	openapi, err := api.GetSwagger()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error loading swagger spec\n: %s", err)
		os.Exit(1)
	}

	openapi.Servers = nil

	var service services.CareRequestService // TODO: in a production app, this would be properly initialised

	server := api.NewCareRequestApi(service)

	r := mux.NewRouter()

  // NOTE that this is important! This enforces consumers use the right contract, required on top of checks that are done in the generated API code
	r.Use(middleware.OapiRequestValidator(openapi))

	return api.HandlerFromMux(server, r)
}
```

Notice that we need to set up the `OapiRequestValidator` middleware, and that it enforces further validation on top of what is already done in the generated code.

# Conclusion

Notice that unlike using a regular HTTP server's HTTP handlers, we can actually avoid thinking about the parsing of the incoming HTTP request, and instead focus on processing data and returning a valid response.

This makes it _so much quicker_ to ship our handlers, and allows us to make our HTTP handlers very lightweight, delegating to business logic elsewhere, keeping them as slim as possible.
