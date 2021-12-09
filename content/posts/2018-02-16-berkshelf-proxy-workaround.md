---
title: '`SSLError` When Running Berkshelf Behind a Proxy'
description: 'Getting around the pesky `OpenSSL::SSL::SSLError SSLv2/v3 read server hello A` error when running Berkshelf behind a proxy.'
tags:
- chef
- blogumentation
- proxy
- command-line
- shell
- chefdk
- berkshelf
image: /img/vendor/chef-logo.png
date: 2018-02-16T15:44:00+00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: berkshelf-proxy-workaround
---
I found recently that when trying to download cookbooks in an environment that required a proxy, I would encounter the error `OpenSSL::SSL::SSLError: SSL_connect SYSCALL returned=5 errorno=0 state=SSLv2/v3 read server hello A`, even when I had a proxy set for i.e. `.example.com`:

```bash
$ cat Berksfile
source 'https://supermarket.example.com'
depends 'java'
$ echo $http_proxy $https_proxy $HTTP_PROXY $HTTPS_PROXY
http://proxy.example.com
$ echo $no_proxy
.example.com
$ berks
... large stacktrace ...
OpenSSL::SSL::SSLError: SSL_connect SYSCALL returned=5 errorno=0 state=SSLv2/v3 read server hello A
...
```

When Berks attempted to perform an SSL handshake with `supermarket.example.com`, it would fail with SSL issues which were actually hiding the real problem. Debugging this, I found that the ChefDK was happy with the certificate (as I had [already trusted the certificates][self-signed-certs-chefdk]) and that if I used `curl --cacert /opt/chefdk/embedded/ssl/certs/cacert.pem https://supermarket.example.com`, I would be able to connect successfully. This proved out that the cert bundle was correct, so the next issue had to be something funky in Berks or Ruby.

I narrowed it down to seeing some hits to `supermarket.example.com` on my local proxy, realising that this issue was due to a proxy lookup for that hostname failing, as it wasn't a publicly accessible host that the proxy would be able to resolve. It seems like when either Berkshelf or the Ruby code behind it does a hostname lookup, it doesn't expand the `.example.com` in `no_proxy` to match `supermarket.example.com`.

In order to workaround this issue, the solution is to append `supermarket.example.com` to your `no_proxy` variable in your shell.

A successful run once you have set this variable will look like:

```bash
$ echo $http_proxy $https_proxy $HTTP_PROXY $HTTPS_PROXY
http://proxy.example.com
$ echo $no_proxy
.example.com,supermarket.example.com
$ berks
Using java (x.x.x)
```

[self-signed-certs-chefdk]: /posts/2017/08/17/self-signed-certs-chefdk/
