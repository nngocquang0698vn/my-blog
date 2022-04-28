---
title: "Extracting Podcast Addict listening history from the SQLite database"
description: "How to get raw listening history from the Podcast Addict database."
date: "2022-04-28T21:04:10+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1519771446695841793"
tags:
- "blogumentation"
- "podcast-addict"
- "sqlite"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/28059848fe.jpeg"
slug: "podcast-addict-sqlite"
---
I listen to a lot of podcasts, especially recently where I'm finding it easier than listening to text-to-speech of my to-read list of articles, and I use the excellent [Podcast Addict](https://podcastaddict.com/).

As an avid believer of the IndieWeb philosophy of "own your data", I've been tracking more of my [listening history](/kind/listens/) on my site, which has been manually added when I finish a podcast.

However, I wanted to get my historical data so I could backfill it, especially as I still had backups from previous phones' listening history.

I wasn't aware that Podcast Addict had this functionality until I'd seen [this IndieWeb chat message](https://chat.indieweb.org/2022-04-21/1650574104708400). This got me looking, and I found that when enabling the [history view](https://podcastaddict.uservoice.com/forums/211997-general/suggestions/31873462-listening-history), we could see the date a podcast was played.

I wondered if, because the date itself was shown, it's likely that the full datetimestamp is in there, too, and it turns out there is, but you need to dig around in the SQLite database.

To get this, you need to perform a backup, and inside that backup there will be a `podcastAddict.db` SQLite database.

As of the app v2022.2.5, we can run the following query:

```sql
select guid,url,name,playbackDate from episodes WHERE playbackDate > 0;
```

This fetches key metadata for each podcast that has been listened to before, which for instance looks like the following:

```
https://martymcgui.re/2018/10/03/141113/||This Week in the IndieWeb Audio Edition • September 22nd - 28th, 2018|1552589356698
```

Notice that the final field is the `playbackDate` which is a Unix epoch in milliseconds, so we can [convert it to a human date by using `date`](https://www.jvt.me/posts/2020/01/14/ruby-parse-unix-epoch/), once we've divided by 1000.

I've found it a little frustrating to see just how many podcasts don't have predictable, or even stable, permalinks for the `url` field, and understandably their `guid` isn't necessarily a URL.
