---
title: "Decrypting Encrypted JSON Web Tokens (JWE) with Ruby"
description: "How to use Ruby to decrypt encrypted JSON Web Token objects."
tags:
- blogumentation
- ruby
- jwt
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-06-22T22:18:49+0100
slug: "jwe-decrypt-ruby"
---
There are a number of great standards for encrypting data, and one I interact with quite a lot is JSON Web Encryption.

As mentioned in [_Why I Actively Discourage Online Tooling like `jwt.io` and Online JSON Validators_](/posts/2020/09/01/against-online-tooling/), I like having the option to use offline tools (which I can audit more easily) for common tasks.

Fortunately, [the `jose` gem](https://github.com/potatosalad/ruby-jose) allows us to do this pretty nicely, and it has some really useful utilities for parsing different key formats.

We can create the following script:

```ruby
require 'jose'

# if using a PEM file
key = JOSE::JWK.from_pem ARGV[0]
# if using a JWK
key = JOSE::JWK.from_map JSON.parse(File.read ARGV[0])
token = File.read ARGV[1]

puts JOSE::JWE.block_decrypt(key, token).first
```

This allows us to execute it as such:

```sh
# i.e. if using PEMs
$ ruby decrypt.rb key.pem jwe.txt
The true sign of intelligence is not knowledge but imagination.
```
