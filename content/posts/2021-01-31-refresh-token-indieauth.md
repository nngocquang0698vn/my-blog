---
title: "Implementing the Refresh Token Grant in my IndieAuth Server"
description: "Announcing support for long-lived refresh tokens as part of my IndieAuth server."
tags:
- www.jvt.me
- indieauth.jvt.me
- indieauth
- oauth2
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-01-31T19:21:29+0000
slug: "refresh-token-indieauth"
syndication:
- https://news.indieweb.org/en
- https://indieweb.xyz/en/indieweb
---
Part of my drive to [implement my own IndieAuth Server]({{< ref 2020-12-09-personal-indieauth-server >}}) was that it would allow me to experiment with IndieAuth, the Open Web extension for OAuth2, and propose tweaks or extensions for the future.

When I implemented my IndieAuth server, I had implemented the ability to limit my access token lifetimes, as I would prefer to have to re-authorize more often, than allow a compromised token to allow limitless access to my accounts.

This limited access is great for cases where I'm involved in what's happening, such as publishing a post in a mobile app, where I could re-authorize the app while I'm going through the publishing flow, but for applications that are meant to be running in the background, that's not possible.

In the case of two services I run - [a service to backfill my step counts]({{< ref 2019-10-27-owning-step-count >}}), and a service which [sends Webmentions after my site has published]({{< ref 2019-09-10-webmentions-on-deploy >}}), and then updates my site with any syndication links - both need an access token to communicate with my Micropub endpoint, but shouldn't require me to be regularly re-authorizing their access.

This, as I found last week, is problematic with expiring tokens because I had forgot over the last few weeks to refresh the configured access token (which was granted by me manually going through the flow, and then storing the issued access token), which has meant my step counts and syndication links have not been publishing to my site.

The intermediate solution was to make those services actual IndieAuth clients so I could authorize them, and update the tokens they had available, but that still requires a manual interaction, at least once every 30 days (which was the previous token lifetime before this change).

I trust these applications, and I know I'd like them to have persistent access so I don't have to interact with them - so what were my options?

Within OAuth2, there is the [Refresh Token Grant](https://oauth.net/2/grant-types/refresh-token/) for this exact purpose, which allows a client to refresh a longer-lived refresh token with a short-lived access token.

I'd decided that this would be preferable to the [Client Credentials Grant](https://oauth.net/2/grant-types/client-credentials/) - which was my first thought - as the Refresh Token Grant was something I could see other clients looking at doing in the future, whereas Client Credentials is unlikely to be that widespread, due to unnecessary complexity, and the goal of IndieAuth being that we don't need to pre-register clients.

This has led to me implementing the Refresh Token Grant this week, which is now live on my IndieAuth server.

Through some conversations with <span class="h-card"><a class="u-url p-name" href="https://aaronparecki.com">Aaron</a></span> and <span class="h-card"><a class="u-url p-name" href="https://vanderven.se/martijn/">Martijn</a></span> [on chat](https://chat.indieweb.org/dev/2020-11-17) I've gone for the ability to make it a choice at authorization time. This allows me to choose when I want to issue these persistent tokens, and has a user-friendly warning to let the user know it's not necessarily something they want to do:

![A screenshot of the consent screen on Jamie's IndieAuth server, which has a checkbox option for allowing persistent access, with a description of what it means in less technical terms](https://media.jvt.me/6d74dfa948.png)

When the authorization code exchange occurs, a client will receive the following response from the token endpoint, containing a `refresh_token` as well as an `access_token`:

```json
{
  "access_token": "...",
  "expires_in": 2592000,
  "me": "https://www.staging.jvt.me",
  "refresh_token": "...",
  "scope": "create delete media undelete update",
  "token_type": "Bearer"
}
```

For clients who are able to handle refresh tokens, they can send the following request to the token endpoint:

```
curl -i /token \
  -d grant_type=refresh_token \
  -d refresh_token=eyJ... \
  -d client_id=https://client_id
```

And then will receive a fresh `access_token` and `refresh_token`.

Note that until I've implemented token revocation, the old refresh token will still be valid, but the idea is that old refresh tokens will be revoked, so they will be single-use, as per Public Client best practices.

This also means that, currently, if a client has a refresh token, as long as that refresh token never expires, they will be able to continue to refresh their access forever.

Something I took care to implement, as I've seen it as a gotcha before, is to make sure my access tokens cannot be used as a refresh token!
