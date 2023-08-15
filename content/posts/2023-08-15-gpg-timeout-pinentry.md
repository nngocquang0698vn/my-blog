---
title: "Resolving `Timeout`s when generating entropy when generating a new GPG key"
description: "How I resolved an issue with a `Timeout` error when generating a new GPG key."
tags:
- blogumentation
- gpg
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2023-08-15T21:48:37+0100
slug: gpg-timeout-pinentry
---
Following my setup on my new work laptop, I was setting up a new GPG key when I encountered the following error when generating it (linebreak added for readability):

```
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

gpg: agent_genkey failed: Timeout
Key generation failed: Timeout
```

Searching around for causes, I stumbled upon a few threads - displaying different error messages - but noting that it may be that `gpg-agent` doesn't have a `pinentry` program that can be used.

I had no GPG agent configuration in `$HOME/.gnupg/gpg-agent.conf`, so it must've been using the defaults, and so I specified the following configuration:

```
pinentry-program /usr/bin/pinentry-qt
```

At this point, I then received a pop-up to provide the passphrase for the key.

What was interesting was that this was presented as a timeout, whereas I'd have expected a different error (such as `No pinentry` as I'd seen in some posts).
