---
title: "Converting an Image to a Base64 `data` URL with Node.JS"
description: "How to convert an image to a `data` URL using Node.JS on the command-line."
tags:
- blogumentation
- nodejs
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-06T18:41:19+0000
slug: "node-data-url"
image: /img/vendor/nodejs.png
---
[Data URLs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Data_URIs) are a pretty handy way of encoding small files, or binary data, into HTML.

Sometimes you'll want to use them for adding images inline into an HTML file, so will want a handy way of converting the image to the correctly formatted URL, of the form:

```sh
data:image/png;base64,....
```

A "good enough" script is to use the following, which fits into a oneliner:

```sh
node -e 'console.log(`data:image/png;base64,${fs.readFileSync(process.argv[1], "base64")}`)' /path/to/image
```

Or as a standalone script:

```javascript
// node image.js /path/to/image
const fs = require('fs')
const contents = fs.readFileSync(process.argv[2], "base64")

console.log(`data:image/png;base64,${contents}`)
```

Note that we've hardcoded `image/png` - Firefox (v91 Nightly, at the time of writing) allows either a JPEG or a PNG to be provided as such, which is great, as does Chromium (v96), but this isn't the best solution as it may not always work.

A better solution is that we use the [`image-type` library](https://www.npmjs.com/package/image-type/v/4.1.0) to correctly determine the media type for the provided file:

```javascript
const fs = require('fs')
const imageType = require('image-type')

const contents = fs.readFileSync(process.argv[2])
const b64 = contents.toString('base64')

const type = imageType(contents)
if (type.mime === null) {
  process.exit(1)
}

console.log(`data:${type.mime};base64,${b64}`)
```

Which can then be run as:

```sh
node image.js /path/to/image
```
