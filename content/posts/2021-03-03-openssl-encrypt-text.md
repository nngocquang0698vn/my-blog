---
title: "Encrypting and Decrypting Text with OpenSSL"
description: "How to use `openssl` to encrypt text with a shared passphrase."
tags:
- blogumentation
- openssl
- security
- privacy
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-03-03T20:46:26+0000
slug: "openssl-encrypt-text"
---
Last week at work, we had a hackathon, in which the recommendation was to give our (production) Hackathon API a go. This required logging in via a GitHub.com account to retrieve a JSON Web Token to use to authenticate yourself to the API.

I have a general policy of trying to keep my personal and work lives generally unentwined, so did not want to do it on my work machine. Instead, I logged in using my personal machine, but then had to send the JWT to my work email, which I didn't want to do in cleartext, because [JWTs are sensitive]({{< ref 2020-09-01-against-online-tooling >}}).

To encrypt it, there are fortunately quite a few options, but in my case, it was a throwaway piece of work, so I thought just encrypting it with a shared secret would be enough, instead of i.e. worrying about GPG/PGP keys.

Although encrypting it worked pretty easily, I found it surprisingly difficult to decrypt on my work Mac and kept getting an error similar to the following:

```
bad decrypt 130692476720256:error:06065064:digital envelope routines:EVP_DecryptFinal_ex:bad decrypt:../crypto/evp/evp_enc.c:570:
```

After a while of searching online, I found that this is due to the [differences in OpenSSL implementations and how they use message digests](https://unix.stackexchange.com/a/606518), and the solution is to make sure you explicitly use a message digest.

This gives us the following command to encrypt:

```sh
openssl enc -aes-256-cbc -pbkdf2 -salt -in file.txt -out file.enc -md sha512
# or to Base64 encode it, so it's safe to go in i.e. the body of an email
openssl enc -aes-256-cbc -pbkdf2 -salt -in file.txt -out file.enc -md sha512 -base64
```

And the following to decrypt:

```sh
openssl enc -d -aes-256-cbc -pbkdf2 -md sha512 < file.enc
# or if Base64-encoded
openssl enc -d -aes-256-cbc -pbkdf2 -md sha512 -base64 < file.enc
```
