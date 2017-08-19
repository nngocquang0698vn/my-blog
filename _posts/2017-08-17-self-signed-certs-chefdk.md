---
layout: post
title: Trusting Self-Signed Certificates from the Chef Development Kit
description: How to get the ChefDK (and associated tools) to trust internal / self-signed certificates, in an easy oneliner.
categories: findings chef
tags: chef chefdk certs berkshelf
no_toc: true
---
If you're writing Chef cookbooks in a corporate environment, you may be developing against services on your internal network. As the services are not going to be exposed externally, the certificate used for HTTPS will be an intranet-only/self-signed cert, and therefore will require you to manually add it to your trust store.

You may think that "oh, but I've already trusted that cert in my Operating System / browser's trust store, so I don't need to make any other changes", but you would unfortunately be wrong. The ChefDK comes with its own trust store which needs to be updated with any certs you need. Assuming that the ChefDK is installed in `/opt/chefdk`, then the full path to the cacert bundle will be `/opt/chefdk/embedded/ssl/certs`.

We can combine the steps in [my article on extracting certificates][extract-tls-certificate] with writing to the embedded OpenSSL bundle of trusted certs for the ChefDK. For instance, if we want to trust the certificate for the host `internal-supermarket.example.com`, you can run the following:

```bash
$ openssl s_client -showcerts -connect "internal-supermarket.example.com:443" < /dev/null 2>/dev/null |\
  sed -n -e '/BEGIN\ CERTIFICATE/,/END\ CERTIFICATE/ p' |\
  sudo tee -a /opt/chefdk/embedded/ssl/certs/cacert.pem
```

Note that this can be applied to _any_ hosts inside your network that require communication over HTTPS, not just your Supermarket.

[extract-tls-certificate]: {% post_url 2017-04-28-extract-tls-certificate %}
