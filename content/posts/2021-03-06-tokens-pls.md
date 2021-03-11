---
title: "Introducing tokens-pls, a Web Application to Test OAuth2 Code Flows"
description: "Announcing my new project, tokens-pls, which allows for easier manual testing with the OAuth2 code flow for Public Clients."
tags:
- indieauth
- oauth2
- token-pls
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-03-06T13:42:20+0000
slug: "tokens-pls"
syndication:
- https://news.indieweb.org/en
- https://indieweb.xyz/en/indieweb
---
Since I've been working a bit more with Micropub and IndieAuth, I've always had cases where I've wanted to test things locally, which requires retrieving an access token.

Fortunately, the OAuth2 Authorization Code grant is pretty straightforward, so doing this locally with i.e. `curl` is an OK process to go through, as well as using a guided tool such as <span class="h-card"><a class="u-url" href="https://seblog.nl">Sebastiaan Andeweg</a></span>'s <a href="http://gimme-a-token.5eb.nl/">gimme-a-token.5eb.nl</a>.

However, with [Proof of Key Code Exchange (PKCE)](https://oauth.net/2/pkce/) support now a requirement of IndieAuth, gimme-a-token isn't applicable, and the logic to run this locally with `curl` is a bit more complex, so I looked to script it.

I was thinking of creating a small script to go through the OAuth2 flow locally, with me copying-and-pasting the callback URL with granted authorization code, but thought I'd think a bit better about making this as easy as possible.

I've created a Sinatra app, [tokens-pls](https://gitlab.com/jamietanna/tokens-pls) for this, which provides an easy tool for going through the Authorization Code flow for a [Public Client](https://tools.ietf.org/html/draft-ietf-oauth-v2-1-01#section-2.1), which is currently hosted on Heroku at [tokens-pls.herokuapp.com](https://tokens-pls.herokuapp.com).

The app allows you to either start the authorization flow using your profile URL (at which point it will discover your `authorization_endpoint` and `token_endpoint` automagically, or you can manually provide the endpoints. It is up-to-date with the IndieAuth spec (at time of writing) and uses PKCE to protect the authorization request.

After the authorization code is exchanged, tokens-pls will return in its JSON response the response from the token endpoint, and if an `access_token`, `id_token` or `refresh_token` are provided and can be parsed as a [JSON Web Token](https://jwt.io/introduction/), they will be populated in the response too:

```json
{
  "token_endpoint_response": {
    "scope": "draft",
    "me": "https://www.staging.jvt.me/",
    "access_token": "eyJ...",
    "expires_in": 604800,
    "token_type": "Bearer"
  },
  "access_token_claims": {
    "aud": "https://www-api.jvt.me/",
    "sub": "https://www.staging.jvt.me/",
    "auth_time": 1615033025,
    "scope": "draft",
    "iss": "https://indieauth.jvt.me",
    "exp": 1615637825,
    "token_type": "access_token",
    "iat": 1615033025,
    "client_id": "https://tokens-pls.herokuapp.com",
    "jti": "558c7f46-e605-4b1d-8097-f12ed8efef94"
  }
}
```
