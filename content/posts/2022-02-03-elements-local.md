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
image: https://media.jvt.me/7be186e7a3.png
---
Similar to my article yesterday about [locally running Swagger UI](/posts/2022/01/31/swagger-ui-local/), I wanted to load up an OpenAPI document today.

Unfortunately [Swagger UI lacks OpenAPI 3.1.0 support](https://github.com/swagger-api/swagger-ui/issues/5891), so the document I wanted to use wouldn't load.

Instead of hacking around with the code to get it working, I had a browse of [OpenAPI.tools](https://openapi.tools/#documentation) and found that Stoplight have an excellent Open Source project called [Elements](https://github.com/stoplightio/elements) which is a powerful, visually beautiful API viewer, which does support it.

# Purely client-side

Update 2022-02-08: it appears that this is possible using the `apiDescriptionDocument` property, which means we can use our Web Component like so, allowing us to upload the OpenAPI spec, removing the need to host it anywhere (even localhost).

Note that this will not work if your OpenAPI spec is split across different files, but you can resolve this by [bundling them into a single file](/posts/2022/02/10/bundle-openapi/).

```html
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Elements API Viewer</title>
    <!-- Embed elements Elements via Web Component -->
    <script src="https://unpkg.com/@stoplight/elements/web-components.min.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/@stoplight/elements/styles.min.css">
  </head>
  <body>

    <label for="file-input">API specification
      <input type="file" name="file-input" id="file-input" value="">
    </label>

    <hr />

    <elements-api id="docs" router="hash" layout="sidebar"></elements-api>

    <script>
      let fileInput = document.getElementById('file-input')

      fileInput.onchange = () => {
        const docs = document.getElementById('docs');

        const reader = new FileReader()
        reader.onload = (e) => docs.apiDescriptionDocument = e.target.result;

        for (let file of fileInput.files) {
          reader.readAsText(file)
        }
      }
    </script>
  </body>
</html>
```

# Using an HTTP URL

Alternatively, we can use the Web Component like so, loading the OpenAPI document (and any other `$ref`s) from a `localhost` URL:

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
