---
title: Dynamically retrieving the version of a Node.JS/Typescript dependency, at runtime
description: How to retrieve metadata about packages that are depended on at runtime.
tags:
- blogumentation
- nodejs
- typescript
date: 2023-03-12T11:21:24+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: nodejs-dynamic-version
---
Something I've needed for a side project is the ability to retrieve what version of a dependency has currently been resolved. It was quite hard to search around this online so I'm writing how to do it for future folks searching for this.

The below examples are based on [this example project on GitLab.com](https://gitlab.com/tanna.dev/nodejs-dynamic-version.git).

Let's say that we loosely pin `typescript`, but at runtime want to log out what version the following resolves to:

```json
{
  "devDependencies": {
    "typescript": "^4.x"
  }
}
```

Fortunately all NPM packages get distributed with their `package.json`s intact, so we can `require`/`import` the file and then log it out.

# Node.JS

With Node.JS this is trivial, as we can simply `require` the file, and then interact with it as an object:

```javascript
const packageJson = require('typescript/package.json');

console.log(`Currently running TypeScript v${packageJson.version}`);
```

When we run it:

```sh
node index.js
# Outputs:
# Currently running Typescript v4.9.5
```

# TypeScript

TypeScript requires a slightly more complex setup, as we need to specify the `resolveJsonModule` compiler option, which means we have a `tsconfig.json` similar to:

```json
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "compilerOptions": {
    "resolveJsonModule": true
  }
}
```

Then, we can write the following code:

```typescript
import * as packageJson from 'typescript/package.json';

console.log(`Currently running Typescript v${packageJson.version}`);
```

Therefore, we can run:

```sh
npm run build
node dist/index.js
# Outputs:
# Currently running Typescript v4.9.5
```
