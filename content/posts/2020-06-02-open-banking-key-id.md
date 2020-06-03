---
title: "How are Open Banking Key Ids (`kid`) Generated?"
description: "Sharing insight into how Open Banking has generated their `kid`s for use with JWTs."
tags:
- blogumentation
- open-banking
- psd2
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-02T13:28:05+0100
slug: "open-banking-key-id"
---
Something that I've spent a while Googling over the last couple of years of working on PSD2 is "How are Open Banking Key Ids (`kid`) Generated?"

I say this because it's not super clear how they're generated, and searching Open Banking's documentation hasn't been super easy.

In the spirit of [Blogumentation]({{< ref 2017-06-25-blogumentation >}}), I want to leave the world a better place and make it easier for others to Google for the answer themselves.

As of writing, we are using v2 of the Open Banking Directory, which is [documented on Open Banking's Confluence space](https://openbanking.atlassian.net/wiki/spaces/DZ/pages/1150124033/Directory+2.0+Technical+Overview+v1.3). We see that there is a JWK Structure section, which notes that the `kid` is `The SHA-1 hash of the JWK Fingerprint`.

This JWK fingerprint is defined in [RFC7638: JSON Web Key (JWK) Thumbprint](https://tools.ietf.org/html/rfc7638), and as it is a well-defined standard, you should be able to find library support for it, [such as Nimbus for Java](https://connect2id.com/products/nimbus-jose-jwt/examples/jwk-thumbprints), [using node-jose on Node projects]({{< ref 2020-06-02-jwk-thumprint-node >}}) or [json-jwt with Ruby]({{< ref 2020-06-03-jwk-thumbprint-ruby >}}).
