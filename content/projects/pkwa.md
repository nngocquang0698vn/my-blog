---
layout: project
date: 2015-02-8
title: Public Key Web Authentication
image: /img/projects/pkwa.png
github:
gitlab:
description: Public Key Web Authentication is a project aiming to abolish passwords by using key-based authentication.
tech_stack:
- flask
- mysql
- bootstrap
- chromeextension
project_status: completed
---
Public Key Web Authentication is a project aiming to abolish passwords by using key-based authentication. It is built in two parts; a Chrome extension which can authenticate as the user, and a simple server that acts as a reference for the concept.

The user can either provide a pre-generated public and private key for the Chrome extension, or generate the key pair inside the extension. Note that one restriction of the system is that, in the interest of security, it requires users to use a passkey for their private key.

When registering with a service supported by PKWA, the user is requested to provide their public key, for use later when logging in. Although not recommended, users will also be able to log in through passwords, although additional restrictions on passwords would be added, such as increasing minimum length to at least 16 characters, requiring special characters, etc.

Then, when they visit the site again and needs to log in, the server sends a random string of character to the client, along with the hash function required and protocol version. The extension then takes the data, and signs it with the private key. When the form is submitted, the server is then able to verify that the message is intact using the client's public key.

However, this project has two major security issues we discussed; one of other users gaining access to the keys, and the ability to man-in-the-middle connections.

Firstly, we have the issue of being able to steal a user's keys by loading the extension and copying-and-pasting the content to files. This is partly mitigated by requiring a passphrase for the key, which ensures that even with the private key, there will be no way to use it. However, this does not help as we store the passphrase, and decoded private key, in memory. A dedicated attacker will be able to inspect the memory and extract both the passphrase and key.

Secondly, this system can trivially be exploited by a man-in-the-middle attack. For instance, a malicious server could load the request for a valid server, and then forward that request to the client. The client would fill in the data as if the request were from the valid server, and then the malicious server would be able to proceed as if they were the client. This is obviously a huge issue with the concept, and requires careful thought; the best idea would be to add a level-of-trust similar to how SSL certificates work.
