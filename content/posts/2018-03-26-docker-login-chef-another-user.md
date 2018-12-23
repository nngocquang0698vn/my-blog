---
layout: post
title: 'Running `docker login` as another user in Chef'
description: 'Hitting the error `permission denied while trying to connect to the Docker daemon socket` when trying to run `docker login` as a non-root user in Chef.'
categories: blogumentation
tags: docker chef blogumentation
no_toc: true
image: /img/vendor/chef-logo.png
---
Yesterday I was writing a cookbook, where I needed to log in to GitLab's private registry:

```ruby
execute 'log in to the GitLab private registry' do
  command "docker login -u jamietanna -p node['registry_key'] registry.gitlab.com"
  sensitive true
  user 'another-user'
  only_if { node['registry_key'].nil? }
end
```

I had assumed that this code would work, much like any other `execute` block, but I was getting the error:

```
Warning: failed to get default registry endpoint from daemon (Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.35/info: dial unix /var/run/docker.sock: connect: permission denied). Using system default: https://index.docker.io/v1/
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post http://%2Fvar%2Frun%2Fdocker.sock/v1.35/auth: dial unix /var/run/docker.sock: connect: permission denied
```

This was weird, as running the command interactively as that user worked fine:

```shell
$ whoami
staging-jvt-me
$ docker login -u jamietanna -p ${password} registry.gitlab.com
Login Succeeded
```

As did running it via `su`:

```shell
$ whoami
root
$ su another-user -c 'docker login -u jamietanna -p ${password} registry.gitlab.com'
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
Login Succeeded

```

The short-term fix is to update the `execute` block to the following:

```diff
 execute 'log in to the GitLab private registry' do
-  command "docker login -u jamietanna -p node['registry_key'] registry.gitlab.com"
+  command "su #{spectat.user} -c 'docker login -u jamietanna -p node['registry_key'] registry.gitlab.com'"
   sensitive true
   user 'another-user'
   only_if { node['registry_key'].nil? }
 end
```

I've not yet debugged the issue, but it seems that `docker login` expects some environmental configuration to be set, which isn't performed through a `execute` block's `:user` property, but is through running `su ... -c`.
