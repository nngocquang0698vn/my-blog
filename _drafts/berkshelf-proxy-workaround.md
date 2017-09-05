---
layout: post
title: '`SSLError` When Running Berkshelf Behind a Proxy'
description:
categories:
tags:
---
When running in a corporate environment, you may encounter the following error:

```bash
$ echo $http_proxy $https_proxy $HTTP_PROXY $HTTPS_PROXY
http://proxy.example.com
$ echo $no_proxy

$ cat Berksfile
source 'https://supermarket.example.com'
depends 'java'
$ berks
...
OpenSSL::SSL::SSLError: SSL_connect SYSCALL returned=5 errorno=0 state=SSLv2/v3 read server hello A
...
```

In order to get this working, you need to add the _fully qualified domain name_ of the server(s) to be ignored by Berkshelf. This **will not** work when using i.e. `no_proxy=.example.com`, as Berkshelf doesn't seem to support that.

Therefore, you need to set `no_proxy=supermarket.example.com`.
