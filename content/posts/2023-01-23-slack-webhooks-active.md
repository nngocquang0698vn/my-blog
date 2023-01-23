---
title: "Does this Slack Webhook still work?"
description: "How to check if a Slack Webhook is still active."
date: 2023-01-23T14:04:14+0000
tags:
- blogumentation
- slack
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: slack-webhooks-active
---
Let's say you've just found something that looks like a [Slack incoming webhook URL](https://api.slack.com/messaging/webhooks) and want to check if it's active.

The URL may look something like:

```
https://hooks.slack.com/services/T0.../BF.../fXg...
```

I've found that sending a request like so is a good way to test validity, as well as let folks know who to get in touch with when they see it:

```sh
curl https://hooks.slack.com/services/T0.../BF.../fXg... -d 'payload={"text": "[Notice of leak] Slack Webhook found in source control. Webhook testing by <@jamie.tanna>"}' -i
```

Or, if this is an arbitrary URL that you're unsure which Slack instance it's connected to, it may be worth adding some contact details to it.

If the webhook is still active, you'll receive an HTTP 200, and if it's no longer valid, you'll receive an HTTP 403.
