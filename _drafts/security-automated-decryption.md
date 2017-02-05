---
layout: post
title: Security Automated Decryption
---
What would happen if a DC with encrypted disks went down? Would you have to manually enter it at each machine?

we've currently got to the level of standards i.e. when to encrypt - PCI-DSS
now we're getting the automation (on-off switch)
and then it's defining policy (slider)

trying to move away from having a "key encryption key" for the key which opens the secret
- but this means that someone will know this (for obvious reasons)

so why not use an escrow, which will hold the key
then we need to authenticate to make sure we're who we say, and also authorize
need both the requester and the client to authenticate
need a secure channel
also need a chain of trust to make sure it's legit
oh wait, also backups! for root of trust, as well as the escrow

sounds good? nope, **heartbleed**
- presuming TLS to protect transfer is dangerous; any flaw in TLS means keys are available
- complexity leads to a greater attack surface (all nodes now can be attacked)
- X.509 is hard to get right! (improper sign/trust, etc)

can we use async crypto?
- i.e. Diffie-Hellman


sharing of `c` over the network means that anyone can steal it and decrypt `K` with
also shouldn't be plaintext transferring `K` over the network

recovery with McCallum-Relyea is different
- ephemeral keypair generated for decryption
- `e` and `c` are private
- server only gets "a public key"
- no encryption over the wire
- no state (therefore no (fancy) backups!)
can put keys within secure key hardware i.e. TPM, HSM

if public key is offline, can do the whole thing offline! only need online for decryption


tang and clevis are server and client
decryption is automatic if tang is up and running (i.e. don't need to type anything)
makes it very clean


uses custodia - secrets-as-a-service API
can do this using a block device, too! `-d /dev/sda1`
generates right key i.e. same size as master key

shamir secret share - levels of trust / branches
ie can set threshold - "at least 2 methods from password, yubikey, bluetooth, tang"


`luksmeta` - helper to make it possible to get metadata through LUKS
offloads to the upstream `cryptsetup` instead of doing its own stuff
