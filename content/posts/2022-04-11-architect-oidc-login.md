---
title: "Protecting an Architect Framework Application with OAuth2 or OpenID Connect\
  \ Authentication"
description: "How to set up OAuth2/OpenID Connect authentication with an Architect\
  \ Framework application."
date: "2022-04-11T11:10:29+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1513461209563115524"
tags:
- "blogumentation"
- "architect-framework"
- "nodejs"
- "aws-lambda"
- "oidc"
- "indieauth"
- "oauth2"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/4bea95efe8.png"
slug: "architect-oidc-login"
---
I have a number of services that I use the [Architect Framework](https://arc.codes), as it's _really_ handy for creating an event-based, multi-Lambda (HTTP) application.

One of the things I like to do to is secure my services behind OAuth2/OpenID Connect, as it's a standard way of handling authorization, and a "log in with OAuth2/OpenID Connect" is a well-supported operation across languages and technologies.

For these Architect-backed services, I wanted to have a few protected routes such as access to logs that may expose sensitive information about the calls to the services.

As I use [IndieAuth](https://indieauth.spec.indieweb.org) as my identity layer, and we've recently made a lot of efforts to align IndieAuth with OAuth2, it's actually very straightforward to integrate with a standard OAuth2 client.

This leads to a slightly different flow than you'd use with a single service i.e. Google or GitHub login, but the gist of it should be viable for your own use.

I have taken the below code from a sample project [on GitLab](https://gitlab.com/jamietanna/architect-fraemwork-openid-connect-example), as a standalone way to test this.

I'm planning on publishing this as an NPM package so it's easier to use in a generic way, across projects.

# Code

## Protecting resources

Architect provides a really nicely abstracted session management setup, which allows us to set key-value data in the `req.session`, and means we don't need to handle how i.e. encrypt the session data, or manage session IDs.

To give us a handy way to require authentication, we can take advantage of that and store information in our session about the logged-in user, as well as add an expiry to enforce re-authentication regularly.

We can utilise the session handling in Architect to do something like this in our handler method for the incoming request:

```js
async function handler(req) {
  const session = req.session
  const isLoggedIn = await auth.isLoggedIn(session);
  if (!isLoggedIn) {
    delete session.auth_me; // `me` is the subject of the request, i.e. https://www.jvt.me/
    delete session.auth_time;
    return {
      session,
      html: `You're not logged in`
    }
  }

  return {
    session,
    html: `Welcome back ${session.auth_me}`
  }
}
```

This utilises the following snippet from `auth.js` to validate whether the user is logged in:

```js
const AUTH_TIME = 1000 * 60 * 60;

function authHasExpired(auth_time, now) {
  return (now - auth_time) >= AUTH_TIME;
}

async function isLoggedIn(session) {
  if (session === undefined || !session) {
    return false
  }
  if (session.auth_me === undefined || session.auth_time === undefined) {
    return false
  }
  if (authHasExpired(session.auth_time, new Date().getTime())) {
    return false;
  }

  return true;
}
```

Note that as well as an authentication check, we could perform additional authorization checks to validate that the user is the right one i.e. checking that they are present in a list of users that are allowed access to specific pages.

## Setting up the authentication flow

To actually start the authentication flow, we need a page to trigger this. In my case, I've got a `/start?me=${profile_url}` endpoint that uses IndieAuth to discover OAuth2 endpoints and then go through the OAuth2 flow as such, but you could just as easily have a `/start/github` that redirects to the GitHub authorization URL.

```js
const arc = require('@architect/functions')

const auth = require('@architect/shared/auth')
const profile = require('@architect/shared/profile')
const oidc = require('openid-client')

async function handler(req) {
  // simplified for this example
  const session = req.session
  session.discovery = 'https://indieauth.jvt.me/.well-known/oauth-authorization-server';

  const issuer = await oidc.Issuer.discover(session.discovery);

  const client = await auth.createClient(issuer)
  const code_verifier = oidc.generators.codeVerifier();
  session.verifier = code_verifier;

  const code_challenge = oidc.generators.codeChallenge(code_verifier);

  const authorizationUrl = client.authorizationUrl({
    scope: 'profile',
    code_challenge,
    code_challenge_method: 'S256',
  });

  return {
    status: 302,
    session,
    headers: {
      location: authorizationUrl
    }
  }
}
```

Then, we have our callback URL:

```js
const arc = require('@architect/functions')
const auth = require('@architect/shared/auth')

const oidc = require('openid-client')

async function handler(req) {
  const session = req.session

  const issuer = await oidc.Issuer.discover(session.discovery);
  const client = await auth.createClient(issuer)
  const code_verifier = session.verifier;

  const params = req.queryStringParameters
  const redirect = await auth.redirectUri()
  const tokenSet = await client.oauthCallback(redirect, params, { code_verifier });

  session.auth_time = new Date().getTime()
  session.auth_me = tokenSet.me;

  // just an example, but we'd probably want to redirect to where we were pre-auth, using something from the `req.session`
  return {
    session,
    html: `<pre>${JSON.stringify(tokenSet)}</pre>`
  }
}
```

Note that I'm using the `me`, which is returned by the IndieAuth token endpoint. Ideally we would use the Token Introspection endpoint - which may return some user information in the claims - or for an OpenID Connect solution, I would use the userinfo endpoint.

Notice that this takes advantage of a shared `createClient()` method, which simplifies duplication:

```js
async function redirectUri() {
  return process.env.BASE_URL + 'callback'
}

async function createClient(issuer) {
  return new issuer.Client({
    client_id: process.env.BASE_URL,
    redirect_uris: [await redirectUri()],
    response_types: ['code'],
    token_endpoint_auth_method: 'none' // required for IndieAuth
  });
}
```
