---
title: "Issues with Ordering When Using Vault CLI's `-no-print` Argument"
description: "A possible solution for `no-print` not taking effect with the `vault` CLI when using AWS EC2 auth."
tags:
- blogumentation
- vault
- aws
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-06-15T10:59:02+0100
slug: "vault-no-print-ordering"
---
Today I've been fighting a bit of an issue with the Vault CLI (v1.1.2) not masking the output of a `vault login`.

It appears that this is due to the ordering of the arguments I was using:

```diff
-vault login -method=aws -path=aws-ec2 role=.... -no-print=true
+vault login -no-print=true -method=aws -path=aws-ec2 role=....
```

In the former command, it appears that the EC2 auth takes arguments (i.e. `role`) which are slightly different to Vault's usual arguments, such as `-no-print`.

By moving it earlier in the command, it no longer prints output for the result of `login`.
