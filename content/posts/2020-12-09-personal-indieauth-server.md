---
title: "Creating a Personal IndieAuth Server"
description: "Announcing the release of my personal IndieAuth server, and what I've spent my time on."
tags:
- www.jvt.me
- indieauth.jvt.me
- indieauth
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-12-09T11:49:48+0000
slug: "personal-indieauth-server"
syndication:
- https://news.indieweb.org/en
- https://indieweb.xyz/en/indieweb
- https://lobste.rs/s/urv2yf/creating_personal_indieauth_server
- https://news.ycombinator.com/item?id=25357812
image: https://media.jvt.me/f34f45fbf0.png
---
I've completed my implementation of an [IndieAuth v1.1 server](https://indieauth.spec.indieweb.org/), which has been a goal of mine for some time.

IndieAuth is a great standard for being "OAuth for the Open Web", and within the IndieWeb community, it's seeing some great investment and diversity in use cases. When I was first looking at getting involved in the IndieWeb, I thought that this would be my first project, but instead I ended up going the route of [creating a Micropub server]({{< ref 2019-08-26-setting-up-micropub >}}) and [sending Webmentions]({{< ref 2019-09-10-webmentions-on-deploy >}}).

However, over time, I've found that I am starting to outgrow IndieAuth.com as my hosted server, as there are a few extensions I want to provide that only make sense for me, and it gives me yet another project to spend my time building instead of doing the important things in life!

As part of creating my server, I wanted to design it with extensibility in mind, i.e. to allow for `refresh_token` grants, or to allow for different means of authentication.

I also wanted to make it compliant with the latest version of the IndieAuth specification, as well as take advantage of a few draft RFCs that have been floating around, as an opportunity to see how they feel to work with.

# Authentication via Push Notification

As mentioned in [_Setting up Passwordless Authentication using the Okta Factors API_]({{< ref 2020-11-10-okta-factors-api-passwordless >}}), one of the key reasons of building my own IndieAuth server is to tailor my authentication flow to me. This is primarily to make testing with my staging Micropub server easier, but is also so I can authenticate on a device without needing access to i.e. silo accounts for social login, or to go through an email OTP, which is slower.

I've followed my article and now get a push notification and can allow/deny it, which simplifies things massively! I don't yet have an alternative for when I'm not on my device, however, so there is a single point of failure here, but so far it's made a huge difference.

# Consent Screen

