---
title: "Creating Signed JOSE Objects with Ruby"
description: "How to use `ruby-jose` to create a signed JSON Object Signing and Encryption (JOSE) object on the command-line."
tags:
- blogumentation
- ruby
- command-line
- jwt
- jose
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-09-02T15:21:01+0100
slug: "sign-jose-ruby"
image: https://media.jvt.me/00fdea0d32.png
---
I've written before about how to [create a Signed JWT with Ruby](/posts/2020/06/15/sign-jwt-ruby/).

But sometimes you don't want a [JSON Web Token (JWT)](https://tools.ietf.org/html/rfc7519). You actually just want to create a [JSON Object Signing and Encryption (JOSE)](https://www.rfc-editor.org/rfc/rfc7520.html) object. This could be that you want to try and create JWT-like formats, but with invalid fields, or you just want to sign arbitrary objects.

We'll create a new command-line tool which allows a file of content to be signed:

```
ruby sign.rb content.txt 'hmac-key-here'
ruby sign.rb payload.json 'hmac-key-here'
ruby sign.rb payload.json 'hmac-key-here' 'HS256'
ruby sign.rb payload.json '/path/to/key.pem' 'RS256'
ruby sign.rb payload.json '/path/to/key.pem' 'ES256'
```

We can utilise the great [ruby-jose](https://github.com/potatosalad/ruby-jose) library to sign an arbitrary payload of data to provide the following script:

```ruby
require 'jose'

def read_key(maybe_secret)
  if File.exists? maybe_secret
    JOSE::JWK.from_pem_file maybe_secret
  else
    JOSE::JWK.from_oct maybe_secret
  end
end

payload = File.read ARGV[0]
jwk = read_key(ARGV[1])
algorithm = ARGV[2] || 'HS256'

options = {
  'alg' => algorithm,
}

puts jwk.sign(payload, options).compact
```
