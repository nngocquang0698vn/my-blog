---
title: "Why You Should Avoid using Client Secret Authentication for OAuth2 Client Credentials"
description: "Why I recommend against using client secret authentication for OAuth2 and OpenID Connect APIs."
date: 2021-11-09T11:45:01+0000
tags:
- oauth
- oauth2
- oidc
- security
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "avoid-client-secret"
image: https://media.jvt.me/5732857c13.png
---
If you're authenticating to an API using OAuth2 with a set of client credentials, you're _almost certainly_ using a method that uses the client secret, which are commonly referred to as `client_secret_basic` or `client_secret_post`.

Client secret usage is widespread because they're straightforward to implement as both an OAuth2 client, due to an abundance of library support, as well as on the server-side. They're pretty well understood, and the ability to use HTTP Basic authentication makes it a good option for an alternative to API key authentication.

However, I've been working with quite a few services deployed like this over the last few years, and I've found it's not ideal for the client credentials grant a few reasons.

# Why shouldn't we use client secrets?

## Reduced chance of leaking credentials

Having two parties knowing a shared secret is risky. Because the client secret may be sent on every request that uses HTTP Basic authentication, or in a POST request to the token endpoint, there are lots of opportunities for that to be (accidentally) leaked.

As the client secret is all that's required to authenticate as that client, if an attacker were to get access to it, they can masquerade as that client to their heart's content.

With the client secret being transmitted over various layers of networking infrastructure, there is a non-zero risk that the secret could be leaked. Trust me, it is _surprisingly easy_ to misconfigure things!

And then, because the process for rotating/generating a fresh secret may not be well-practiced, it can mean that compromised credentials are valid longer than they need to be.

## Rotation is hard

For good security hygiene, we should be regularly rotating secrets to make sure that any compromised credentials are short lived, as well as being more practiced about how to rotate them in the case of either an emergency, or general rotation timelines.

Rotating a client secret on the server-side would be somewhat straightforward, as you issue a second client secret, and for a small period of time you'd allow both client secrets to be usable. On the client, you'd then update your secret storage to use the new secret, and boom, all sorted.

So why is this section talking about rotation being hard?

A number of Authorization Servers don't implement _rotation_, but instead allow you to generate a new client secret. This means that each time you want to perform the rotation it's a downtime-inducing change for the duration that the old client secret is still being used, and you'll need to think carefully about when you actually do this.

I've tested against the [MitreID Connect OpenID Connect reference implementation](https://github.com/mitreid-connect/OpenID-Connect-Java-Spring-Server/tree/7eba3c12fed82388f917e8dd9b73e86e3a311e4c), the [Open Identity Platform community fork of OpenAM](https://www.openidentityplatform.org/openam), and Okta, and all three of these big providers just generate a new secret. I don't doubt that a lot of the other big names in identity do the same, I've just not tested them.

Depending on how the configuration is managed, this could require codependent releases of applications, and can add on a lot of overhead, which then balloons in complexity if you've got a tonne of clients that need to perform this.

## How do clients update?

Now, let's assume that your authorization server does have the ability to rotate secrets, instead of generating fresh ones. The question is how are we going to go through the process for rotation?

Firstly there's the option above where the authorization server is on the hook to tell you what the new secret is, so needs to issue a new secret, and let you know (hopefully securely!) so you can update it your side.

Alternatively, the client themselves are in charge of it, in which case they need to be able to update it with the authorization server.

