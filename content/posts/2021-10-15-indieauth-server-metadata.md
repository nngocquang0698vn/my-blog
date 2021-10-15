---
title: "Implementing IndieAuth Server Metadata"
description: "Announcing support for OAuth Server Metadata on my IndieAuth Server."
date: "2021-10-15T22:35:50+0100"
syndication:
- "https://news.indieweb.org/en/www.jvt.me/posts/2021/10/15/indieauth-server-metadata/"
- "https://indieweb.xyz/en/indieweb"
tags:
- "www.jvt.me"
- "indieauth.jvt.me"
- "indieauth"
- "oauth2"
- "oidc"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "indieauth-server-metadata"
---
Something that can make interacting with services quite straightforward is being able to dynamically discover configuration.

For instance, Open Banking's standards are built on top of OpenID Connect, and provide the very handy [OpenID Connect Discovery](https://openid.net/specs/openid-connect-discovery-1_0.html), allowing a client to retrieve information about i.e. what authentication methods are supported for the token endpoint.

With the [IndieAuth](https://indieauth.spec.indieweb.org) standard, we're building on top of OAuth2 to provide a means to decentralise identity.

Currently, we provide two endpoints in IndieAuth, the `authorization_endpoint` and `token_endpoint`, which can be [discovered](https://indieauth.spec.indieweb.org/#discovery-by-clients) in either a `Link` HTTP Header, or a `<link>` element in the HTML of a page.

As we move to adding more endpoints, the need to add further links out to these endpoints gets more cumbersome, and so we've started to look at options. As IndieAuth is built on top of OAuth2, we can use the [OAuth 2.0 Authorization Server Metadata](https://tools.ietf.org/html/rfc8414) standard for this means, opposed to OpenID Connect Discovery.

We've been discussing this [on the IndieAuth spec repo](https://github.com/indieweb/indieauth/issues/43) and are hoping to discuss it a little bit more tomorrow at the [IndieAuth Popup Session](https://events.indieweb.org/2021/10/indieauth-2-popup-session-5y88zAw4LtO9).

Ahead of the conversation, I've added support for this, producing information about all supported functionality the server provides, so clients can start to consume it.

You can see the configuration at `https://indieauth.jvt.me/.well-known/oauth-authorization-server`, which currently resolves to:

```json
{
  "authorization_endpoint": "https://indieauth.jvt.me/authorize",
  "code_challenge_methods_supported": [
    "S256"
  ],
  "grant_types_supported": [
    "refresh_token",
    "authorization_code"
  ],
  "introspection_endpoint": "https://indieauth.jvt.me/token_info",
  "issuer": "https://indieauth.jvt.me",
  "response_modes_supported": [
    "query"
  ],
  "response_types_supported": [
    "code"
  ],
  "scopes_supported": [
    "read",
    "profile",
    "update",
    "mute",
    "media",
    "follow",
    "delete",
    "notify",
    "channels",
    "draft",
    "undelete",
    "create",
    "block"
  ],
  "token_endpoint": "https://indieauth.jvt.me/token"
}
```

I've also started to advertise a `<link rel=indieauth>` on my site, so clients can discover this metadata endpoint.
