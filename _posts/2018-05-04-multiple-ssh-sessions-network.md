---
title: Sharing Multiple SSH Sessions over the Same Network Socket
description: Reusing network sockets for speed and reduction of authentication handshakes with OpenSSH.
categories: blogumentation
tags: blogumentation ssh openssh cli
no_toc: true
---
At Capital One, we deploy our services to the AWS Cloud, where I will sometimes need to SSH onto a development instance to debug using log files or by attaching a debugger.

Although I am a big fan of using [tmux] for creating multiple windows on a given session, I'm unable (and/or unwilling) to install it any time I'm needing to debug. This means that I'll have tmux running on my local machine, and then have multiple, separate, SSH sessions to the remote.

Our instances are locked down by using Active Directory logins, so each time I connect to an instance I need to put in my password, which slows me down as it's quite a long one! Sometimes I'll log in, and then realise after some debugging I need to re-connect with some SSH port forwarding, i.e. to access the HTTP server locally.

However, I found recently that there's the ability in OpenSSH to share a network connection, which means that after the initial connection, it can reuse it for speed of connecting and sending data. Even more conveniently this includes authentication details, which means on a repeat connection, I don't need to supply my Active Directory password.

For example, assuming that my instances in a development environment were served on IP ranges beginning with `10.5.`, I could add the following configuration:

```
Host 10.5.*
	ControlMaster auto
	ControlPath ~/.ssh/sockets/%r@%h-%p
	ContolPersist 120
```

You'll notice that I've used an intentionally low persist timing of only 120 seconds. This is mostly due to the potentially short lived lifecycle for an instance, as a new instance (from another team) could well be spun up with the same IP as the instance I was using before. By keeping them alive for only 2 minutes, I have a good window of time to "remember" to want to come back and use the instance, as well as not being so long that I risk trying to reconnect to an old instance, which has since had its IP recycled.

This configuration then will create sockets with names like `jamie@10.5.1.2-22` or `root@10.5.1.4-55222`.

When performing a login, the flow is the same, but creates a `Shared connection` and a socket:

```shell
local $ whoami
jamie
local $ ls ~/.ssh/sockets
local $ ssh root@10.5.1.2
Enter your password:
remote $ whoami
root
remote $ exit
Shared connection to 10.5.1.2 closed.
local $ ls ~/.ssh/sockets
root@10.5.1.2-22
```

Now, when I log in, with the socket still active:

```shell
local $ whoami
jamie
local $ ls ~/.ssh/sockets
root@10.5.1.2-22
local $ ssh root@10.5.1.2
remote $ whoami
root
remote $ exit
Shared connection to 10.5.1.2 closed.
local $ ls ~/.ssh/sockets
root@10.5.1.2-22
```

And notice how here I didn't need to specify my password, as the network connection was still active.

We can also see the huge differences in speed of handshake overhead:

```shell
local $ ls ~/.ssh/sockets
# on the first connection
local $ time ssh root@10.5.1.2 whoami
root
ssh root@10.5.1.2 whoami  0.03s user 0.00s system 4% cpu 0.637 total

# on a following connection
local $ ls ~/.ssh/sockets
root@10.5.1.2-22
local $ time ssh root@10.5.1.2 whoami
root
ssh root@10.5.1.2 whoami  0.00s user 0.00s system 7% cpu 0.083 total
```

[tmux]: https://github.com/tmux/tmux
