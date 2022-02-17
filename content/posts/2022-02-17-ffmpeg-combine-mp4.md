---
title: "Combining an Audio-only and Video-only MP4 with `ffmpeg` on the command-line"
description: "How to use `ffmpeg` to combine two MP4 files, where each file contains audio and video separately."
tags:
- blogumentation
- ffmpeg
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-17T08:54:37+0000
slug: "ffmpeg-combine-mp4"
syndication:
- "https://brid.gy/publish/twitter"
---
Last night, I was downloading videos from Facebook, and found that they're sending their audio and video streams as separate, chunked responses.

I wanted to combine these, which fortunately is pretty trivial to do so using `ffmpeg`, thanks to a hint from [this thread on SuperUser](https://superuser.com/a/277667):

```sh
ffmpeg -i video.mp4 -i audio.mp4 -c copy out.mp4
```

See the thread above for other cases, such as when you want to reencode the audio, or replace the existing audio stream.
