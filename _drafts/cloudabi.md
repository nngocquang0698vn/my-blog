---
layout: post
categories: fosdem
tags: cloud
title: CloudABI
title: CloudABI - Easily develop sandboxed apps for UNIX
description: <
---
CloudABI is a project born out of the need to sandbox applications such that exploits are unable to cause any undue access or `??`. This is more prevalent in the Cloud world, where all your applications are `on a machine somewhere`, and `??`.

For instance

```markdown
There currently are a few security frameworks around that provide such functionality, such as [AppArmor][AppArmor], [SELinux][SELinux] and [POSIX 1003.1e capabilities][POSIX10031e] which run on the OS around the application. However, these are usually built with the mindset that the default security model - Discretionary Access Control (**DEFINE**) - isn't best.
  Instead, they provide an extra level of security in the kernel, that provides extra security to prevent any access through Mandatory Access Control (**DEFINE**).
  The issue with these frameworks is that they provide the wrapping external to the application. That is, the application itself isn't developed with this in mind. Because of this, the rulesets required to make it function within the framework are created by observing the system in use. However, this can lead to false positives, and assumptions that certain steps in the application are well-formed, when in fact they may not be. Alternatively, these steps could even be abused (**HOW??**).
```

Therefore, as **presenter** goes on to discuss, applications should be built with this sandboxing inherent, such that they can ensure they will always perform valid actions. Additionally, the application developer should always know what their code will be doing, and how it should perform. __NAME__ goes on to discuss how the problem should be fixed at the root, rather than at the top - if the application itself is defined with the well-formed routes, and the sandbox it runs in is __??__, then it __should work__.

The issue is that we can't be expecting all developers to be security experts, or to care and fully understand everything that needs to be done.


One such tool is [Capsicum][Capsicum], an Object Oriented Operating System API which allows developers to __??__. Capsicum works by providing file descriptors that have fine grained controls, such that __??__. Because these file descriptors are simply a handle to some resource, they don't provide implicit read-write access, therefore __??__.
  **Where do objects come into this?**
  Capsicum's main selling point is that it builds on the POSIX API, such that __??__.

  Additionally, this methodology (much like that of a Mandatory Access Control system) means that even if a process is running as `root`, it still doesn't have the full system access as it has to work within the file descriptors provided to it. This means that a process would only be able to open a socket at `/tmp/tmux.1000`, instead of `/tmp/tmux-socket` or `/tmp/tmux-x11` or similar.

However, there are a number of things that don't work out of the box - setting the timezone, using `tzset`, and even `open('/dev/urandom')`. These inconveniences, for programs that would expect such behaviour to _just work_ brought the comment "sandboxing is stupid, and you shouldn't use it!" **Name** went on to discuss how often, you spend far too long working out why the program isn't working, instead of doing **more useful things**. And "even if it works, not necessarily working as intended"; the idea that just because the rules have been configured to make sure that the application works, doesn't mean it does the right things. For instance, the application could be malformed, and could be taking steps that it _shouldn't be_, such as overreaching the file access it's making. For instance, **??**.


**alternative to capsicum - seccomp**

If running user-provided data, make it sandboxed! even if non-executing

**analyse the code i.e. run it with general usage, and then see what's recommended**

**i.e. browser shouldn't need full FS access: just certain folders**

<div class="divider">^^^^^</div>

But this still doesn't make things optimal - what if we made it so we had unconditional sandboxing? And if any incompatible APIs were completely removed from the built application? Where anything that is compatible with the APIs, is implemented to work well with sandboxing? And what if that optimal system was enforced at build-time, not run-time? This is where we get to CloudABI.

In a world where this is enforced at build-time, you would have to work against compiler errors, incrementally fixing your application against the static set of issues, until you finally had a build. This final version would be well-formed, and __??__.

CloudABI was built by taking the C functions in the POSIX spec, then adding common extensions following the Capsicum API, and removing anything that would break the Capsicum API. This still works, however, and provides just under 60 syscalls, ensuring to remove (`https://github.com/NuxiNL/cloudlibc#cloudlibc-standard-c-library-for-cloudabi`). This resulting set of __??__ provides an Operating System independent ABI for sandboxed applications; and additionally, one that is much more lean than a standard Operating System - for reference, Linux has ~300 syscalls.






```markdown
Capsicum
- use these objects to determine what process can do
	- `fork` - one process can `close(socket_rw)`

- means then can only do things that are enforced
**- *But* requires apps to have to worry about it - can't hook into existing (i.e. AppArmor, SELinux)**

**do not use on 3rd party code**
- no one sandboxes on their own stuff
- you'd need to understand inner workings
- you'd need to fight with their code to make it work
- they can update it at any point - breaking your sandbox exceptions etc

## Unconditional Sandboxing


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



```


[lwn674770]: https://lwn.net/Articles/674770/
[cloudlibc]: https://github.com/NuxiNL/cloudlibc
[Capsicum]: https://www.freebsd.org/cgi/man.cgi?query=capsicum&sektion=4
