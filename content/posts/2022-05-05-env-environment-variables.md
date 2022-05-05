---
title: "When should I use `env` to start a command with environment variables?"
description: "When you should use the `env` command to specify environment variables when executing a command on the command-line (TL;DR: always)."
date: 2022-05-05 #
syndication:
- "https://brid.gy/publish/twitter"
tags:
- "blogumentation"
- "command-line"
- "shell"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "" # TODO
slug: "env-environment-variables"
---
I've always followed the principle of running shell commands that require environment variables with the [`env` command](https://linux.die.net/man/1/env) for as long as I've been writing shell scripts, and can't remember the exact reason for this, but I remember the place I read it sounded pretty sure about it, and it took me many years to understand why.

About 6 years ago, I was writing a Chef cookbook to deploy a WAR file to an EC2 instance and then restarting Tomcat. To do this, there was a command that needed an environment variable passed to it, and my colleague used the following incantation:

```sh
THE_VAR=something ./script.sh
```

I unfortunately can't really remember many of the details and annoyingly didn't blog about it at the time, but for whatever reason this didn't work, and the variable wasn't passed correctly. (If I ever find out what it was, I'll update this post)

To fix this issue, however, all we needed to add the `env` command prefix:

```sh
env THE_VAR=something ./script.sh
```

This solidified the need to always add it, and I don't think this very poorly remembered story will convince you 😅

Instead, let's consider other options. Let's say that we want to take the following command, which works in `sh`/`bash`/`zsh`/`fish`:

```sh
FILE={} ./env.sh
```

When we want to execute this script when passing it to another command, we need to add `env`, or shell out, otherwise it's not interpreted correctly:

```sh
# when not using env, the environment variable isn't passed correctly
$ find . -type f -exec FILE={} ./env.sh \;
find: 'SHELL=./env.sh': No such file or directory
# when using env, it is passed correctly
$ find . -type f -exec env FILE={} env ./env.sh \;
FILE=./env.sh
# or when using a shell to execute it
$ find . -type f -exec sh -c 'FILE={} env ./env.sh' \;
FILE=./env.sh
```

This is also the case with things like `git rebase`, or any other command that executes commands without executing it in a shell.
