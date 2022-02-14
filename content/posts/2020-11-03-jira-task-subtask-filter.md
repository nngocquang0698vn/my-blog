---
title: "Filtering Tasks and their Subtasks in JIRA"
description: "How to filter issues, and their subtasks, with JIRA Query Language."
tags:
- blogumentation
- jira
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-11-03T13:14:33+0000
slug: "jira-task-subtask-filter"
image: https://media.jvt.me/e9aa0d87a6.png
---
On my JIRA sprint board at work, we've got a set of stories which have subtasks, which are then prioritised using JIRA's priority. However, to make standup a bit more effective, I set up a filter that could allow the team to look at stories that were highest priority first.

Unfortunately this didn't seem to work, as it seemed to filter away any of the subtasks that were present on the board by doing a filter based on:

```
(priority = Critical OR priority = Blocker)
```

However, I was able to find that using [Udo Brand's suggestion](https://community.atlassian.com/t5/Jira-questions/Re-Filter-to-pull-subtasks-when-status-of-parent-in-quot-See/qaq-p/803286/comment-id/259001#M259001), we can use `issueFunction in subtasksOf`, as below, which now filters correctly:

```
(priority = Critical OR priority = Blocker) or (issueFunction in subtasksOf('priority = Critical OR priority = Blocker'))
```

As noted by [Piotr Polak](https://community.atlassian.com/t5/Jira-questions/Searching-for-subtasks-of-parents-that-meet-certain-criteria/qaq-p/39736#M16861) this is only available if you use the Script Runner JIRA plugin - sorry if you don't have that available.
