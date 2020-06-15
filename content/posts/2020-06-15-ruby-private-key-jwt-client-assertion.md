---
title: "Generating the Client Assertion JWT for `private_key_jwt` Authentication with Ruby"
description: "A helper script to generate the client assertion required to authenticate to an Authorization Server that supports `private_key_jwt`, on the command-line with Ruby."
tags:
- blogumentation
- ruby
- command-line
- jwt
- json
- oidc
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-15T23:12:26+0100
slug: "ruby-private-key-jwt-client-assertion"
---
OpenID Connect Core 1.0 defines the [`private_key_jwt` authentication method](https://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication) that can be used to authenticate the client with an Authorization Server's token endpoint.

This is a much better method to authenticate a client compared to a shared secret such as a `client_secret`, as it reduces risk of a credential being leaked on either side of the connection, as well as making rotation of those credentials easier - as only one party needs to be involved.

But it can be a pain to generate these for testing, as the client assertion that needs to be signed has a specific format.

I've come up with the following script, which can be run as follows:

```sh
ruby pkj.rb client_id https://authorization.server:443/path /path/to/signing.pem
ruby pkj.rb client_id https://authorization.server:443/path /path/to/signing.pem 1800 # for an optional expiration limit
```

This builds upon the [json-jwt signing implementation from _Creating Signed JWTs (JWS) with Ruby_]({{< ref 2020-06-15-sign-jwt-ruby >}}#with-ruby-jwt):

```ruby
require 'jwt'
require 'securerandom'

client_id = ARGV[0]
aud = ARGV[1]
signing_key = OpenSSL::PKey.read(File.read ARGV[2])
token_lifetime = ARGV[3] || 1800

iat = Time.now.to_i

payload = {
  iss: client_id,
  sub: client_id,
  aud: aud,
  iat: iat,
  exp: iat + token_lifetime,
}

puts JWT.encode payload, signing_key, 'RS256'
```
