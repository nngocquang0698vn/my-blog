---
title: "Setting up real-time Slack notifications for GitHub"
description: "How to get Slack's real-time notifications integrated with GitHub."
date: 2023-08-23T20:48:02+0100
tags:
- blogumentation
- github
- slack
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/36fd7d2a48.png
slug: github-slack-notifications
---
Since starting my new job at Elastic, I've been going through my usual productivity hacks like setting up my dotfiles, organising Slack channels and setting up GitHub notifications in Slack.

But I couldn't remember how I did it last, and [the documentation](https://github.com/integrations/slack#personal-scheduled-reminders) isn't _super_ clear, so thought I'd document it for future me.

1. Browse to your user settings, and under the `Integration` heading, select `Scheduled reminders` ([link](https://github.com/settings/reminders))
1. Select the GitHub organisation that you want to set up real-time notifications
1. Select `Authorize Slack workspace` and connect to the Slack you want the notifications in
1. Select `Enable real-time alerts` **??**
1. Unselect `Review requests assigned to you` (if you don't want reminders)
1. Click `Create reminder`

![The GitHub "Scheduled Reminders" view, showing a list of Configured organizations and Available organizations](https://media.jvt.me/a1eb90f855.png)
![The GitHub "New scheduled reminder" UI, showing the various types of real-time alerts that are available when selecting the "Enable real-time alerts" option](https://media.jvt.me/9066559915.png)
