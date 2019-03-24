---
title: Leaving BTRFS as my primary filesystem
description: Why I'm moving away from using BTRFS as the primary filesystem on my personal devices, and why it had nothing to do with BTRFS itself.
categories:
- thoughts
tags:
- thoughts
- linux
- btrfs
date: 2018-12-22T00:00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: leaving-btrfs
---
I've been happily using [BTRFS] as my main filesystem for almost 3 years. However, I'm looking to retire my usage and replace it with a more boring filesystem.

**Note**: Before I continue, I would like to call out the fact that the decision is *not* to do with anything wrong with BTRFS - I've had a great, stable, time with it, and the reason I'm moving is due to my misuse of it.

The announcement that [Dropbox were dropping support for any non-ext4 filesystems][dropbox] started me thinking about my usage of BTRFS, and realise that it actually wasn't as important to my life as I thought.

I started using BTRFS when I got my Dell XPS 13 (9343), and the process of installing Arch Linux on it. Before that, while I was on placement at Intel, I had been using a Lenovo IdeaPad Yoga Pro 2 which started with Ubuntu, but I migrated to Arch after spending too much time on [/r/UnixPorn (Safe for Work)][UnixPorn].

I'd kept with the safe option of EXT4 with the Yoga, but as I was planning the install on my XPS, which I knew would be more of a long-term device, I had the opportunity to spend a bit more time researching options around the filesystems, disk partitioning schemes, package managers, and all sorts of other choices you wouldn't normally care about.

It was all new to me so I talked it through with my group of friends, who were all quite diehard GNU/Linux people, and they mentioned about this filesystem called BTRFS.

I thought it sounded really quite awesome, especially the ability to rollback versions of the Operating System in case of package upgrades breaking as I'd heard was quite common with Arch (sidenote - I've only had a couple of breaking issues with my time on Arch, and they've both been due to me being an idiot!).

BTRFS was also Copy-On-Write which would make disk operations quicker and potentially more efficient for duplicating data.

So I did some DuckDuckGo-ing and found some articles around which talked about how to install it. Looking through them, they had different approaches for how to set up the subvolumes within the filesytem. Subvolumes allow for partitioning data further, i.e. having a separate `/home` subvolume. This was good for me, and following an approach of one of the articles, I ended up with a layout like:
```
__active
  ROOT
  home
__snapshots
  2017-11-12-pre-install
  2017-11-12-post-install
  ...
```

I didn't actually need to use the snapshotting functionality of BTRFS for my `/home` folder, but decided that the Copy-On-Write capabilities would be useful, otherwise I would've kept it on EXT4.

When moving to having two SSDs in RAID for my desktop's OS drives + `/home`, I also ported that to BTRFS.

Before performing system upgrades, I used to I used to manually perform snapshots before and after, but soon found that I could utilise [`snap-pac`], which hooked into the Arch package manager, `pacman`, integrated in with the snapshotting tool [`snapper`] to provide the same functionality. This gave me a great deal of comfort of the fact that I'd have my ability to recover from system instability by just rolling back to a previous snapshot, as I'd have a copy of the system state _before_ I broke it with upgrades.

However, like all backup/restore processes, you need to test it often! The first time I tried to recover the system was when it had actually broken, which of course was a busy time where I kinda needed my desktop to be working, so found it to be a super stressful occasion.

While trying to rollback, I found that I didn't actually know how, didn't remember much about how it was all set up (and didn't know which article I'd followed); so basically I was screwed! I'd have to do it the old fashioned way, and debug what had happened and DuckDuckGo around to find out what the solution was.

I was using Dropbox as my primary sync tool (but mostly for my KeePass password manager database), so when news hit around their support being dropped, I was getting quite annoyed, thinking "hey, why are you making me choose?" but while thinking about it I realised that actually, I wasn't really using BTRFS for what I should be. The snapshots were great, but if I couldn't revert or interact with them in a meaningful way, what was the point? I was gaining a layer of misplaced confidence in my stability and opportunity for recovery which was just dangerous.

Finally, very recently I've been receiving a lot of IO wait, which has been bringing my pretty high end hardware to a halt. This has been a thoroughly unenjoyable experience, and led me through DuckDuckGo to find that it _could_ be due to BTRFS. I took the answer as rote, not doing any more research or verifying if it was the same issue I was affected with, but again, it made me think about how I'm not using the filesystem as I should be.

So I've come to the decision that I'll migrate away from it. To what, I've not yet decided, but it may be a boring EXT4, as it "just works", and I know where I stand with it. I just know that whatever I do go for, it will be something I'm actually going to take advantage of properly!

[UnixPorn]: https://reddit.com/r/unixporn
[BTRFS]: https://btrfs.wiki.kernel.org
[`snap-pac`]: https://github.com/wesbarnett/snap-pac
[`snapper`]: http://snapper.io
[dropbox]: https://itsfoss.com/dropbox-linux-ext4-only/
