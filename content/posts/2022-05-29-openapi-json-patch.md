---
title: "Describing JSON Patch operations with OpenAPI"
description: "How to describe your JSON Patch endpoints using OpenAPI."
date: "2022-05-29T14:27:00+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1530905519900196864"
tags:
- "blogumentation"
- "openapi"
- "api"
- "json-patch"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/7be186e7a3.png"
slug: "openapi-json-patch"
---
[JSON Patch](http://jsonpatch.com/) is a well-defined format for performing updates to HTTP objects, which allows you to avoid needing to design your own means for performing partial changes.

One thing that may not be super straightforward is how to define it in OpenAPI.

We can take [inspiration from this Gist](https://gist.github.com/theletterf/cbc36c937bf1da986b0f19ec4159622d), and construct the following OpenAPI specification:

```yaml
paths:
  "/the/path":
    patch:
      description: "..."
      operationId: "..."
      requestBody:
        content:
          application/json-patch+json:
            schema:
              $ref: '#/components/schemas/PatchRequest'
components:
  schemas:
    PatchRequest:
      type: array
      items:
        oneOf:
          - $ref: '#/components/schemas/JSONPatchRequestAddReplaceTest'
          - $ref: '#/components/schemas/JSONPatchRequestRemove'
          - $ref: '#/components/schemas/JSONPatchRequestMoveCopy'
    JSONPatchRequestAddReplaceTest:
      type: object
      additionalProperties: false
      required:
        - value
        - op
        - path
      properties:
        path:
          description: A JSON Pointer path.
          type: string
        value:
          description: The value to add, replace or test.
        op:
          description: The operation to perform.
          type: string
          enum:
            - add
            - replace
            - test
    JSONPatchRequestRemove:
      type: object
      additionalProperties: false
      required:
        - op
        - path
      properties:
        path:
          description: A JSON Pointer path.
          type: string
        op:
          description: The operation to perform.
          type: string
          enum:
            - remove
    JSONPatchRequestMoveCopy:
      type: object
      additionalProperties: false
      required:
        - from
        - op
        - path
      properties:
        path:
          description: A JSON Pointer path.
          type: string
        op:
          description: The operation to perform.
          type: string
          enum:
            - move
            - copy
        from:
          description: A JSON Pointer path.
          type: string
```

Note that we use a separate `schema` for each option of the request, so we can i.e. autogenerate each portion of the request.
