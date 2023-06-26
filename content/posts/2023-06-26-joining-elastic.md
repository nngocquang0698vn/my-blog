---
title: "I'm joining Elastic"
description: "Announcing my move to Elastic as a Senior Software Engineer, and looking back at my time at Deliveroo."
date: 2023-06-26T18:24:56+0100
tags:
- "job"
- career
- roodundancies
- "deliveroo"
- "elastic"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "joining-elastic"
image: https://media.jvt.me/5e45b3ba99.jpeg
---
I'm very excited to announce that in August I'll be joining [Elastic](https://elastic.co) as a Senior Software Engineer, working in the Platform Developer Experience team.

I'm really looking forward to be focussing on internal development tooling to help engineers become more effective, and I'm already in love with the culture of the company and the folks I've been able to meet so far.

# My time at Deliveroo

My time at Deliveroo has been really great, and I'm so glad I took the role when I did. I've had a lot of fun working on a product I've been using for years, as well as building some key features and improvements to make things better for everyone.

It's been a really great opportunity to learn what it's like to work at true scale for the first time in my career, dealing with traffic across the globe, and scaling services for some pretty significant spikes, while trying to run things frugally.

I've also been leading a number of key cross-organisation initiatives, learning a lot, but also being able to drive some change around the way we think about and contribute to Open Source, keep our dependency updates more manageable with [Renovate](https://docs.renovatebot.com), and discovering what data we can mine from our usage of internal and Open Source dependencies.

In the case of working to understand how our projects use Open Source and internal projects, I've built [dependency-management-data](https://dmd.tanna.dev), an Open Source project that provides the capability to be able to get much more actionable data. In a few key ways it's been _much_ more effective than the tooling we pay GitHub for, and I've enjoyed having a long-running side project that's been providing a lot of value to the organisation. It's given us the ability to make more data-driven decisions around understanding i.e. the use of Terraform module versions or how the Go community would be affected by the archiving of the `gorilla/mux` package, through to quantifying what level of End-of-Life software is being used.

During my time at Deliveroo I've fallen in love with Go - to the detriment of other ecosystems I used to want to develop with - and worked on some key pieces to improve Go usage across the organisation. I've enjoyed being part of the Go community at Deliveroo, and more recently being part of the official Go team who works to guide and shape Go usage across the organisation.

Throughout my time I've worked with some really great folks, and so saying bye to a great group of colleagues will be difficult - I'll miss my team and a lot of the things I've built and contributed towards in the last year, but am very much hoping to stay in touch and that our paths cross again in the future.

There are still some really interesting engineering challenges that I'd be walking away from, and some incredibly talented people I've enjoyed working with, but it's time for me to move on. I'll be keeping an eye on [Deliveroo's engineering blog](https://deliveroo.engineering), which I've enjoyed being an editor on this last year, and hearing from colleagues who are still there to find out what interesting problems they're solving.

# Looking for what's next for me

The [redundancies Deliveroo went through](https://www.jvt.me/mf2/2023/02/airop/) at the start of the year was a big part of me leaving Deliveroo, as I felt the company that exists right now is very different to the company that it was at the time I'd joined. Like anyone going through redundancy processes, I had to take some time to consider where I wanted to go if the company decided I was no longer valuable enough to them.

As mentioned in [_I don't think I want my next promotion (yet)_](https://www.jvt.me/posts/2023/03/22/next-promo/), I considered that internal tooling - to make other engineers more productive - has been my calling and something I've gravitated to over the majority of my career, and with my newly discovered love for Go, I sought out roles that would give me both of these.

I'll likely discuss this recent job hunt in a separate post, but the TL;DR is that there weren't as many jobs out there as a year ago which made the hunt a little more difficult, not least because just over a year ago I'd gone through this process before, so had settled on Deliveroo being _the_ job I wanted.

Looking through various job boards, I spotted a job description that really appealed to me, at a company I knew and had a good appreciation for - Elastic.

# Building Tools

Tooling and developer productivity is something I've naturally gravitated towards over the years, so I'm very excited to be able to be working on this full-time, and getting some time to really deep dive into this as an area.

I'm looking forward to be working towards the developer experience of engineers across Elastic, helping ship better outcomes and building tools that can "get out of the way" of an engineer, so they can focus on the important things they're trying to do.

# Beyond remote working to a fully distributed team

Very early into my time at Capital One, I had been reading about GitLab's approach to remote working as a distributed team. I'd seen this as something I'd be very interested in working in at some point, but all those years ago, but didn't see it happening for some time.

During COVID, where companies were forced to not be colocated - but not doing "real" remote work, which includes the flexibility to work where you want, or at least meet up with your colleagues physically if you wanted - I got a taste for what remote work could be like. Even as life started to open up more, I found that office trips for Capital One or the Cabinet Office were good for social purposes or focussing on good in-person working, but that I found myself more productive at home.

Then, joining Deliveroo, I got my first chance to really work remotely. It's been a great experience, and I've really enjoyed the life-work balance that remote working has given me. It's been great to have the opportunity to work where suits me best, but still have the opportunity to see colleagues fairly frequently for in-person work.

On top of this being a fully remote role, Elastic is a fully distributed company, where my team is split between 4 countries across 3 continents with not a lot for timezone overlaps.

I'm really looking forward to working this way, and embracing asynchronous work, especially since my [ADHD Inattentive Type diagnosis](https://www.jvt.me/posts/2022/10/04/adhd/), where I've realised just how much I appreciate asynchronous working.

# Culture + interview process

I've heard - before and through the interview process - that the culture at Elastic (also called its ["Source Code"](https://www.elastic.co/careers/our-values)) is really good. It seems like a super chill company, giving folks the opportunities to do their best work by providing space to do the work while fitting work around your life.

I reached out to some of the communities I'm part of for some corroboration, and found that it was absolutely a representation of the culture, which was great to hear.

I feel like a lot can be said about a company by the way it treats prospective hires, and I only got good vibes through the process.

There were 3 interviews, one with my new manager, two technical with Principal Engineers on my team. Between the first interview and the result it took a whopping... 7 days. You did not misread that, it was _super speedy_. We all wanted to move quickly, so I made sure that I could slot the interviews in quicker than usual, but the fact that Elastic were also super flexible, and so quick at letting me know the outcome was so encouraging. After some interview processes with hundreds of rounds and weeks between each stage of the interview, it was super refreshing to be able to go through the process so quickly.

For the technical interviews, there were general questions around how I'd fit into the job, understanding my experience with building tooling, working on CI/CD pipelines, as well as each of them had a specific angle on them.

For the "coding interview", I was asked ahead of time to share some code with them, and we'd go through it, talking about choices I'd made and that I could impart some knowledge about it. Being able to share a project I've been working on, so of course I used [dependency-management-data](https://dmd.tanna.dev), my latest passion project and that was a command-line tool similar to some of the work we're doing in my new team. We talked about the project, some of the design choices, and some areas I'd look to redesign if I had the chance. The "systems design" interview was talking through how I'd design a command-line tool for two purposes, and then I discussed some of the pros and cons of different solutions.

I'd also like to note that all communications from Elastic have been truly excellent, and a massive set of props to my recruiter 🙌 This was a huge insight into Elastic's culture, especially for one being a distributed company, and how I would be best reached through asynchronous emails rather than hopping on a call to give/receive feedback on the process.

It was also really nice to have an offer letter that writes glowing things about you rather than hearing it over the phone!

# Closing

I'm really looking forward to starting at Elastic and working full time on building tooling and internal developer products, as well as working more with these wonderful group of folks.

I'm also unreasonably excited to be able to be using a Linux machine for my work, after having the option at the Cabinet Office, especially to get away from Mac being not-quite-right - despite my [attempts to make it more Linux-y](https://www.jvt.me/posts/2020/04/11/bad-posix-citizen/) over the years.

As ever, my salary will be public and transparent, so you'll now see Elastic's entry in [/salary/](/salary/).

I've had a great time at Deliveroo, learned a tonne, and had some great opportunities to grow and blogument some interesting learnings, and am really looking forward to the next stage in my career at Elastic!

Keep your eyes peeled for many future posts about my `#LifeAtElastic`.
