---
title: "Generating a JSON Web Key (JWK) With Ruby"
description: "How to create a new JWK with Ruby."
tags:
- blogumentation
- pki
- ruby
- pem
- jwks
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-12-12T16:23:18+0000
slug: "generate-jwk-ruby"
---
Sometimes you need to generate a new JWK, and [converting an existing key](/posts/2020/12/12/x509-pkcs8-pem-key-to-jwks-ruby/) isn't quite what you want.

We can use the [ruby-jose](https://github.com/potatosalad/ruby-jose) library to do this via its handy `generate_key` method, which provides us a JWKS when invoking the script:

```ruby
require 'jose'
jwk = JOSE::JWS.generate_key({"alg" => "RS256"})
jwk_s = JSON.parse(jwk.to_binary)
puts JSON.pretty_generate(keys: jwk_s)
```
