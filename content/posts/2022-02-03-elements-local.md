---
title: "Running Elements API Viewer to Verify Local OpenAPI/Swagger Documents"
description: "How to run Elements UI locally to visualise OpenAPI documents."
tags:
- blogumentation
- swagger
- openapi
- cors
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-03T15:26:23+0000
slug: elements-local
---
Similar to my article yesterday about [locally running Swagger UI](/posts/2022/01/31/swagger-ui-local/), I wanted to load up an OpenAPI document today.

Unfortunately [Swagger UI lacks OpenAPI 3.1.0 support](https://github.com/swagger-api/swagger-ui/issues/5891), so the document I wanted to use wouldn't load.

Instead of hacking around with the code to get it working, I had a browse of [OpenAPI.tools](https://openapi.tools/#documentation) and found that Stoplight have an excellent Open Source project called [Elements](https://github.com/stoplightio/elements) which is a powerful, visually beautiful API viewer, which does support it.

The simplest way of getting this running is to use a Web Component like so, loading the OpenAPI document (and any other `$ref`s) from a `localhost` URL:

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Elements API Viewer</title>
    <!-- Embed elements Elements via Web Component -->
    <script src="https://unpkg.com/@stoplight/elements/web-components.min.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/@stoplight/elements/styles.min.css">
  </head>
  <body>

    <elements-api
      apiDescriptionUrl="http://localhost:8080/domains.openapi.json"
      router="hash"
      layout="sidebar"
    />

  </body>
</html>
```

As it performs this client-side we need to be providing CORS, which means we can use [`http-server`](/posts/2022/01/31/swagger-ui-local/#nodejs-http-server) like so:

```sh
# from the directory with the OpenAPI document(s)
npx http-server --cors
```
