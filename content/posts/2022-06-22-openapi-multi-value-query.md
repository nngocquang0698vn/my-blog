---
title: "Describing a multi-value querystring parameter in OpenAPI"
description: "How to define a querystring parameter that has multiple values, in OpenAPI."
date: "2022-06-22T18:24:21+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1539662949060644864"
tags:
- "blogumentation"
- "openapi"
- "api"
- "json-patch"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/7be186e7a3.png"
slug: "openapi-multi-value-query"
---
If you're building an API, you may want to have the option of querying or filtering multiple values, and want to make it clear to a consumer, through your OpenAPI spec.

Let's say that we want to allow a query which includes a parameter `post-type`, which can have the values `article`, `bookmark` and `reply`.

To do this with OpenAPI, we'd construct the following:

```yaml
components:
  parameters:
    PostType:
      # this doesn't have to include `[]`, but it's a good indicator that
      # it's a multi-value option, even though it's a valid HTTP thing to do,
      # to provide multiple values with just `post-type`
      name: "post-type[]"
      in: query
      explode: true
      schema:
        type: array
        items:
          $ref: '#/components/schemas/PostType'
  schemas:
    PostType:
      type: string
      enum:
        - article
        - bookmark
        - reply
```

The important thing here is the `explode` and marking the items as an `array`.

This works with both OpenAPI 3.0 and OpenAPI 3.1.
