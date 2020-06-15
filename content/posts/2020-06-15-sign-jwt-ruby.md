---
title: "Creating Signed JWTs (JWS) with Ruby"
description: "Using the json-jwt and ruby-jwt libraries to sign a JSON Web Token on the command-line."
tags:
- blogumentation
- ruby
- command-line
- jwt
- json
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-15T22:40:57+0100
slug: "sign-jwt-ruby"
---
When you're working with JSON Web Tokens (JWTs), you'll _almost certainly_ be validating that the contents of the token is sent by the correct service by verifying the token's signature.

However, it's also helpful to be able to create these signed JWTs for yourself, which we can do with either of the two popular JWT libraries in Ruby.

With both of these approaches, the expectation is that you can run them as the following:

```sh
ruby sign.rb payload.json 'hmac-key-here'
ruby sign.rb payload.json 'hmac-key-here' 'HS256'
ruby sign.rb payload.json '/path/to/key.pem' 'RS256'
ruby sign.rb payload.json '/path/to/key.pem' 'ES256'
```

# With JSON::JWT

Using [JSON::JWT](https://github.com/nov/json-jwt), we can use the following:

```ruby
require 'json/jwt'

payload = JSON.parse(File.read ARGV[0])
maybe_secret = ARGV[1]
algorithm = ARGV[2] || 'HS256'

if File.exists? maybe_secret
  maybe_secret = OpenSSL::PKey.read(File.read maybe_secret)
end

puts JSON::JWT.new(payload).sign(maybe_secret, algorithm.to_sym)
```

# With ruby-jwt

Using [ruby-jwt](https://github.com/jwt/ruby-jwt), we have the following code:

```ruby
require 'jwt'

payload = JSON.parse(File.read ARGV[0])
maybe_secret = ARGV[1]
algorithm = ARGV[2] || 'HS256'

if File.exists? maybe_secret
  maybe_secret = OpenSSL::PKey.read(File.read maybe_secret)
end

puts JWT.encode payload, maybe_secret, algorithm
```
