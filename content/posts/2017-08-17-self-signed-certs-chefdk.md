---
title: Trusting Self-Signed Certificates from the Chef Development Kit
description: How to get the ChefDK (and associated tools) to trust internal / self-signed certificates, in an easy oneliner.
categories:
- blogumentation
- chef
tags:
- chef
- chefdk
- certificates
- berkshelf
image: /img/vendor/chef-logo.png
date: 2017-08-17T00:00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: self-signed-certs-chefdk
---
If you're writing Chef cookbooks in a corporate environment, you may be developing against services on your internal network. As the services are not going to be exposed externally, the certificate used for HTTPS will be an intranet-only/self-signed cert, and therefore will require you to manually add it to your trust store.

You may think that "oh, but I've already trusted that cert in my Operating System / browser's trust store, so I don't need to make any other changes", but you would unfortunately be wrong. The ChefDK comes with its own trust store which needs to be updated with any certs you need.

**UPDATE 2019-01-14**: I used to recommend following a set of steps that would update the `/opt/chefdk/embedded/ssl/certs/cacert.pem` file in your ChefDK install. This was a bad decision, as it meant that you would need to re-update it each time you updated your ChefDK.

Instead, you should use `knife ssl fetch` for any certs you need:

```
$ knife ssl fetch https://supermarket.example.com/
WARNING: No knife configuration file found
WARNING: Certificates from supermarket.example.com will be fetched and placed in your trusted_cert directory (/home/jamie/.chef/trusted_certs).

Knife has no means to verify these are the correct certificates. You should
verify the authenticity of these certificates after downloading.

Adding certificate for supermarket_example_com in /home/jamie/.chef/trusted_certs/supermarket_example_com.crt
Adding certificate for supermarket.example.com_1547487830 in /home/jamie/.chef/trusted_certs/supermarket.example.com_1547487830.crt
```

This places them within your home directory, and means that you can change your version of the ChefDK regularly, without risk of requiring pulling the new certs.

Note that this can be applied to _any_ hosts inside your network that require communication over HTTPS, not just your Supermarket.

**Note**: If you are behind a corporate proxy, you will need to make sure that `knife` does not go via the proxy for these certs. This will mean you must set your `no_proxy` environment variable appropriately, otherwise you won't be able to successfully fetch the certificates.

[extract-tls-certificate]: {{< ref 2017-04-28-extract-tls-certificate >}}
