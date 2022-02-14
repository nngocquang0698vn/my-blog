---
title: "Bundling Multi-File OpenAPI Documents into a Single File"
description: "Looking at the options we have for converting a multi-file OpenAPI specification to a single document."
tags:
- blogumentation
- openapi
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-10T11:35:19+0000
slug: bundle-openapi
syndication:
- "https://brid.gy/publish/twitter"
image: https://media.jvt.me/7be186e7a3.png
---
OpenAPI documents can get pretty large, especially when you're documenting all the various API request and response entities. To simplify this, we can split it into multiple files, and use `$ref`s to "include" the other files.

However, as I found with creating [a client-side OpenAPI viewer](/posts/2022/02/08/openapi-client-side/), splitting files down makes it difficult when tools aren't able to resolve the `$ref`s themselves.

Fortunately, there are tools around that can help us bundle OpenAPI documents into a single file.

Because I'm building a few APIs from scratch at the moment, I can use OpenAPI 3.1.0, but it turns out that not all the tools we would want to use are possible.

For instance, the official [`swagger-codegen-cli`](https://stackoverflow.com/a/54593633/2257038) [does not yet support OpenAPI 3.1.0](https://github.com/swagger-api/swagger-codegen/issues/11627).

Another [top hit on that StackOverflow](https://stackoverflow.com/a/54586138/2257038) is [Speccy](https://github.com/wework/speccy), which is no longer supported.

# Example spec

Let's take the following, fairly minimal OpenAPI 3.1.0 example:

```yaml
openapi: 3.1.0
info:
  title: Example API
  version: '0.1.0'
paths:
  "/":
    get:
      description: Do something
      responses:
        '200':
          content:
            application/json:
              schema:
                $ref: './response.json'
```

Which then has `response.json`:

```json
{
  "$schema": "https://json-schema.org/draft/2019-09/schema",
  "title": "Response object",
  "description": "The more descriptive name for the Response Object spec",
  "type": "object",
  "required": [
    "name"
  ],
  "properties": {
    "name": {
      "$comment": "The name of the API",
      "type": "string"
    }
  },
  "additionalProperties": false
}
```

# Using `@redocly/openapi-cli`

Redocly's `openapi` CLI tool allows us to run i.e.:

```sh
npx @redocly/openapi-cli@latest bundle openapi.yml > out.yml
```

Which then creates a single `out.yml` which has all our document bundled.
