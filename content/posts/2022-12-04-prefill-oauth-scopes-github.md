---
title: Prefilling OAuth2 scopes for GitHub Personal Access Tokens
description: How to make it easier to set up your OAuth2 scopes on a Personal Access Token with GitHub.
date: 2022-12-04T21:34:29+0000
tags:
- blogumentation
- github
- oauth2
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/36fd7d2a48.png
slug: prefill-oauth-scopes-github
syndication:
- https://brid.gy/publish/twitter
---
A while ago, I was setting up a fair few GitHub Personal Access Tokens, and was finding it a little frustrating to need to keep hand-selecting the scopes required. I can't actually remember how I found out about it, but it turns out that by tweaking the URL, you can pre-fill the scopes that are selected.

I'd [shared this knowledge](https://github.com/ossf/scorecard-action/pull/145) with a project that would benefit from this, but I've not publicly blogged about this for other folks who may not know this.

Let's say you want to create a new token that has access to `public_repo` and `repo`, we can construct the URL:

```
https://github.com/settings/tokens/new?scopes=public_repo,repo
```

Going to [the URL above](https://github.com/settings/tokens/new?scopes=public_repo,repo) gives you a handy pre-filled form, but still allows you to review it, add your own note for what the token is, and set expiry.

Right now, this only works for Personal Access Tokens (Classic).
