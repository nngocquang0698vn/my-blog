---
title: "Accessing the OpenAPI Specification for a Kubernetes Cluster"
description: "How to get the OpenAPI specification for your Kubernetes Cluster."
tags:
- blogumentation
- kubernetes
- openapi
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-03-16T18:26:04+0000
slug: "kubernetes-openapi"
image: https://media.jvt.me/735ffcb6bd.png
syndication:
- "https://brid.gy/publish/twitter"
---
I'm a big fan of working with OpenAPI specifications, and while working with Kubernetes APIs today I wanted to check what the API expected.

Fortunately, Kubernetes produces the cluster's supported OpenAPI at the `/openapi/v2` URL, which means that using [Jonny Langefeld's post](https://jonnylangefeld.com/blog/kubernetes-how-to-view-swagger-ui) we can use `kubectl proxy` to port-forward, and then grab a copy of the OpenAPI:

```sh
kubectl proxy --port=8080
curl localhost:8080/openapi/v2 > openapi.json
```

This can then be used with your favourite OpenAPI viewer, such as a [local-only, client-side viewer](https://www.jvt.me/posts/2022/02/08/openapi-client-side/) to give you handy API documentation.
