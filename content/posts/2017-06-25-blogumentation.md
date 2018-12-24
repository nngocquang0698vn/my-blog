---
title: Blogumentation - Writing Blog Posts as a Method of Documentation
description: Why I'm starting to use blog posts as a form of documentation, and why I think they're so well suited.
categories:
- musings
- thoughts
tags:
- musings
- blogumentation
- thoughts
date: 2017-06-25
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
---
You may have noticed that recently I've been writing more articles, often tagged under [`blogumentation`][blogumentation]. These short articles are concerned with documenting a piece of information about certain workflow-enhancing tips, and I find they fit under a term I have coined `blogumentation`, that is, blog posts as a form of documentation.

I believe that blog posts can be better suited for documentation than a wiki for cases where it helps to have more of a narrative as to _why_ you'd want to do something, rather than just the "this is how you do it". Of course you have to be careful not to make it a large wall of text, ensuring that it is also possible to skim-read and extract out the required tidbits to complete the task.

# Context

This stemmed from listening to a [podcast on *The Changelog* about 'Open Source at Microsoft, Inclusion, Diversity, and OSCON'][sh-changelog] with [Scott Hansleman][sh]. In the interview, Scott mentions how he receives questions via email fairly regularly. Interestingly, instead of replying to the email directly he instead writes a blog post and then replies to the email with a link to the post. Scott goes on to describe how he is constantly aware of [the number of keypresses he has left in his life][keysleft] and therefore has taken the approach to not want to waste a single one of them.

As someone who loves reducing repetition, this approach greatly appealed to me. Reflecting on this, I found that I should take this view for documenting my own learnings, as well as the following reasons:

# To Share Knowledge

First and foremost, I like sharing knowledge with others. Finding a way to solve a problem or automate an repeated process makes me happy, and sharing that knowledge and time-saving gives me the warm fuzzies.

Thinking about the many tips and tricks that I've collected over time and how I've found myself sharing them with colleagues and friends, I realised that having them stored somewhere that could easily be shared and updated over time, instead of being hidden in my dotfiles or memory, would be a great asset. This would also mean that these findings can be shared outside of my own social circle, allowing the wider tech community to benefit from my learnings.

These findings I'm documenting don't necessarily just include what I work on in my personal time - there are many things that I find while working, and that (in a clean room implementation) I want to share, as I can guarantee that it will be something that someone else will also find useful.

# As Self-Documentation

There are a number of tricks that I'll find I'm repeating maybe infrequently, such as [extracting certificates][extracting-certs], or processes that I want to have an easy to find "how-to" in the future, such as [how to run systemd inside a Docker container][docker-systemd-article-issue], instead of having to trawl through search results to find _that_ result that answers the exact question. Being able to share a link to a process with documented steps/concepts, as well as references to sources of information is a useful source of documentation.

Additionally, I've thought of this as a way of documenting things for myself, so future me can still pick up forgotten learnings, again without having to trawl through results to find what I was looking for.

# For Promoting My Personal Brand

I'm also looking at this in order to promote my personal brand, and get my name and associated knowledge out there. By building up the number of articles and interesting content on my site, I can start to grow my impact and start to build up my name.

This has been helped greatly by [@TechNottingham][technotts-twitter] tweeting out articles, and [Emma's][twitter-emma] positivity towards my blogging has driven me to write more frequently. Posting articles to the [`#blog` Slack Channel][technotts-blog-channel] has also meant other members of the community are reading (and sharing) my articles, making it more widely read and promoting my brand further, as well as being able to share the knowledge.

This also means that over time I'll be able to collate a large number of articles, like a friend of mine, [Manthan].

# Call to Action

If you wish to hear me write about something, please [raise an issue on my issue tracker][issue-tracker], so I can then track it alongside [all the other TODOs I have][issue-board-article]. I welcome suggestions, and would be happy to share my thoughts and learnings.

[manthan]: https://manthanhd.com/
[sh]: https://www.hanselman.com/blog/
[sh-changelog]: https://changelog.com/podcast/249
[issue-tracker]: https://gitlab.com/jamietanna/jvt.me/issues
[issue-board-article]: https://gitlab.com/jamietanna/jvt.me/boards/320660
[keysleft]: http://keysleft.com
[extracting-certs]: {{< ref 2017-04-28-extract-tls-certificate >}}
[blogumentation]: /posts/categories/blogumentation/
[docker-systemd-article-issue]: https://gitlab.com/jamietanna/jvt.me/issues/151
[technotts-twitter]: https://twitter.com/TechNottingham
[technotts-blog-channel]: https://technottingham.slack.com/messages/C4WR48CTB/
[twitter-emma]: https://twitter.com/mrsemma