Something I took a bit of time to think about (and have [follow-up work on](https://gitlab.com/jamietanna/www-api/-/issues/295)) is making the consent screen provide me all the information required to provide informed consent.

I've followed examples from <span class="h-card"><a class="u-url p-name" href="https://aaronparecki.com">Aaron</a></span> and <span class="h-card"><a class="u-url p-name" href="https://vanderven.se/martijn/">Martijn</a></span> as documented [on the IndieWeb Wiki](https://indieweb.org/consent_screen) and have ended up with the following initial version:

![A screenshot of Jamie's consent screen, listing the client's URL, a text box allowing Jamie to specify the profile URL for the user, a bold warning showing that Proof of Key Code Exchange isn't in use, and a list of scopes and what they mean, presented as a tickbox. There is also a button to authenticate via push notification, or to deny the request](https://media.jvt.me/f34f45fbf0.png)

I've shamelessly adapted Aaron's PKCE-specific warning, but have reversed it, warning the user that they're using a less secure version of the request. In the future, I plan to [require PKCE for all clients](https://gitlab.com/jamietanna/www-api/-/issues/298) but with the ability to have an allowlist of clients that haven't yet updated.

# Pushed Authorization Requests (PAR)

The first thing is that I've experimented with [OAuth 2.0 Pushed Authorization Requests](https://tools.ietf.org/html/draft-ietf-oauth-par-04) which [is a proposed IndieAuth extension](https://github.com/indieweb/indieauth/issues/40).

I wanted to play with the ability to pre-authorize requests, for instance rejecting it when there are missing parameters, as well as allowing me to remove the ability to change the URL on the consent page to tweak what the request is for.

But as current clients do not (yet) support this still-draft RFC and proposed IndieAuth extension, I had to rethink this. I implemented this by taking requests to my authorization endpoint, and pre-authorizing them based on the `response_type`, and if it succeeded, I would create a pushed request, and redirect to my consent page. For instance:

```
curl -i 'https://indieauth.jvt.me/authorize?redirect_uri=http://localhost%3A8080
  &client_id=https%3A%2F%2Fwww-editor.jvt.me
  &state=state
  &scope=create+update+delete+undelete+media
  &response_type=code
  &me=https://www.jvt.me'

HTTP/1.1 302 Found
Date: Wed, 09 Dec 2020 09:49:12 GMT
Location: https://indieauth.jvt.me/authorize/consent?client_id=https%3A%2F%2Fwww-editor.jvt.me
  &request_uri=urn:ietf:params:oauth:request_uri:MAuFHnwKR9
```

# JSON Web Token (JWT) Profile for OAuth 2.0 Access Tokens

For my access tokens, I wanted them to be JSON Web Tokens (JWTs), as they're a format I work with quite a lot, and know that I've got a good choice of libraries, and practice implementing with.

Additionally, I wanted these to be asymmetrically signed, as then it would allow services consuming my IndieAuth server to perform validation of the signature based on a public key, rather than requiring introspection of the access token each time, which simplifies and speeds up the interactions with resource servers (although does have trade-offs once my server can support revocation).

I've followed [draft-ietf-oauth-access-token-jwt-10](https://tools.ietf.org/html/draft-ietf-oauth-access-token-jwt-10) for this, as a way to make sure that I'm aligning with some of the best practices folks are using, and that hopefully will be turning into a standard RFC before long.

An example of the structure of the token:

```json
{
  "typ": "at+jwt",
  "alg": "RS256"
}
{
  "aud": "https://www-api.jvt.me/",
  "sub": "https://www.jvt.me",
  "auth_time": 1607375072,
  "scope": "update",
  "iss": "https://indieauth.jvt.me",
  "exp": 1609967072,
  "iat": 1607375072,
  "client_id": "https://www-api.jvt.me/post-deploy"
}
```

These also include an expiry on tokens, to enforce regular re-authentication. In the future, I will look at providing `refresh_token`s to allow for longer-lived tokens to apps that require it (such as applications I've written, or other apps that may be adding support in the future for `refresh_token`s).

For this initial implementation, I've not set up JWKS-based validation, but there is the ability after this initial release.

# RFC7662 Token Introspection Endpoint

As mentioned in [this GitHub issue on the IndieAuth spec](https://github.com/indieweb/indieauth/issues/33), I want to try and align my token endpoint with existing OAuth2 requirements, to simplify integrations with OAuth2 libraries.

That being said, as <span class="h-card"><a class="u-url p-name" href="https://vanderven.se/martijn/">Martijn</a></span> mentions on GitHub, this wouldn't be able to work as-is anyway, as IndieAuth does not provide a token introspection endpoint aligned with [RFC7662: OAuth 2.0 Token Introspection](https://tools.ietf.org/html/rfc7662) so adding the `"active": false` is unnecessary.

As part of implementing my IndieAuth server, I've implemented RFC7662 to allow me to modify my resource servers to use the introspect endpoint, which means I can use out-of-the-box OAuth2 libraries.

I've also added `"active: true` / `"active": false` to the response of the IndieAuth token endpoint, too, to align with OAuth2.

# Code

If you're interested in looking at the code, you can check out [the GitLab merge request which introduced it](https://gitlab.com/jamietanna/www-api/-/merge_requests/210) or [the source in <i class="fa fa-gitlab"></i> the repo](https://gitlab.com/jamietanna/www-api/-/tree/develop/www-api-web/indieauth).

(Note that at the time of writing, there are a couple of outstanding items, but once that's done, it'll be merged and ready!)

# Future Improvements

I've already got quite a few things planned for this server, and have [raised issues on my repo to track them](https://gitlab.com/jamietanna/www-api/-/issues?scope=all&utf8=%E2%9C%93&state=opened&label_name[]=project%3Aindieauth). Is there anything you recommend me looking into? Get in touch or raise one yourself!

# Feedback to give

Something we've spoken about before is that it'd be great to have a test suite for IndieAuth on [indieauth.rocks](https://indieauth.rocks/) similar to [micropub.rocks](https://micropub.rocks/) as a way to validate that the implementation is correct - there are several edge cases, and a lot of requirements, and it'd certainly help with new features as well as preventing regressions.

I will say I'm glad that I've started implementing it after [the recent changes to the spec](https://aaronparecki.com/2020/12/03/1/indieauth-2020), especially as I'd been around for some of the conversations so was more comfortable with what was coming up.
