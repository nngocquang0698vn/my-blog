---
title: "Who do these Twilio credentials belong to?"
description: "How to work out whether arbitrary Twilio credentials are valid, and if so, what type they are."
date: 2023-03-08T20:23:37+0000
tags:
- blogumentation
- twilio
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/770ef46545.png
slug: twilio-who-credentials
---
Let's say you've found some Twilio credentials, and want to work out whether they're still active.

Twilio has two types of credentials - "auth tokens" and API Keys. The "auth tokens" are bound to an account or a user, whereas API keys are more of a machine-user credential and have two types - `Main` and `Standard`.

I ended up [writing a tool for this](https://gitlab.com/tanna.dev/twilio-who-credentials) as it makes interacting with the Twilio API a little easier, but the same underlying API calls can be conducted through `curl` or similar.

From the README of the project:

## With an Auth Token

An auth token may be found in the Twilio console for a given Account SID.

```sh
env TWILIO_ACCOUNT_SID=... \
  TWILIO_AUTH_TOKEN=... \
  twilio-who-credentials
```

The command will return a non-zero status code if the auth token could be used. If valid, information about the account will be printed out, such as the account name.

## With an API Key

An API key may be issued from the Twilio console, and may be either a `Main` or a `Standard` token. This tool detects, as best as it can, the type of token in use.

```sh
env TWILIO_ACCOUNT_SID=... \
  TWILIO_API_KEY=... \
  TWILIO_API_SECRET=... \
  twilio-who-credentials
```

The command will return a non-zero status code if the API key could be used. If valid, information will be returned as to whether it's a `Main` or `Standard` API key.

If a `Main` API key, information about the account will be printed out, such as the account name.
