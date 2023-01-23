---
title: "Who does this NPM token belong to?"
description: "How to work out whether an arbitrary NPM token is valid, and if so, which user account it belongs to."
date: 2023-01-23T11:44:41+0000
tags:
- blogumentation
- nodejs
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/03019529e6.png
slug: npm-who-token
---
Let's say you've just found something that looks like it's an NPM token, and you want to work out whether it's still valid.

One option is to try and download a dependency using it, but that can be a little more awkward to do, when there are easier means to do so.

# With `npm`

Let's say we've found a `.npmrc`:

```
//registry.npmjs.org/:_authToken=f...
```

Alternatively if this is a newer token, it'll be prefixed with `npm_`.

Fortunately the `npm` CLI contains a `whoami` subcommand, which means we can run:

```sh
env NPM_TOKEN=f... npm whoami
```

This will return the user that's authenticated, or an error.

# With `curl`

This works when you're using the main registry, but when trying to check with different registry, i.e. `registry.yarnpkg.com`, you get:

```
env NPM_TOKEN=f... npm whoami --registry https://registry.yarnpkg.com
npm ERR! code ENEEDAUTH
npm ERR! need auth This command requires you to be logged in.
npm ERR! need auth You need to authorize this machine using `npm adduser`
```

However, if we run `npm whoami --verbose`, we can see that it performs an HTTP GET request like so:

```sh
curl https://registry.npmjs.org/-/whoami -H 'Authorization: Bearer npm_...'
```

This is implemented by other registries such as the Yarn registry, meaning that if we were to find credentials such as:


```yaml
npmRegistries:
  //registry.yarnpkg.com:
    npmAlwaysAuth: true
    npmAuthToken: f.....
```

Then we'd be able to check if they were still valid by running:

```
curl -i https://registry.yarnpkg.com/-/whoami -H 'Authorization: Bearer f...'
HTTP/2 200
...
{"username":"..."}
```

Alternatively we'd see a 401 when invalid:

```
curl -i https://registry.yarnpkg.com/-/whoami -H 'Authorization: Bearer f...'
HTTP/2 401
...
{}
```
