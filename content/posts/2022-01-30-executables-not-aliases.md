---
title: "Create Executables, not Shell Aliases or Functions"
description: "Why I create standalone executable scripts instead of shell aliases or functions."
tags:
- command-line
- automation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-30T13:37:48+0000
slug: executables-not-aliases
---
I am a fan of making it my life easier and more efficient by using time-saving tools like command-line tooling to save the number of keystrokes I have to enter for common interactions..

For instance, as I use [Gradle](https://gradle.org) a lot, so find myself writing the following a lot:

```sh
./gradlew clean build
./gradlew spotlessApply
./gradlew spAp # the shorter alternative I actually use
./gradlew bootRun
```

I ended up writing a shell alias to simplify this, which allows me to instead invoke Gradle with `g`:

```sh
alias g=./gradlew
```

However, the crux of this post is that using an `alias` / `function` in your shell's language don't work outside of your shell.

For instance, if you want to try and make sure that all commits on a branch pass their tests, you may write:

```sh
$ git rebase origin/HEAD --exec 'g clean test'
```

But unfortunately, that will land you with the following error:

```
Executing: g
error: cannot run g: No such file or directory
warning: execution failed: g
You can fix the problem, and then run

  git rebase --continue
```

This is because Git is executing commands, without using your current terminal environment, meaning your customisations like `alias` / `function` won't be available.

The solution instead is to make sure that you create an executable file, for instance:

```sh
mkdir -p ~/bin
export PATH=$PATH:$HOME/bin
touch ~/bin/g
chmod +x ~/bin/g
```

Where the `~/bin/g` script has the contents:

```sh
#!/usr/bin/env bash
./gradlew "$@"
```

I've [currently got 17 helpers](https://gitlab.com/jamietanna/dotfiles-arch/-/tree/main/terminal/home/bin), for copy/pasting from the command-line, pretty-printing JWTs, JSON, etc, and it makes life a lot easier.

There are some aliases in my config that aren't yet migrated over - because I don't need them / use them enough to be useful as an executable script.
