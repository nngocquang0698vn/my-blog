---
title: Cyber Nottingham May
description: A writeup of the Cyber Nottingham meetup in May.
tags:
- events
- cyber-nottingham
- security
date: 2019-05-19T16:35:24+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: cyber-nottingham-may
aliases:
- /replies/e42361e4-cd9a-461a-a5f8-4175c3cdf37e/
- /mf2/e42361e4-cd9a-461a-a5f8-4175c3cdf37e/
---
This is a writeup of <a href="https://www.meetup.com/Nottingham-Cyber-Capital-One/events/260280774/">the May Cyber Nottingham meetup</a>

This was the inaugural meetup for Cyber Nottingham, hosted by Capital One (my employers), but as I've always had a strong interest in Cybersecurity I definitely wanted to go.

# TLS 1.3

[Graham Sutherland](https://twitter.com/gsuberland) took us through TLS 1.3, in terms of how we arrived here and what it brought to the table.

As a reviewer of crypto standards and an implementer of various crypto-related tools, Graham was a good person to talk through it.

Most of the talk was over my head, and full of a number of acronyms and names of security attacks, but fortunately Graham also shared that there were many that he couldn't remember.

Graham spoke about how in the past the community has decided that the solution for mitigating most attacks should be "add an extension to TLS to resolve this issue". This doesn't help because TLS is still the same overall version, and it makes it harder for others to implement libraries as they have a shifting target. Because this has mostly been tagged on, it means that there's a fair bit of tech debt associated with it that makes it much harder for maintainers.

The security community are moving to be much more forward thinking and preventative, rather playing "whack a mole".

Graham noted that to make others adopt a new version of a thing, it has to be easy to adopt! Making it difficult means fewer people will jump at doing it - citing the Python 2/3 upgrade issues.

TLS 1.3 has been planned to remove a lot of those issues; both accrued tech debt, unused features and unsafe / difficult to implement features. And as well as removing a lot of stuff, they also added more.

For instance, forward secrecy is now available for all, by default! This is because it makes key exchange ephemeral, which means that keys will be destroyed after each conversation, so unless you're _already_ actively MITMing traffic, you can't retroactively decrypt things.

We now have encrypted SNI and a few modes that will allow a Load Balancer to understand which virtual host a connection is being sent to, without having access to the underlying content of the message. In addition, certificate lookups are added, otherwise that could also leak which sites you're interacting with, even if using SNI.

Finally we spoke a little about TLS Intercept Appliances (TIA) and how they're effectively broken for TLS 1.3, due to pieces like forward secrecy, as they have to do more work to keep up with it (it is possible, just much more difficult).

Lots of banks got together in 2016 to petition TLS 1.3 to re-add the ability to not run with forward secrecy but it was denied.

Then, TIA vendors in 2018, but again got ignored, so they got together to create what they tried to call Enterprise TLS. This was blocked, so instead it is ETS, but so far has no adoption.

Just a note that there are places where you would expect this to happen, as it makes it possible to perform deep packet inspection and determine if someone is trying to exfiltrate data out of your network, but can be something dangerous if that were to be attacked, as well as has privacy implications.

This was an interesting talk, although because I'm not hugely involved in the Cyber community I was definitely lacking some of the background knowledge.

# Smart Locks

The next talk from [David Lodge](https://twitter.com/tautology0) was all about how we have smart locks that have been developed with dumb security, quoting the common saying:

> there is no security if you have physical access

David spoke about how we should threat model, as with other kinds of security; a lock has a sensor i.e. fingerprint/bluetooth, a charging port, the casing and a motor/mechanism, all of which can be attacked.

We went through different examples of how we could attack these locks:

What material is it made of? Common lower-end smart locks are made of a material that has ~300 degrees melting temperature, whereas an average blowtorch burns at ~1500 degrees

Can you screw the casing open?

- can you push the locking mechanism back and unlock it?
- can you attach a battery to the motor to unlock it?
- are there any debug ports on the board for the device that you can attach to?

Is there an Android app that we can de-obfuscate to work out any more details about how it unlocks the device?

Is there an API that the lock talks to?

- are there any ways we can sniff the traffic to pick up any helpful data i.e. the lock's key (this was a real example where sending a MAC address to the API returned a JSON response with details about the lock, including its key!!)
- is the API suitably designed and protected i.e. with rate limiting

Is there a vulnerability with the Bluetooth comms?

- if you don't pair to the device, communications are in cleartext, so you can sniff someone else's comms
- otherwise can you find any common patterns in the communication and see if you can interact with the lock yourself

Could the charging port be attacked?

Can you just break it open?
- magnets
- bolt cutters
- washing machine vibrations

And while researching this, a gem that a company responded with:

> the lock is invincible  to the people who do not have a screw driver

This talk pretty much confirmed my suspicions that smart locks were going to be less secure, although David mentioned that there are some vendors that are better than others, and you have to pay for quality.
