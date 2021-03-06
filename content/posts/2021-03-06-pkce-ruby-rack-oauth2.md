---
title: "Using Proof of Key Code Exchange (PKCE) Using rack-oauth2 as an OAuth2 Client"
description: "How to use the PKCE extension when using the Ruby library rack-oauth2 as an OAuth2 client."
tags:
- blogumentation
- ruby
- rack
- oauth2
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-03-06T13:41:08+0000
slug: "pkce-ruby-rack-oauth2"
---
[Proof of Key Code Exchange](https://oauth.net/2/pkce/) is an OAuth2 extension that recently been adopted as the standard for both [OAuth 2.1](https://oauth.net/2.1/) and [IndieAuth](https://indieauth.spec.indieweb.org), and provides additional security for attacks on the Authorization Code flow.

As it's still not hugely widespread, there's a gap in a lot of OAuth2 libraries for support.

I use the [rack-oauth2 Gem](https://github.com/nov/rack-oauth2) as my OAuth2 client where possible, which also appears to have a gap in its out-of-the-box support for PKCE, but following [nov's Gist](https://gist.github.com/nov/98d26044e2f7c5b7d8fdba2b9bd101b4), we are able to add support:

```ruby
require 'base64'
require 'openssl'
require 'rack/oauth2'
require 'securerandom'

def code_challenge(code_verifier)
  Base64.urlsafe_encode64(
    OpenSSL::Digest::SHA256.digest(code_verifier)
  ).gsub(/=/, '')
end

client = get_client  'https://token'
  Rack::OAuth2::Client.new(
    identifier: '...',
    redirect_uri: '...',
    host: '...',
    authorization_endpoint: 'https;//authz',,
    token_endpoint: token_endpoint,
  )

state = SecureRandom.hex(32)
code_verifier = SecureRandom.hex(32)
nonce = SecureRandom.hex(16)

authorization_uri = client.authorization_uri(
  scope: %w(draft),
  state: state,
  nonce: nonce,
  code_challenge: code_challenge(code_verifier),
  code_challenge_method: :S256,
)
# go through the flow

client.authorization_code = '...' # provide this here
access_token = client.access_token! :body,
             code_verifier: code_verifier
# success!
```
