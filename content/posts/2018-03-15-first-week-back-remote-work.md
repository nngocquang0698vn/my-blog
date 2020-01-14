---
title: My First Week Back to Working (Remotely) After Three Months
description: How I've found the first week back to work after almost three months, and the productivity gains of working reduced hours.
tags:
- thoughts
- capital-one
- spectat-designs
image: /img/first-week-back-remote-work.png
date: 2018-03-15T17:57:35+00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: first-week-back-remote-work
---
After almost three months off work, due to my [Ruptured Appendix][ruptured-appendix], I started working again last week, albeit with reduced hours.

At the beginning of March, I was cleared to remotely return to work by my consultant, on the condition I would only work for a maximum of four hours a day to ensure that I wouldn't be pushing myself. Last Thursday I organised to meet with my manager Gareth, who was coming to London for a couple of days for some workshops, and would be able to bring my laptop for me. Not only was it my first excursion where I was in a busy place with a lot of people, but it also gave me some contact with someone other than a handful of family who I'd seen over the last few months.

Over the course of an hour and a coffee, Gareth and I had a good catch up over everything that had been happening over the last few months. There was a big deadline that I had started working towards before Christmas, but with the timing of my operation, I wasn't able to help see the work through. The team did really well getting the work into production last night, which was an even bigger achievement given the team was pretty low on capacity, with some internal moves, and me out of action. We also got a chance to talk about some of our upcoming projects, which gave me some context for what the next quarter may look like.

As part of looking ahead, we discussed the work I'd be picking up. Firstly, due to the End of Life of Chef 12 support, we'd be upgrading to Chef 13. Fortunately I had [already started this process][chef-13-upgrade] with the Chef infrastructure for [Spectat Designs][spectatdesigns], my web development company, and therefore was aware of the required changes we'd need to apply to our internal cookbooks. Secondly, I'd be looking at putting together a more involved runbook for our production services, which would aid the on-call support aspect of the team's duties. These were both tasks that I would be able to work flexibly (when I needed to), as well as meaning I wouldn't be blocking the rest of the team on their work if I needed some slower days at work. It was also a great opportunity for me to pick up on the changes that had been happening in my absence, the details of which I was mostly unaware of, aside from the occasional checking of Pull Requests.

Not only was it great to see Gareth, but it was a really nice change having a little normalcy back, and really nice catching up and hearing how the rest of the team were, as I'd been missing them quite a lot recently.

![My work Macbook Pro + Packed Pixel setup](/img/first-week-back-remote-work.png)

On Thursday I worked through my compliance business training, armed with my [Packed Pixel][packed-pixel] to monitor the billions of updates I had pending. With the boring tasks done, this left my Friday hours free to plan the Chef and documentation work that I'd be undertaking. On both days, I didn't even make use of my full four hours, and when I closed my laptop for the day, I also turned off my work phone. This was a big step for me, given the last few weeks I'd been keeping an eye on Slack and emails, missing work quite a bit. But now I was actually officially working I found it was nice to be able to turn everything off for the night, knowing the next day it would still be there for me.

I've found the last few days really productive partly due to the fact that I've been working half hours. I've found that being time limited in a much more restrictive way has meant that I'm much more careful as to how much I try to fit within my four hours. For instance, where I know I only have a half hour of my time left, I won't try and pick up some new work, and will instead call it a day. This is quite a big change compared to before Christmas, I'd maybe just work a little extra that night to get the new task done (which would sometimes turn into hours).

I also feel like the refining of work has been a little better, where I've been able to decompose tasks into much smaller, bite-sized pieces of work which I can more easily stop and start on. This approach has been really quite satisfying, as I've left each day feeling happy with the amount I've achieved.

I've also been really enjoying the split between work and my own projects. Up until I was cleared to work, I had been able to invest some time into [Spectat Designs][spectatdesigns], whose infrastructure I'm Chef-ifying as well as also bringing more automation around VPS provisioning. This has been a project on my backlog for a number of months, I'd just always had more pressing projects to work on, which bit me when my VPS had a hypervisor issue, and I lost all my config - fortunately I had backups, but they meant ~4 months of loss of data and configuration. Having this free time to sink into it has been a rewarding experience, and has helped give me some drive to get it seen through to a state where I'm happy to start using it. I'm now in a place where I just need to automate the deployment of configuration, at which point I can configure a full staging server before migrating my live sites.

This newfound productivity links in quite nicely to how I want to improve the use of my personal time - it's showing that even with limited time I'm able to get a lot done, I just need to work a little more intelligently.

However, yesterday I ended up doing closer to a full day of work - quite the opposite of what the doctor ordered. That being said, I had been working outside of work on creating a Ruby Gem for sharing Rake tasks (of which I am currently drafting a blog post) which I was then applying at work, due to some repetition across cookbooks. As there were "just a few things" left to do before closing for the day, I decided to carry on with it, rationalising it as that I would be doing similar work outside for Spectat Designs, so I wouldn't exactly be resting myself. I know I shouldn't have been overworking, and therefore I'm going to be more careful in the coming weeks.

Overall I've been finding it a nice ease back into work, with the pacing almost identical to the Chef work I was doing outside of work, while also feeling incredibly productive both with work and my own side work, which has really helped. I now just need to hope that my wound heals quickly so I can get back to the office soon!

[ruptured-appendix]: {{< ref 2018-02-14-2017-in-review >}}#ruptured-appendix
[chef-13-upgrade]: {{< ref 2018-03-06-chef-13-upgrades >}}
[spectatdesigns]: https://spectatdesigns.co.uk
[packed-pixel]: http://packedpixels.com/
