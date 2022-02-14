---
title: "Verifying Signed JWTs (JWS) with Ruby"
description: "Using the ruby-jwt library to verify a signed JSON Web Token (JWS) on the command-line."
tags:
- blogumentation
- ruby
- command-line
- jwt
- json
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-15T22:59:37+0100
slug: "verify-jwt-ruby"
image: https://media.jvt.me/00fdea0d32.png
---
When you're working with JSON Web Tokens (JWTs), you'll _almost certainly_ be validating that the contents of the token is sent by the correct service by verifying the token's signature.

However if these are, for instance, access tokens, you **should not** be putting them into an online tool like [JWT.io] as you pose a risk of information leakage, as well as potentially compromising accounts!

Even though the website says it should be done client-side, it's still a bad practice to randomly copy-paste potentially dangerous data around.

So how do you easily validate the signature, without it touching an easy-to-use service? Below you can find a simple code snippet to do the work for you using Ruby's ruby-jwt library.

For this example, the expectation is that you can run them as the following, where the process will return successfully (with exit status 0) or unsuccessfully (with exit status 1) based on whether the JWT was successfully verified:

```sh
ruby verify.rb payload.jwt 'hmac-key-here'
ruby verify.rb payload.jwt 'hmac-key-here' 'HS256'
ruby verify.rb payload.jwt '/path/to/key.pem' 'RS256'
ruby verify.rb payload.jwt '/path/to/key.pem' 'ES256'
ruby verify.rb payload.jwt 'https://url/of/jwks_uri' 'RS256'
```

# With ruby-jwt

Using [ruby-jwt](https://github.com/jwt/ruby-jwt), we have the following code:

```ruby
#!/usr/bin/env ruby
require 'jwt'
require 'net/http'

def parse_jwks(jwks_uri)
  res = Net::HTTP.get_response(URI(jwks_uri))
  JSON.parse(res.body, symbolize_names: true) # jwt expects symbols for all Hash keys
end

jwt = File.read ARGV[0]
maybe_secret_or_jwks = ARGV[1]
algorithm = ARGV[2] || 'HS256'

opts = {
  algorithm: algorithm,
}

if maybe_secret_or_jwks.start_with? 'http'
  jwk_loader = ->(options) do
    @cached_keys = nil if options[:invalidate] # need to reload the keys
    @cached_keys ||= { keys: parse_jwks(maybe_secret_or_jwks)[:keys] }
  end

  opts[:jwks] = jwk_loader
else
  maybe_secret = maybe_secret_or_jwks

  if File.exists? maybe_secret
    maybe_secret = OpenSSL::PKey.read(File.read maybe_secret)
  end
end

begin
  JWT.decode jwt, maybe_secret, true, opts
rescue JWT::VerificationError
  exit 1
end
```
