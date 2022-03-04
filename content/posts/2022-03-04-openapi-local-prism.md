---
title: "Generate a running mock server from an OpenAPI specification using Prism"
description: "Using Stoplight's `prism` tool to run a stubbed server from an OpenAPI specification, for better testing."
tags:
- blogumentation
- swagger
- openapi
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-03-04T17:52:41+0000
slug: openapi-local-prism
image: https://media.jvt.me/7be186e7a3.png
---
When you're building integrations with services, we generally want to shift testing left to give us faster feedback and to be able to rely on reducing the amounts of testing we need to do in i.e. a big shared integration environment.

However, to be able to do this, we need to create _representative_ stubs of services, which is less easy.

There are great tools out there like [Wiremock](https://wiremock.org) that can provide you handily configurable HTTP server, but you still need to make the effort of generating the stubs, which is the most awkward part.

With OpenAPI being a standard for documenting your APIs, as well as giving you a very strong schema for your request/response bodies, we'd hope to be able to generate a life-like stub for our services wouldn't we?

Today, I wanted to do this for one of my services, and had a look at [OpenAPI.tools](https://openapi.tools/) for an OpenAPI 3.1 supported tool, and was not surprised to see that <span class="h-card"><a class="u-url" href="https://stoplight.io">Stoplight</a></span> have an excellent tool for this, [Prism](https://github.com/stoplightio/prism/).

By running Prism against an OpenAPI spec, we can get a running HTTP server, supporting all the routes that are expected of the contract, and with data generated for the responses.

# Mock Server

We can run it like so:

```sh
# for static data, based on `examples`
npx @stoplight/prism-cli@latest mock openapi.yaml
# for dynamic data generation, based on the schema's provided formats
npx @stoplight/prism-cli@latest mock -d openapi.yaml
```

For instance, if we use the [OpenAPI from DigitalOcean](https://github.com/digitalocean/openapi), we can then interact with the running API, which can even do things like enforce headers:

```json
$ curl localhost:4010/v2/account/keys -i
HTTP/1.1 401 Unauthorized
Access-Control-Allow-Origin: *
Access-Control-Allow-Headers: *
Access-Control-Allow-Credentials: true
Access-Control-Expose-Headers: *
sl-violations: [{"location":["request"],"severity":"Error","code":401,"message":"Invalid security scheme used"}]
ratelimit-limit: 5000
ratelimit-remaining: 4816
ratelimit-reset: 1444931833
Content-type: application/json
Content-Length: 61
Date: Fri, 04 Mar 2022 17:44:47 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{
  "id": "unauthorized",
  "message": "Unable to authenticate you."
}
```

If we then add the `Authorization` header from the examples:

```json
$ curl localhost:4010/v2/account/keys -H 'Authorization: Bearer 123' -i
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Access-Control-Allow-Headers: *
Access-Control-Allow-Credentials: true
Access-Control-Expose-Headers: *
ratelimit-limit: 5000
ratelimit-remaining: 4816
ratelimit-reset: 1444931833
Content-type: application/json
Content-Length: 309
Date: Fri, 04 Mar 2022 17:46:08 GMT
Connection: keep-alive
Keep-Alive: timeout=5

{
  "links": {
  },
  "meta": {
    "total": 1
  },
  "ssh_keys": [
    {
      "fingerprint": "3b:16:e4:bf:8b:00:8b:b8:59:8c:a9:d3:f0:19:fa:45",
      "id": 289794,
      "name": "Other Public Key",
      "public_key": "ssh-rsa ANOTHEREXAMPLEaC1yc2EAAAADAQABAAAAQQDDHr/jh2Jy4yALcK4JyWbVkPRaWmhck3IgCoeOO3z1e2dBowLh64QAM+Qb72pxekALga2oi4GvT+TlWNhzPH4V anotherexample"
    }
  ]
}
```

Prism also performs validation of request/response and warns on cases like an invalid OpenAPI document.

# Validation proxy

Prism also has the ability to allow you act as a validation proxy, which routes traffic through to the real API, and validates that the requests/responses are valid according to the contract!
