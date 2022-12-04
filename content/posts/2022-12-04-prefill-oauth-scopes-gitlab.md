---
title: Prefilling OAuth2 scopes for GitLab Personal Access Tokens
description: How to make it easier to set up your OAuth2 scopes on a Personal Access Token with GitLab.
tags:
- blogumentation
- gitlab
- oauth2
image: https://media.jvt.me/c02cdf0130.png
date: 2022-12-04T21:34:29+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: prefill-oauth-scopes-gitlab
syndication:
- https://brid.gy/publish/twitter
---
When working with GitLab Personal Access Tokens, it can be handy to pre-fill the information for a given scope.

Unlike [GitHub's personal access tokens](https://www.jvt.me/posts/2022/12/04/prefill-oauth-scopes-github/), GitLab does [document this functionality](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#prefill-personal-access-token-name-and-scopes), where we can pre-fill the scopes and name of the token, by constructing a URL like:

```
https://gitlab.example.com/-/profile/personal_access_tokens?name=Example+Access+token&scopes=api,read_user,read_registry
```
