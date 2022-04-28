---
title: "Building a fault-tolerant work queue for command-line executions with GNU Parallel"
description: "How to use `parallel` to create a lightweight work queue of commands, with retry logic and a record of what's been executed."
date: 2022-04-28T21:04:10+0100
syndication:
- "https://brid.gy/publish/twitter"
tags:
- "blogumentation"
- "command-line"
- gnu-parallel
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "shell-queue"
image: https://media.jvt.me/934679881f.png
---
I've recently been backfilling my listening history from Podcast Addict, which has involved [scraping the database](https://www.jvt.me/posts/2022/04/28/podcast-addict-sqlite/) and then converting the posts to [Micropub commands](https://www.jvt.me/posts/2022/03/01/micropub-go-cli/).

As part of this, I needed to script the execution of ~600 commands. I started off by producing a single script that could execute each of the commands, like so:

```sh
#!/usr/bin/env bash

micropub create form h=entry ...
micropub create form h=entry ...
micropub create form h=entry ...
```

However, this highlighted a number of cases where intermittent errors would result in a failure, and I needed to retry. This meant I needed to start recording what passed and failed, and then have some means for reading the in queue, and the failure queue, and remove successful entries.

To start off with, I simply manually retried the failed entries, but after maybe a couple of dozen, I grew a bit bored by it, knowing I had so many more to go.

I started to consider writing something for this in either Ruby or Go, feeling that it was just complex enough to need something a bit more thought out, but also surprised I'd not seen something like this before that I could utilise.

Fortunately, it turns out it is a solved problem, and my searching found that I could use [GNU Parallel](https://puntoblogspot.blogspot.com/2017/01/gnu-parallel-as-queuing-system.html) for this purpose.

This would allow us to run the following:

```sh
# on first run
touch joblist
# start the jobs
tail -f joblist | parallel \
       # if you want to throttle jobs
       -j1 \
       # if you want to make sure there are retries when commands fail
       --retry-failed --retries 3 \
       # store a record of what passes/fails, to allow rerunning and resuming where you left off
       --joblog joblog

# then, we can run i.e.:
echo "micropub create form h=entry ..." >> joblist
```

This is super convenient, and gives us a fault-tolerant solution, allowing us to retry errors, as well as resume where we left off with the jobs.

Because this is running with `parallel` we can also parallelise it well, for speed boosts!
