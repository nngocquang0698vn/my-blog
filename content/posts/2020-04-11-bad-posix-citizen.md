---
title: "Being a Bad POSIX Citizen"
description: "Owning up to using GNU coreutils, even on BSDs, because I'm lazy."
tags:
- linux
- posix
- bsd
- mac
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-04-11T18:12:43+0100
slug: "bad-posix-citizen"
image: https://media.jvt.me/9a5b0feff9.jpeg
---
I've just been listening to the [Syscast](https://ma.ttias.be/syscast/) episode [_The differences between Linux and BSD_](https://ma.ttias.be/syscast/9-linux-vs-bsd/), which was really interesting. I'm a GNU/Linux user in my personal life, and in my professional life at <span class="h-card"><a class="u-url p-name" href="https://capitalone.co.uk">Capital One</a></span>, I use Mac OSX and deploy onto Linux-based AWS EC2, but I have never used a "real" BSD on the server, or for general purpose computing.

<span class="h-card"><a class="u-url p-name" href="https://annadodson.co.uk/">Anna</a></span> has recently [got a new job](https://annadodson.co.uk/blog/2020/04/06/new-job/) in which she's going to be working on Mac, so I shared some of my top tips for getting used to it compared to Linux, and a few things to help with productivity that I've found useful. One of those points was to ignore the BSD coreutils, and instead use the GNU ones - i.e. use the GNU `ls` over the one that's installed on Mac by default.

Before I first started to use Mac, I'd heard of making scripts compliant with POSIX, so they were more portable. However, I'd not really got around to properly trying it aside from [what ShellCheck told me off for](https://unix.stackexchange.com/a/277754). But it wasn't until I started using it that I found it very frustrating to be swapping between the two flavours of tools, and having to find a middle ground which wasn't nearly as powerful.

The end result was that I decided to install the GNU versions of the tools, because I couldn't be bothered with trying to compromise / write platform-dependent scripts, and it was a straightforward fix.

It's a shame really, because I really should've stuck at it and learned how to write scripts with a different toolchain, and to bolster my experience and knowledge, instead of taking the easy way out.

But that being said, I'm not really sure I will aim to correct this - I'm trying to avoid shell scripts where possible, and instead replacing them with a scripting language like Ruby, which I personally find better to read and write. But I _will_ make sure colleagues are aware that the shell scripts I write are built to be run with GNU tools, lest they find issues running them.
