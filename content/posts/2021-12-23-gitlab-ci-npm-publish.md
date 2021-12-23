---
title: "Publishing a NPM Package to npmjs.com from GitLab CI"
description: "How to publish an NPM package to the public NPM registry, using GitLab CI."
tags:
- blogumentation
- nodejs
- gitlab-ci
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-23T11:01:55+0000
slug: "gitlab-ci-npm-publish"
image: /img/vendor/nodejs.png
---
To be able to more easily release packages to the NPM registry, we likely want to have our CI/CD process publish packages on tagged versions.

As I use GitLab CI for personal projects, I wanted to set this up, and through a mix of [Eleanor Holley's article](https://webbureaucrat.gitlab.io/posts/continuously-deploying-an-npm-package-with-gitlab-ci-cd/) and a bit of brute force, I've managed to be happy with the following setup:


```yaml
image: node:16

stages:
  - test
  - publish

cache:
  paths:
    - node_modules/

test:
  script:
    - npm ci
    - npm run lint
    - npm run test
    # any other steps

publish:
  stage: publish
  only:
    - tags
  script:
    - npm run ci-publish
```

Now, the biggest gotcha I had was that my `NPM_TOKEN` wasn't being registered, and so CI builds were failing with:

<details>

<summary>Example <code>ENEEDAUTH</code> errors</summary>

```
npm ERR! code ENEEDAUTH
npm ERR! need auth This command requires you to be logged in.
npm ERR! need auth You need to authorize this machine using `npm adduser`
npm ERR! A complete log of this run can be found in:
npm ERR!     /root/.npm/_logs/2021-12-23T09_49_35_606Z-debug.log
```

</details>

I'd thought it was the way I was doing it (by editing the `.npmrc`) so I moved over to `ci-publish`, but it turns out it was because GitLab CI's protected mode for CI/CD variables requires the _tags_ to have protection, too.
