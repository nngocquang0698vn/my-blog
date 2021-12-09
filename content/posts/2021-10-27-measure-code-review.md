---
title: "Improving Team Efficiency By Measuring and Improving Code Review Cycle Time"
description: "How measuring how long code review took as a team lead to being able to change our processes, and then deliver much more effectively."
tags:
- practices
- github
- code-review
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-10-27T22:11:07+0100
slug: "measure-code-review"
---
(Because this was almost a year ago, I unfortunately can't remember the exact metrics or numbers - sorry in advance if things are/aren't as impressive!)

# Why Did We Need To Improve Code Review Speed?

Last September, I started a new team at Capital One, the Purple Pandas, where I was the Tech Lead. As a newly formed team, we naturally spent some time investing in, experimenting, and improving a set of shared principles for how we wanted to operate as a team, and over our first quarter (Project Iteration aka PI) we had a few projects to work on to give us some good experience as a team working together.

Before starting the new quarter, we ran a retro for the previous PI, where we reflected on a number of things about how we built up better cohesion as a team over time, as we tried out new things, and gelled more as a group, as well as looking at what we could learn to improve the next PI's work.

While we discussed the previous PI, one thing that was noticeable was that we felt that something slowing down our delivery at times was code review.

Being in a regulated environment, there is a higher bar for making sure that a single developer cannot push malicious/broken code to production, so code review by at least one other person is mandatory. On top of this, I'm personally a huge fan of the benefits that come from code review from a diverse group, in addition to the recommendation of pair programming for real-time code review, so we upped the review requirement to two people, which was comfortable given we had a team of ~8 at the time.

Because of this requirement, each story, which may be broken down into multiple Pull Requests (PRs) to improve visibility of changes, would need two reviews, which would lead to us being slower as a team.

Because I wanted us to embrace "facts not feelings", I put some time aside and invested into scripting a set of metrics we could use to discover whether this was actually the problem we thought it was.

Fortunately we only had a couple of repos that we worked on, and it was only our team working on them, so all I needed to do was search for PRs after our team took ownership. Unfortunately this wouldn't quite cut it, as there were PRs related to in-sprint delivery, and then there was out-of-sprint work, such as enhancements that were picked up as 10% personal project time, and therefore wouldn't be as high priority.

As part of our initial team forming and ways of working, I mentioned that in one of my previous teams, Asgard, we'd used GitHub projects to better visualise code review. One thing that made this good is that the automations functionality helped i.e. move PRs into a "being reviewed" column when being reviewed, but also, that we could have multiple projects.

In this case, we had one project for in-sprint and one for out-of-sprint PRs, which meant we could more easily filter down to just the specific PRs that needed to be delivered as part of our work.

With that in mind, I then utilised [the ability to filter GitHub project boards for PRs](/posts/2021/10/26/github-api-list-projects/), giving me the list of PRs that were sprint delivery. Next, I needed to look at what metrics would be of interest.

# Measuring

At this point, we now had a list of PRs that were sprint related, but we needed to think what metrics were important.

As the main reason for raising a PR was to get it merged, the most important metric was to calculate the cycle time - that is, how long it takes from a PR being raised to it being merged (or closed).

Next, we needed to look at whether certain members of the team were being more active than others, because it could mean that if certain members were unavailable, things would progress slower, so looked at who the first and second reviewer on a PR were, as well as the datetime for when that review was.

This then went through a few rounds of discussion with the team, looking at what other data could be discovered from the GitHub APIs, and then we started to calculate + graph the data.

I can't remember how long the cycle time was to start with, but let's say it was 3 days - but one sprint it was on average almost 5 days, which was half of the sprint.

# Optimising

So, we now had the cold hard data to say that things were progressing slower than they should be. What could we do to improve this?

The first improvement was to agreed as a team that code review for someone else's story was as important as delivering our own stories. We made sure our ways of working were updated to reflect this, and set ourselves a goal across the next PI to make sure that we would reduce the cycle time.

I think we gave ourselves a target of reducing cycle time by 20%, which gave us a measurable, meaningful target, and would shave off a considerable amount of time from the process if we achieved it.

