---
title: "API Design tip: use objects for similar data"
description: "Why you should use objects to nest similar data in JSON responses."
date: "2022-06-02T17:21:22+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1532398907451494407"
tags:
- "api"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/5e284286be.jpeg"
slug: "api-design-objects"
---
Let's say you're building an API, be it RESTful or GraphQL, and you want to provide a few bits of similar data. Or maybe you've only got one piece of data (i.e an external identifier, but you rightfully so are thinking about future-proofing your API.

For instance, if we're building a Pipeline service, that executes CI/CD pipelines, we may initially reach for the following setup:

```json
{
  "pipeline_id": "123",
  "namespace_id": "...",
  "namespace_path": "...",
  "project_id": "...",
  "project_path": "...",
  "user_id": "...",
  "user_login": "...",
  "user_email": "..."
}
```

Instead, it's better to wrap this into a specific object, such as:

```json
{
  "pipeline_id": "123",
  "namespace": {
    "id": "...",
    "path": "..."
  },
  "project": {
    "id": "...",
    "path": "..."
  },
  "user": {
    "id": "...",
    "login": "...",
    "email": "..."
  }
}
```

This gives us an easier structure, which is easier to visually parse, and keeps similar data together. Instead of doing this later - as a breaking change - we can design it up front, and it works nicely.

It also can highlight where data is not owned by the service, as it's not top-level.
