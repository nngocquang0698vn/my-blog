---
title: "Only Adding Changes for Tracked Files With Git"
description: "How to only add files that have changed with `git add -u`."
tags:
- blogumentation
- nablopomo
- git
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-21T22:30:37+0000
slug: "git-add-tracked"
series: nablopomo-2019
image: /img/vendor/git.png
---
Let's say that we have a Git repo where we've made a number of changes, such as:

```
 M www-api-web/postdeploy/src/main/java/me/jvt/www/api/postdeploy/Configuration.java
 M www-api-web/postdeploy/src/main/java/me/jvt/www/api/postdeploy/client/PhpMicroformatsIoHfeedParserClient.java
 M www-api-web/postdeploy/src/main/java/me/jvt/www/api/postdeploy/client/TelegraphWebmentionClient.java
 M www-api-web/postdeploy/src/main/java/me/jvt/www/api/postdeploy/service/CarefulWebmentionService.java
 M www-api-web/postdeploy/src/main/java/me/jvt/www/api/postdeploy/service/WebmentionService.java
 M www-api-web/postdeploy/src/test/java/me/jvt/www/api/postdeploy/ApplicationIntegrationTest.java
?? .ignored
?? www-api-web/postdeploy/src/main/java/me/jvt/www/api/postdeploy/service/PostDeployServiceImpl.java
```

Let's say that we want to `git add www-api-web/postdeploy`, but don't want to add the newly created `PostDeployServiceImpl`. We would ideally use `git add -p`, but for argument's sake let's say we don't want to do it as there are lots of files and we don't want to go through all the changes - we know what we want to add.

The solution for this is using `git add -u ${pathspec}` i.e.

```sh
git add -u www-api-web/postdeploy
```

This will then `--update` the files that are already tracked by Git, no others.