We also sought to improve the way we communicated the code review requirements - I'd been keen on using GitHub reviews, tagging the team so we could [auto-assign members](https://docs.github.com/en/organizations/organizing-members-into-teams/managing-code-review-assignment-for-your-team), but it was highlighted that unlike me, people don't spend all their lives watching their emails for GitHub notifications, so we talked about alternatives.

Something that's worked in other teams we'd been part of is having a `-code-review` channel, where we could highlight things ready for reviews. Where we needed people to look at it more urgently, instead of waiting for someone to look at the channel, we'd explicitly tag them in Slack, so they'd get a notification, or tag the whole team's Slack user group.

Something that was also helpful was having a `-github` channel that would have a Webhook set up to highlight any PRs / PR reviews, so it was clearer what's happening across our projects.

Through a mix of team behaviour and technical changes, we ended up closing PRs, on average, (roughly) 2 days cycle time - a huge improvement, smashing our target.

# Learnings

So what did we learn?

## Measurement is good

We learnt that measuring things is good. Without the raw data, we couldn't meaningfully discuss the process, or give us a meaningful way to deliver change.

Additionally, by regularly reviewing the data at sprint retros, we could keep on track, and further understand why a given sprint's cycle time may have been lower or higher than expected.

## Code Review Assignment is Not Equal

We definitely found that certain members were much more active than others. As the Tech Lead, part of my role is to support engineers with their contributions, guiding to improvements where possible, and celebrate good work too. This meant that naturally I'd be wanting to participate more, especially in a new team where my views of what "good code" looks like wasn't yet clear to the team, but also because I'd want to help with coaching.

That being said, even since being a junior engineer, I've still been very invested in giving prompt feedback for code reviews. I've seen the pain that waiting days for a review can cause, and so have got into an (arguably not) good habit of dropping what I'm doing to prioritise others' code reviews.

(It actually came up in my leaving speech how much I loved doing code review 😂)

We also found that one other member was particularly active, and although beneficial, there was the risk that a couple of members being overly active would lead to others being less active - leading to them not getting as much say in the codebase, as well as oversight and ability to learn what others are doing and how they're approaching problems.

## "Days taken" isn't a perfect metric

Code review holding you back when you're itching to ship something to production is the worst. So, in the absence of pair programming, we would look at having a Draft PR on GitHub to make sure that we could receive early feedback, while things are still being formed, rather than recommending a re-architecture on the penultimate day of the sprint.

However, these draft PRs would lead to the metrics not looking as good, as we may get a PR raised early on in the sprint, while the work is still very much being worked on, but not closed until later. One thing that helped with this is that we continued to use this as a chance to use smaller PRs where possible, so there were smaller chunks - or at least atomic commits on a PR - to review more easily.

The "days taken" metric also didn't take into account weekends, bank holidays, days that the team wouldn't be available such as 10% day, or on training. We found that because it was a consistent calculation it worked, but we made sure to communicate that it wasn't necessarily an exact number.

## Common Investment is Beneficial

We found that this worked really well because as a team, we were all invested in the same overall goal - get our stories delivered to customers.

However, when you're maintaining a project that multiple teams contribute to, measuring these metrics may not be quite as beneficial, because you'll have different priorities, and it's much harder to have a cross-team expectation of prioritising code review, when it's another teams' delivery being blocked, not yours.

## The Original Problem Was Not Just Time Taken

Some of the delays we saw in our first PI was also absolutely that, even though we had set a "technical ways of working" up, it wasn't quite as nuanced as it may need to be for the practicalities of real delivery, and that there was still a bit of back-and-forth on PRs. This was because I'd still not made it clear what I expected of the team, and it took us some time to get there.

Once we'd gone through a few chunky pieces of work, and started breaking down PRs into smaller chunks for easier, and quicker, code review, we were able to avoid "please refactor this architecture".

# Closing Thoughts

I'd be interested to hear your thoughts - especially after you've tried it, and whether it makes the same differences we found, or whether there are other factors at play. These were my experience, and this may or may not work for you as well.
