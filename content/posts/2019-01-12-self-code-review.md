---
title: "Performing Code Review on Your own Merge/Pull Requests"
description: "Why the first step to getting others to review your code is to review it yourself."
tags:
- blogumentation
- code-review
- workflow
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-01-12T16:22:38+00:00
slug: "self-code-review"
---
**Note**: The term "Pull Request" here is used interchangeably with the term "Merge Request", which are terms for the same thing between GitHub and GitLab. I follow this approach in both platforms, but to remove any confusion I will stick to the former.

In my first couple of months at Capital One, I needed a fair bit of support from other engineers to work on stories. But soon I was confident enough to pick them up without support, aside from pairing with another engineer to share knowledge.

After working on the piece of work myself, I would raise a Pull Request into `develop`, and ping a link to the PR in Slack so the team could see it was available for review. But what [Stephen Galbraith](https://lifewithcode.blogspot.com/) and co weren't ready for was the sight of me commenting on my own PRs!

The team made a little fun of me to start with, but after explaining why I was doing it, they relented because once they understood it, they could agree with the reasoning behind it - rather than it just looking like me talking to myself!

The reason that I like to review my own code is because firstly, it's quicker than waiting for another member of the team to get a chance to have a look at it. By the time the next team member comes to view it, they should see a refined PR, as it will have had a set of reviewing already.

Next, it ensures that I take a step back and look at the changes as a whole, rather than the commit-by-commit basis I'd been looking at before. This makes me consider anything that made sense in a smaller section, but does not make sense in the grand scheme of things.

This may not apply to you, because the way I work is I'll generally finish my implementation of the changes and then raise a PR without re-reviewing the changes as a whole. This means that this will generally be the first time I've considered the whole set of changes. This gives me a good chance to determine if there are sections that require better documentation i.e. code comments, and will be able to show to other readers what I've been considering.

I'll nitpick on the same things that I'd nitpick a colleague i.e. a newline is required at the end of a file.

Not reviewing my own code until I've raised a PR can be seen as an antipattern in some teams, but I find it to be quite a good way of doing it, because there's generally some delay to getting code review so it isn't as important that it's all correct and ready first time.

Also, by looking at it under the PR interface, rather than just comparing the diffs between versions, it allows me to add comments to the changes, which helps me make it very obvious to reviewers that I've picked up on an issue, or am at least thinking about something, as well as tackle my poor memory and make sure I have a required correction tracked. I'm very much of the mind that a PR should be a place to discuss openly, and to try and understand the why as well as the what (in conjunction with the commit messages).

On the topic of commit messages, I will raise follow-up commits for required changes. Previously these would be titled i.e `sq! 3e9f73`, but as per [_Using `git commit --fixup=` to track changes that need to be applied on top of another commit_]({{< ref 2019-01-10-git-commit-fixup >}}) I'll now be using `fixup` commits.

Once the changes themselves are happy to be signed off, I'll then perform a Git rebase to clean up the `fixup` commits, as well as rewrite commit messages and ensure all the important things are in there.

Although this example is practicing code review in a team setting, I also [review my own contributions to this website](https://gitlab.com/jamietanna/jvt.me/merge_requests), where I'm the only contributor.

If you're working on your own, you likely won't be getting code review (or won't even be thinking about doing it) but I would recommend trying it as a way to make it easier to understand what you're doing and as a way to start to think more critically about what you're writing.

I really would recommend you trying it out and seeing how it feels - although it can start off weird to comment on your own PRs, it can make such a difference to the PR that a reviewer will then end up seeing.
