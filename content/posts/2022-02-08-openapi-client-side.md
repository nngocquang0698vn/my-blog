---
title: "Announcing `openapi.tanna.dev`, a client-side OpenAPI Viewer"
description: "Creating a hosted version of a local and client-side only OpenAPI viewer."
tags:
- openapi.tanna.dev
- swagger
- openapi
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-08T22:00:34+0000
slug: openapi-client-side
syndication:
- "https://brid.gy/publish/twitter"
---
As noted in my article, [_Running Elements API Viewer to Verify Local OpenAPI/Swagger Documents_](/posts/2022/02/03/elements-local/), it can be handy viewing OpenAPI files locally.

[Elements](https://github.com/stoplightio/elements) is a really nice option, and bundles a handy Web Component which we can use, alongside some crafty client-side JavaScript, make a tool that allows us to render everything client-side, so we don't need to push our - potentially sensitive - OpenAPI specifications anywhere.

I've amended my article above with the code for this, and can be found at [on GitLab](https://gitlab.com/jamietanna/openapi.tanna.dev), and hosted on [openapi.tanna.dev](https://openapi.tanna.dev).

This is really useful for the case that we've got proprietary, or maybe at least not-yet-ready specifications to view.

Now, I want people to remember to [never trust online tools](/posts/2020/09/01/against-online-tooling/). Even though I wrote this tool, and have made it available for usage, I still want y'all to remember to consider your own threat profile.
