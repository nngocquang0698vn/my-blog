---
title: "Autogenerating the `Date` Header in Postman"
description: "How to generate and send a `Date` header using Postman."
tags:
- blogumentation
- postman
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-04-29T18:02:03+0100
slug: "postman-date-header"
image: https://media.jvt.me/2e899bbe68.png
---
If you're working with APIs there is a chance you may be using [Postman](https://www.postman.com/) to interact with it.

The APIs you're interacting with may require the `Date` header, to know at what point in time the request has originated. Most HTTP clients, Postman included, will not send this by default, so we need to do a little bit of work to get it sending.

Also, because it's very likely important what date is used, we should generate it each time. Fortunately, we can use Postman's pre-request scripting with its JavaScript support, following [MDN's documentation] to generate a compliant (modern) date format:

```javascript
pm.globals.set("dateHeader", new Date().toUTCString()); // => Wed, 29 Apr 2020 16:50:34 GMT
```

Then in Postman, we can reference this variable in our header as `{{headerValue}}`.
