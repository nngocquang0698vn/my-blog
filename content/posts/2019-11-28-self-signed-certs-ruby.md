---
title: Trusting Self-Signed Certificates from Ruby
description: 'How to configure Ruby to trust self-signed certificates.'
tags:
- blogumentation
- ruby
- certificates
- nablopomo
date: 2019-11-28T21:05:55+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: self-signed-certs-ruby
series: nablopomo-2019
---
I use Ruby as my primary general-purpose scripting language, and prefer to use it to automate repetitive / awkward tasks.

But working in a corporate environment, I don't always have the right certs trusted by my Operating System.

Let's say that we have the following code to reach out to an endpoint that knowingly uses a self-signed certificate:

```ruby
uri = URI.parse('https://keystore.openbanking.org.uk/001580000103UAQAA2/001580000103UAQAA2.jwks')
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
data = http.get(uri.request_uri)
p data.to_hash
```

If the cert is not trusted, we'll receive the following exception:

```
/usr/lib/ruby/2.6.0/net/protocol.rb:44:in `connect_nonblock': SSL_connect returned=1 errno=0 state=error: certificate verify failed (self signed certificate in certificate chain) (OpenSSL::SSL::SSLError)
	from /usr/lib/ruby/2.6.0/net/protocol.rb:44:in `ssl_socket_connect'
	from /usr/lib/ruby/2.6.0/net/http.rb:996:in `connect'
	from /usr/lib/ruby/2.6.0/net/http.rb:930:in `do_start'
	from /usr/lib/ruby/2.6.0/net/http.rb:919:in `start'
	from /usr/lib/ruby/2.6.0/net/http.rb:1470:in `request'
	from /usr/lib/ruby/2.6.0/net/http.rb:1228:in `get'
	from http.rb:8:in `<main>'
```

This doesn't help us do our work, so we have some options to get around the issue.

The most effective solution is following your Operating System's guidelines for installing a certificate globally.

Alternatively, we can use one of the two OpenSSL environment variables to get around it:

```sh
env SSL_CERT_DIR=/path/to/certs/folder ruby http.rb
env SSL_CERT_FILE=/path/to/cert.crt ruby http.rb
```

~~I've had some difficulty getting `SSL_CERT_DIR` working, so maybe expect a follow-up post on that.~~

Update 2019-12-04: I've written up how to get `SSL_CERT_DIR` working in my blog post [_Setting up a directory for OpenSSL's `SSL_CERT_DIR_]({{< ref "2019-12-04-openssl-certs-dir-setup" >}}).
