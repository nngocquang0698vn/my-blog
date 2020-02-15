---
title: "Setting up Multiple `redirect_uri`s on the Meetup.com API"
description: "How to allow multiple `redirect_uri`s on your Meetup.com (OAuth2) API consumer."
tags:
- blogumentation
- oauth2
- meetup.com
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-02-15T13:01:15+0000
slug: "meetup-api-multiple-redirect-uris"
---
Since roughly September, I've been on-and-off working on [contributing a feature request](https://github.com/snarfed/bridgy/issues/873) to allow [Bridgy](https://brid.gy) to send RSVPs events from my personal website straight to Meetup.com.

In the last couple of weeks I've got to the final hurdle - getting this to work with Bridgy's core application, which performs a few OAuth2 code flows - authorizing "listen" functionality (which is not implemented), authorizing "publish" functionality (which I've added) and authorizing to disable publishing.

When asking Bridgy's author, <span class="h-card"><a class="u-url p-name" href="https://snarfed.org">Ryan Barrett</a></span>, about this, he mentioned that it was to stop anyone from going to your profile on Bridgy and disabling it - you needed to prove you owned the account before you made changes to it.

To make this these flows easier, Ryan has set up a number of pre-built handlers for these flows, each of which are on different endpoints.

However, the Meetup.com API does _not_ allow for multiple `redirect_uri`s, which has made this process much more complicated than it needed to be, and has been quite a painful learning experience.

Getting quite annoyed with the complexity overhead of this approach, I set about trying my DuckDuckGo-fu and seeing if I could find anything online, but to no avail.

So I then thought I'd look at whether I could modify the `redirect_uri` to add other URIs, on the off chance it worked.

Trying with a comma didn't seem to work, but I noticed that when I removed a portion of the path, it still seemed to work. This means that with the pre-registered `redirect_uri=http://localhost:8080/meetup/`, I can use any of the following in OAuth2 code flows:

```
http://localhost:8080/meetup/
http://localhost:8080/meetup/add
http://localhost:8080/meetup/publish/finish
```

I was surprised this would work, as in the past I've seen OAuth2 Authorization Servers be very strict on the validation of a `redirect_uri`.

However, if we look at [RFC 6749: The OAuth 2.0 Authorization Framework: Section 3.1.2.2.](https://tools.ietf.org/html/rfc6749#section-3.1.2.2), we can see that it is permitted as per the spec:

```
The authorization server SHOULD require the client to provide the
complete redirection URI (the client MAY use the "state" request
parameter to achieve per-request customization).  If requiring the
registration of the complete redirection URI is not possible, the
authorization server SHOULD require the registration of the URI
scheme, authority, and path (allowing the client to dynamically vary
only the query component of the redirection URI when requesting
authorization).
```

Hopefully this helps those of you still creating Meetup.com APIs, but I do wish that the API documentation would make it known that it's possible!
