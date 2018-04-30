---
layout: post
title: Downloading log files over SSH when your log aggregation service doesn't work
description: '**Without making changes to the files themselves**'
categories:
tags: break-glass logs ssh blogumentation shell tips
---
## Context

Let me paint the picture:

- You've had a production incident
- You're on call
- The log aggregation service hasn't worked, so you can't determine what's wrong
- You need to access the logs
- You've been authorized to use the break-glass procedure
- You want to spend as little time on the box, and not change anything

As we're touching a production service, we don't want to make _any_ adverse changes to the instance. This means we want to ensure we don't make any changes like a `chown` or a **??**.

Additionally, as we're touching a production service, we want to spend _as little_ time on the box as possible.

## The How-To

As someone deploying software to some remote server (i.e. Scaleway, DigitalOcean, AWS) you will hopefully have logging capabilities on your application. When something goes wrong, and you don't have log aggregation set up, you'll need to get your logs, and determine what's up.

If you're provisioning your applications with least access privileges, you may have a setup such as:

```bash
- flask app
- `flask` user
- `/srv/flask/log/*.log`
```

When logging into the instance, you will need to SSH as yourself, then log into the other user:

```bash
local $ ssh jamie@server
jamie@server $ sudo su - flask
Password:
flask@server $
```

**Note: not if want audit trail?**

Now we're running as the correct user, with the correct access, we should create a tarball of all our logs into a tmp folder:

```bash
flask@server $ tar czfv ~/flask-logs-$(date +%Y-%d-%m-%s).tar.gz /srv/flask/log
#                                                     ^ seconds since the UNIX Epoch
#                                           ^ i.e. 2017-05-09-1504605248
#                     ^ verbosely showing me what is in the archive
#                    ^ to a given file
#                   ^ a gzip'd archive
#                  ^ create
```


Now we have our logs in a separate directory, we can return to our own user account, and give our user ownership of that file, so we can then download it over SSH (given the filename `flask-logs-2017-05-09-1504605248.tar.gz`):

```bash
flask@server $ exit
jamie@server $ chown jamie:jamie ~/flask-logs-2017-05-09-1504605248.tar.gz
jamie@server $ exit
local $ scp jamie@server:flask-logs-2017-05-09-1504605248.tar.gz .
# Optionally delete it from the server once it's downloaded locally
local $ ssh jamie@server rm -v flask-logs-2017-05-09-1504605248.tar.gz
```

Now we have the archive locally, aren't risking anything by being on the box and reading files / making changes, and **???**.



```bash
- locate logs
- create tarball in /tmp
- scp to local
- confirm files exist
- delete /tmp/tarball
```

**Mention how this is the opposite of how it could be done by `chown` etc**
**Mention how this is ONLY in the case you don't have log aggregation set up**
