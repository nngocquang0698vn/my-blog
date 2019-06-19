---
title: "Easily rewriting Git URLs from HTTPS to SSH and vice versa"
description: "How to use Git's config to rewrite HTTPS URLs to SSH and vice versa, for repo pushes and pulls."
categories:
- blogumentation
- git
tags:
- blogumentation
- git
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-03-20T10:39:18+00:00
slug: "git-rewrite-url-https-ssh"
image: /img/vendor/git.png
---
If you're working with Git repos regularly, be it for personal projects, Open Source work, or your day job, you may have have discovered [SSH keys] and using them to push/pull over SSH connections. They're a great way to remove the reliance on entering your username/password combination, as well as having a number of other security benefits.

One key issue with using SSH keys for authenticating yourself with your Git host is that you need to have thought about it before you clone a repo, or at least before you push your changes. That's because at the time it's making a connection to the remote, Git needs to know what protocol to use. And if you've previously cloned it over HTTPS, Git will respect that and not know that you want to upgrade to SSH.

So what you may find yourself doing is manually rewriting the URL yourself each-and-every time, i.e. by running :

```sh
git remote set-url origin git@gitlab.com/...
```

That is, until you know that Git comes with the ability to configure this, by adding the following to your [Git config] either globally (`~/.gitconfig`) or per-repo (`.git/config`):

```ini
[url "ssh://git@github.com/"]
	insteadOf = https://github.com/
[url "ssh://git@gitlab.com/"]
	insteadOf = https://gitlab.com/
```

Alternatively, you can run the following commands (adding in `--global` as necessary):

```sh
git config url.ssh://git@github.com/.insteadOf https://github.com/
git config url.ssh://git@gitlab.com/.insteadOf https://gitlab.com/
```

This then instructs Git to rewrite your URLs as necessary when pulling/pushing from your repos - awesome!

However, this may not be exactly what you want, as you may only want to push over SSH, but pull over HTTPS. Fortunately Git also provides the ability to use `pushInsteadOf` for this, configured as such:

```ini
[url "ssh://git@github.com/"]
	pushInsteadOf = https://github.com/
[url "ssh://git@gitlab.com/"]
	pushInsteadOf = https://gitlab.com/
```

And this has the added benefit of being able to visit any repo in the browser, and copy-paste the URL to `git clone` it, yet be able to push over SSH - begone the woes of manually rewriting your Git URLs, or clicking in UIs to get the right SSH clone URL!

Note that this can be used with all manner of Git hosts, including your organisation's internal Git repository.

[SSH keys]: https://docs.gitlab.com/ee/ssh/README.html
[Git config]: https://git-scm.com/docs/git-config
