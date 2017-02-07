---
layout: post
categories: fosdem
tags: cloud
title: CloudABI
description: <
---
If running user-provided data, make it sandboxed! even if non-executing

Lots of choices for security frameworks:
- static
	- i.e. AppArmor, SELinux, POSIX 1003.1e capabilities
	- built with mindset - security model isn't great - it's a framework for the kernel
	-

analyse the code i.e. run it with general usage, and then see what's recommended

i.e. browser shouldn't need full FS access: just certain folders

problem: expect the developer to do it, but actually they don't care / fully understand it

usually set up by the user, rather than being API app should conform to

Capsicum
- OO OS API
	- i.e. objects are files in UNIX
	- directory fd = FS subtree
	- FD is just a handle - doesn't necessarily mean you get `rw` access
- use these objects to determine what process can do
	- `fork` - one process can `close(socket_rw)`
- `root` doesn't mean you have full access - still done through FDs

`cap_enter` - looks like strict `seccomp` mode
- means then can only do things that are enforced
- i.e. only open socket at `/tmp/predefined` instead of `/tmp/anythingelse`
- *But* requires apps to have to worry about it - can't hook into existing (i.e. AppArmor, SELinux)

however, some things don't work
- setting time with `tzset`
- `newlocale` and `mbstowcs_l` to convert strings between encoding
- `open('/dev/urandom')` but won't work?

sandboxing is stupid, and you shouldn't use it!
- spend too long working out why it doesn't work
- "even if it works, not necessarily working as intended"

**do not use on 3rd party code**
- no one sandboxes on their own stuff
- you'd need to understand inner workings
- you'd need to fight with their code to make it work
- they can update it at any point - breaking your sandbox exceptions etc


## Unconditional Sandboxing

what if it's always enabled?
incompatible APIs removed entirely
else is implemented to work well with sandboxing

fail at build time - _not_ runtime - easier!

keep going at it until it compiles

- take the C functions in POSIX spec
- add common extensions, Capsicum API
- remove anything that breaks Capsicum
- but still works! <60 syscalls
- OS-independent ABI for sandboxed apps
- also, much more lean OS that doesn't require huge number (300 - linux) of syscalls

machine-generated API

`cloudlibc`
- sandbox
- adds own library stuff so it doesn't have to be relied on i.e. own version of `time.h`
- ported (and prepackaged as CloudABI Ports):
	- `libc++` `Boost`
	- `Python3`, (basic - working on templating) `Django`
	- `json-c`
- generate **native** packages, instead of via it's own package manager
	- doing it the right way

available on current platforms! Linux, NetBSD need patches. FreeBSD by default. MacOS emulates (_not_ enforced by kernel)

has a nice YAML syntax to make it easier to define
- `!file` - "don't interpret this as a string!"
- easyish for the application to take in things
- much easier to test
- won't accidentally leak anything like fds - all has to be pushed into the app explicitly

##

more software + languages
better support ie via kernel module
improve docs!

CloudABI - dependency injection for UNIX

graph-based editor?
cluster-management i.e. via Kubernetes/Prometheus



trying to solve it at the root, not at the top level



