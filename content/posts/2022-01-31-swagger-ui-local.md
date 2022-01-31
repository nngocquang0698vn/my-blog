---
title: "Running Swagger UI to Verify Local OpenAPI/Swagger Documents"
description: "How to run Swagger UI locally to visualise OpenAPI documents."
tags:
- blogumentation
- swagger
- openapi
- cors
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-31T18:07:02+0000
slug: swagger-ui-local
---
Something that's really handy for visualising OpenAPI, or older Swagger, documents is the [Swagger UI](https://github.com/swagger-api/swagger-ui) project.

If you've got a publicly resolvable OpenAPI document available, you can use the [Swagger UI found on petstore.swagger.io](https://petstore.swagger.io/), but in a lot of cases this isn't possible, especially as you'd need to get CORS settings correct.

Additionally, you may not want to be publishing your OpenAPI specs publicly, so need the option of running it locally.

There are a few options to running it, which I thought I'd document as I spent a while fighting this today.

# Docker

The documentation on the project doesn't appear to work for me, as I'm receiving HTTP 403s when trying to read the contract. I've raised [this patch](https://github.com/swagger-api/swagger-ui/pull/7817) to fix it upstream, which leads us to i.e. the following, for the `domains.openapi.json` contract:

```sh
docker run -p 80:8080 -e SWAGGER_JSON=domains.openapi.json -v $PWD/domains.openapi.json:/usr/share/nginx/html/domains.openapi.json swaggerapi/swagger-ui
```

# Serving with our own HTTP server

Alternatively, we can use the built version of the HTML/CSS/JavaScript assets and serve them through a local HTTP server.

The built version of the package can be found either [in the `dist` folder in the repo](https://github.com/swagger-api/swagger-ui/tree/master/dist), or using the [NPM package swagger-ui-dist](https://www.npmjs.com/package/swagger-ui-dist).

For instance, if we download via NPM:

```sh
npm i swagger-ui-dist
cd ./node_modules/swagger-ui-dist
# we're now in the right directory for the following commands
cp /path/to/swagger.json .
```

## NodeJS `http-server`

For example, we can use NodeJS' `http-server` package to serve the directory.

From the `dist` / `swagger-ui-dist` folder, we can run:

```sh
npx http-server --cors
```

Which will then serve the directory HTTP, allowing CORS requests, and we can point Swagger UI to the `./swagger.json` file.

## Python

Python's inbuilt `http.server` module works in a pinch, too, which means from the `dist` / `swagger-ui-dist` folder, we can run:

```sh
python -m http.server
```

Which we can also use to point to the `./swagger.json` file.