If the client was [dynamically registered](https://datatracker.ietf.org/doc/html/rfc7591) they should have the ability to use their `registration_access_token` to update their `client_secret`.

Alternatively, it may be presented in a web UI with the Authorization Server, or there may be some non-standard means to update it.

The latter is better in my opinion, as it means that the client themselves are fully owning the process, and if they forget to do it in time, it's their fault, instead of putting the onus on the Authorization Sever to do it.

# So what do we use instead?

## Issue access tokens instead of using HTTP Basic authentication for APIs

If you're using HTTP Basic authentication to protect resources on your APIs, I'd recommend swapping it out for an access token.

This means that instead of calling an API like so, with your client credentials:

```
GET /statements
Authorization: Basic ...
```

You replace it with a call to the token endpoint to get, and cache, a short-lived access token:

```
POST /oauth/token
Authorization: Basic ...

# retrieve the $.access_token, and use it in subsequent calls

GET /statements
Authorization: Bearer ...
```

This reduces the amount of chances that the secret could be leaked, as now only the token endpoint is called with the client secret.

You still have rotation as a problem, though.

## Private Key JWT

While working on the Open Banking platform at Capital One, I was exposed to [`private_key_jwt` authentication method](https://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication) which was introduced in OpenID Connect Core 1.0, and became a requirement for Open Banking APIs under the Financial Grade API (FAPI).

A lot of OAuth2 servers, and an increasing list of clients, support this, but it's not as widely used as I'd say it should be.

The private key JWT authentication mechanism changes a token endpoint from i.e. `client_secret_post`:

```
POST /token HTTP/1.1
Host: server.example.com
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials&
  client_id=s6BhdRkqt3&
  client_secret=abc...def
```

To one with a more complex looking request:

```
POST /token HTTP/1.1
Host: server.example.com
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials&
  client_id=s6BhdRkqt3&
  client_assertion_type=
  urn%3Aietf%3Aparams%3Aoauth%3Aclient-assertion-type%3Ajwt-bearer&
  client_assertion=eyJ...
```

As the name suggests, there's a JSON Web Token (JWT) in there, which can be generated as noted in [Generating the Client Assertion JWT for `private_key_jwt` Authentication with Ruby](/posts/2020/06/15/ruby-private-key-jwt-client-assertion/):

```json
{
  "iss": "client_id_here",
  "sub": "s6BhdRkqt3",
  "aud": "https://server.example.com",
  "jti": "bdc-Xs_sf-3YMo4FSzIJ2Q",
  "iat": 1537819486,
  "exp": 1537819777
}
```

This method is great because it means that the proof of the client's identity is done using asymmetric signatures, instead of using a symmetric key.

The client assertion is a signed JWT, which allows the client to sign it with a private key that the Authorization Server can verify with the corresponding public key.

Because the `client_assertion` must have its expiry (`exp`) validated by the Authorization Server, we can make these short-lived (60 seconds has been a sufficient amount, from experience) so even if they were intercepted, they only provide limited use.

The JWT ID (`jti`) in the assertion is a protection for replay attacks, ensuring that the Authorization Server doesn't allow re-using the client assertion i.e. in the case that it were to be intercepted. I've seen a number of Authorization Servers not check `jti` though, so would recommend both low window for usage, and using JWT IDs!

This is a much safer experience than the client secret, and because it's following the process of signing JWTs, there's some great library support.

Rotation of keys is much easier, because it's up to the client to publish the new keys, allow some time for the Authorization Server to have retrieved them, and then start using it.

### Overheads

To make this a balanced view, it's only fair I discuss some of the drawbacks.

Because this works on asymmetric signatures, there's the need for the Authorization Sever to know where the keys are for the client. This worked really well with Open Banking, where we had a set of certificates that were managed by clients, and there was a public-facing JWKS URI that keys could be retrieved from.

If your client is only internal facing, you'll either be able to manage this if you're [dynamically registered](https://datatracker.ietf.org/doc/html/rfc7591), or have some out-of-band way of updating the JWK that's stored, which isn't ideal.

Additionally, if we're not already managing JWK(s), we'll need to do so, which depending on how your organisation works, may require certificates.

Depending on your secret storage methods, you'll need to work out a means for updating the existing JWK(s) to add/remove keys, which could be additional complexity.

There's a bit more that needs to be done to actually make this work, but as mentioned, we've got libraries adding better support.

JWTs can unfortunately still be difficult to get right - there's a few things I've got [tagged under JWT](/tags/jwt/) that may be worth a read.

# Conclusion

Thought I'd give a shout out to `client_secret_jwt`, another addition in OpenID Connect Core 1.0, which still requires a client secret, but authentication is done with symmetric signing with that, instead of an asymmetric key owned by the client. It still has the drawbacks of rotation, but reduces the risk of always sharing the client secret in requests.

Hopefully you'll agree that the benefits of `private_key_jwt` outweigh the drawbacks, and you'll give it a go with your next OAuth2 client!
