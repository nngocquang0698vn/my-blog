---
title: Getting a GitHub App installation token on the command-line
description: How to get a GitHub App installation token (using Typescript) for a given installation.
tags:
- blogumentation
- typescript
- github
date: 2023-02-11T21:42:27+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: github-app-token-typescript
---
When using [GitHub App authentication](https://docs.github.com/en/developers/apps/building-github-apps/authenticating-with-github-apps), there's a slightly more complex setup for authenticating.

Depending on what you're doing you can simply use the GitHub SDKs, but sometimes you just want an installation access token, for instance to clone a repository as the app.

To do this, I've found that a straightforward command-line app is best:

```typescript
import { createAppAuth } from '@octokit/auth-app'
import { App } from '@octokit/app'

(async () => {
  const appId = process.env.GITHUB_APP_ID ?? ''
  const privateKey = (process.env.GITHUB_APP_KEY ?? '').replaceAll(/\\n/g, '\n')
  const installationId = process.env.GITHUB_INSTALLATION_ID ?? ''

  const auth = createAppAuth({
    appId,
    privateKey
  })

  const resp = await auth({
    type: 'installation',
    installationId,
  })
  console.log(resp.token)
})().catch((e) => {
  console.error(e)
  process.exit(1)
})
```

This requires the following setup:

<details>

<summary><code>package.json</code></summary>

```json
{
  "dependencies": {
    "@octokit/app": "^13.1.2",
    "@octokit/auth-app": "^4.0.9"
  },
  "devDependencies": {
    "@tsconfig/node16": "^1.0.3",
    "typescript": "^4.8.4"
  },
  "bin": "dist/index.js",
  "scripts": {
    "build": "tsc"
  }
}

```

</details>

<details>

<summary><code>tsconfig.json</code></summary>

```json
{
  "dependencies": {
    "@octokit/app": "^13.1.2",
    "@octokit/auth-app": "^4.0.9"
  },
  "devDependencies": {
    "@tsconfig/node16": "^1.0.3",
    "typescript": "^4.8.4"
  },
  "bin": "dist/index.js",
  "scripts": {
    "build": "tsc"
  }
}

```

</details>

But then can be run with:

```sh
npm i
npm run build
# Encode the private key for an environment variable via https://www.jvt.me/posts/2023/02/11/pem-environment-variable/
env GITHUB_APP_ID=... GITHUB_APP_KEY="$(sed ':a;N;$!ba;s/\n/\\n/g' key.pem)" GITHUB_INSTALLATION_ID=... node dist/index.js
```
