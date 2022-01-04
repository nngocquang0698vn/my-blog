---
title: "Suppressing `No pinentry` warnings with GPG (in Automated Builds)"
description: "How to get avoid `No pinentry` warnings when running GPG in automated build environments like CI/CD."
tags:
- blogumentation
- gpg
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-01-04T12:49:50+0000
slug: gpg-pinentry-loopback
---
If you're trying to automagically sign things using GPG in an automated build environment, such as Jenkins or GitLab CI, you may encounter warnings, like the following, where there's `No pinentry` program available:

```
$ gpg -v --import $SIGNING_KEY
gpg: directory '/root/.gnupg' created
gpg: keybox '/root/.gnupg/pubring.kbx' created
gpg: sec  rsa3072/DF7507BC5D21FAD0 2022-01-04  Jamie Tanna <gpg-automation@jamietanna.co.uk>
gpg: /root/.gnupg/trustdb.gpg: trustdb created
gpg: using pgp trust model
gpg: key DF7507BC5D21FAD0: public key "Jamie Tanna <gpg-automation@jamietanna.co.uk>" imported
gpg: no running gpg-agent - starting '/usr/bin/gpg-agent'
gpg: waiting for the agent to come up ... (5s)
gpg: connection to agent established
gpg: key DF7507BC5D21FAD0/DF7507BC5D21FAD0: error sending to agent: No pinentry
gpg: error building skey array: No pinentry
gpg: error reading '/builds/jamietanna/cucumber-reporting-plugin.tmp/SIGNING_KEY': No pinentry
gpg: import from '/builds/jamietanna/cucumber-reporting-plugin.tmp/SIGNING_KEY' failed: No pinentry
gpg: Total number processed: 0
gpg:               imported: 1
gpg:       secret keys read: 1
```

A hint from [this GitLab issue](https://gitlab.com/gitlab-org/gitlab/-/issues/29383) highlighted the fact that we can force the `loopback` pinentry mode, which is explained more [on StackOverflow](https://unix.stackexchange.com/a/415064), and can be seen with the following tweak to our command:

```diff
-gpg -v --import $SIGNING_KEY
+gpg --pinentry-mode loopback -v --import $SIGNING_KEY
```

This then silences the warnings, so you no longer need to worry about not having a pinentry program.
