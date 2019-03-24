---
title: Pretty Printing JSON Web Tokens (JWTs) on the Command Line using Ruby
description: How to easily introspect and pretty print a JWT on the command line using Ruby's standard library, or using the ruby-jwt external library.
categories:
- blogumentation
tags:
- blogumentation
- ruby
- cli
- jwt
- json
image: /img/vendor/jwt.io.jpg
date: 2018-08-31T00:00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: pretty-printing-jwt-ruby
---
Let's say you're starting to work with JWTs, and to confirm that their payload is correct, you want to introspect their contents. However, you may be aware that JWTs can contain sensitive information such as the hostname of a server, personally identifiable information, or could be used as a bearer token to access a service, so you shouldn't really be introspecting it in some public space such as [JWT.io].

This has put you in a difficult position, but no more - decoding a JWT is really easy, and in this example I'll show you how to do it using Ruby.

Let us use the following JWT in `example.jwt`, via JWT.io:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

We don't care about looking at the signature, only the header and payload.

As per [Pretty Printing JSON with Ruby on the CLI], we can take the core of the commandline to perform the pretty printing of `ARGF`, but have two choices as to how to proceed:

# Using Ruby's Standard Library

For a purely dependency-less method to decode our JWT, we can use Ruby's built in libraries to decode and pretty-print the result. Because JWTs are Base64 and URL encoded, we need to correctly decode the JWT fields.

The more readable version of the code looks like:

```ruby
require 'base64'
require 'json'

jwt = ARGF.read
jwt.split('.')[0,2].each do |f|
  # Base64 + URL decode it
  decoded = Base64.urlsafe_decode64(f)
  # read the resulting string as a Ruby hash
  json = JSON.parse(decoded)
  # output a pretty-printed JSON object
  puts JSON.pretty_generate(json)
end
```

Which we can turn into a barely-readable oneliner:

```bash
ruby -rjson -rbase64 -e "ARGF.read.split('.')[0,2].each { |f| puts JSON.pretty_generate(JSON.parse(Base64.urlsafe_decode64(f))) }" example.jwt
```

You can see the asciicast in action:

<asciinema-player src="/casts/pretty-printing-jwt-ruby-stdlib.json"></asciinema-player>

# Using `ruby-jwt` library

If you're willing to pull in some external dependencies, or have them already got them installed i.e. in the ChefDK, you can update your script to use the `ruby-jwt` library:

```ruby
require 'json'
require 'jwt'

jwt = ARGF.read
# decode the JWT without verifying signature
decoded_jwt = JWT.decode(jwt, nil, false)
# reverse as the header is in location [1]
decoded_jwt.reverse.each do |json|
  # output a pretty-printed JSON object
  puts JSON.pretty_generate(json)
end
```

This can be converted to another nasty one-liner:

```bash
ruby -rjson -rjwt -e "JWT.decode(ARGF.read, nil, false).reverse.each { |j| puts JSON.pretty_generate j }" example.jwt
```

You can see the asciicast in action:

<asciinema-player src="/casts/pretty-printing-jwt-ruby-rubyjwt-library.json"></asciinema-player>

[JWT.io]: https://jwt.io
[Pretty Printing JSON with Ruby on the CLI]: {{< ref 2017-06-05-pretty-printing-json-cli >}}
