---
title: "JWKS-iCal Release v1.2.0: Determine the `jwks_uri` from Configuration"
description: "Updating jwks-ical to add support for discovering `jwks_uri` endpoints automagically."
tags:
- jwks
- certificates
- jwks-ical
- calendar
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-08-16T20:59:59+0100
slug: "jwks-ical-configuration-integration"
---
When I first announced the release of [jwks-ical, a solution for _Keeping Track of Certificate Expiry with a JWKS to iCalendar Converter_](/posts/2020/06/14/track-certificate-expiry-jwks-ical/), it was only possible provide the full `jwks_uri`.

However, it may be better to auto-detect the configuration from the authorization server.

With this release, now live, you can use a couple of new options.

We can now point the function to the [OpenID Connect Discovery](https://openid.net/specs/openid-connect-discovery-1_0.html) or the [OAuth 2.0 Authorization Server Metadata](https://tools.ietf.org/html/rfc8414) endpoint:

```
https://europe-west1-jwksical-jvt-me.cloudfunctions.net/jwks-ical
  ?configuration_endpoint=https://jamietanna.eu.auth0.com/.well-known/openid-configuration
```

Alternatively, you can provide the top-level URI for the issuer of the service, at which point we'll attempt to discover the configuration via [OpenID Connect Discovery](https://openid.net/specs/openid-connect-discovery-1_0.html):

```
https://europe-west1-jwksical-jvt-me.cloudfunctions.net/jwks-ical
  ?issuer=https://jamietanna.eu.auth0.com
```
