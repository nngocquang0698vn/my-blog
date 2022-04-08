---
title: "Getting node-canvas to run on AWS Lambda"
description: "Some common issues that occur when using node-canvas on AWS Lambda,\
  \ and how to solve them."
date: "2022-04-08T14:29:16+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1512424148164915206"
tags:
- "blogumentation"
- "javascript"
- "nodejs"
- "aws-lambda"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/770ef46545.png"
slug: "node-canvas-lambda"
---
Last week, while I was [creating a service for parsing metadata from TikTok videos](https://www.jvt.me/posts/2022/04/01/tiktok-mf2/), I encountered a few issues getting the [node-canvas](https://github.com/Automattic/node-canvas) library to work on AWS Lambda.

In the [spirit of blogumentation](/posts/2017/06/25/blogumentation/), I wanted to document this for anyone else who may see this.

# Missing shared libraries

The first issue I faced was an error similar to the below:

```json
{
    "errorType": "Error",
    "errorMessage": "libuuid.so.1: cannot open shared object file: No such file or directory",
    "code": "ERR_DLOPEN_FAILED",
    "stack": [
        "Error: libuuid.so.1: cannot open shared object file: No such file or directory",
        "..."
    ]
}
```

This is because node-canvas relies on a number of native libraries, which don't exist on the stripped-down AWS Lambda runtime.

I found [Charoite Lee's Lambda layer](https://github.com/charoitel/lambda-layer-canvas-nodejs) as an effective way of solving this, and a straightforward way to configure it in our Lambdas.

# Use x86 architecture

One of the cost improvements I use for my Lambdas is using ARM architecture, due to [price and efficiency benefits](https://aws.amazon.com/about-aws/whats-new/2021/09/better-price-performance-aws-lambda-functions-aws-graviton2-processor/).

The next issue I fought getting node-canvas working was that [ARM architecture is not supported out-of-the-box](https://github.com/Automattic/node-canvas/issues/1662).

Unfortunately this fails with an error similar to:

```json
{
    "errorType": "Error",
    "errorMessage": "/var/task/node_modules/canvas/build/Release/canvas.node: cannot open shared object file: No such file or directory",
    "code": "ERR_DLOPEN_FAILED",
    "stack": [
        "Error: /var/task/node_modules/canvas/build/Release/canvas.node: cannot open shared object file: No such file or directory",
        "..."
    ]
}
```

The solution here is to use the x86 architecture, until ARM prebuilds are available, or build the ARM version yourself.

# Configuring `LD_PRELOAD`

Next, I encountered an issue where the version of the zlib compression library wasn't being picked up correctly:

```json
{
    "errorType": "Error",
    "errorMessage": "/lib64/libz.so.1: version `ZLIB_1.2.9' not found (required by /var/task/node_modules/canvas/build/Release/libpng16.so.16)",
    "code": "ERR_DLOPEN_FAILED",
    "stack": [
        "Error: /lib64/libz.so.1: version `ZLIB_1.2.9' not found (required by /var/task/node_modules/canvas/build/Release/libpng16.so.16)",
        "..."
    ]
}
```

As noted [by this GitHub comment](https://github.com/Automattic/node-canvas/issues/1779#issuecomment-861944060), we need to amend `LD_PRELOAD` to contain our `libz.so`:

```sh
LD_PRELOAD=/var/task/node_modules/canvas/build/Release/libz.so.1
```

# Use Node 14 to build+deploy

The final issue I had was that I was using a newer version of Node to build + deploy to AWS, which then introduced the following error:

```json
{
    "errorType": "Error",
    "errorMessage": "The module '/var/task/node_modules/canvas/build/Release/canvas.node'\nwas compiled against a different Node.js version using\nNODE_MODULE_VERSION 102. This version of Node.js requires\nNODE_MODULE_VERSION 83. Please try re-compiling or re-installing\nthe module (for instance, using `npm rebuild` or `npm install`).",
    "code": "ERR_DLOPEN_FAILED",
    "stack": [
        "Error: The module '/var/task/node_modules/canvas/build/Release/canvas.node'",
        "was compiled against a different Node.js version using",
        "NODE_MODULE_VERSION 102. This version of Node.js requires",
        "NODE_MODULE_VERSION 83. Please try re-compiling or re-installing",
        "the module (for instance, using `npm rebuild` or `npm install`).",
        "..."
    ]
}
```

The solution I needed was to use the same version of Node locally as AWS, which was Node 14.
