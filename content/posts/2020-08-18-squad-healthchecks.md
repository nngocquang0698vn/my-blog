---
title: "My First Experience With Setting a Squad Healthcheck"
description: "Documenting a squad healthcheck I ran last year, and the good learnings that came out of it."
tags:
- squad-healthcheck
- technical-leadership
- leadership
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-08-18T14:13:57+0100
slug: "squad-healthchecks"
series: squad-healthcheck
image: https://media.jvt.me/7df11d59e4.png
---
Keeping an eye on your team is really important. Knowing how your colleagues are doing is key to being a better team, regardless of whether you're friends, a manager, or a direct report. It is only through everyone in the team being invested in each others' mental and physical well-being that the team can move forward (especially in the current Coronavirus situation).

Within Capital One, we have a more formal, business-wide, set of surveys to keep on top of this from a high level, and the team should be able to share concerns within standup, one-to-ones with their manager, or a sprint retrospective. But this doesn't always work for everyone, as they may not feel they can be vocal about what they want to say, or they may be having a bad day in the middle of the sprint, but be over it by the time retro comes along.

If we miss out on these issues, we can lose out on opportunities to better help our team.

A couple of teams I work with use a regular check-in process called a "healthcheck" which is targeted to gain more regular insight into the team's health. These healthcheck are generally based on [a Spotify model](https://engineering.atspotify.com/2014/09/16/squad-health-check-model/) which describes a way to keep an eye on how teams are doing. Spotify does this across many squads, which allows them to determine where specific squads are having issues, but we use these healthchecks less formally and more ad-hoc.

This is something I'd been interested in getting started in my team at the time, but hadn't really had the kick to do it until I was listening to <span class="h-card"><a class="u-url" href="https://twitter.com/thatagile">Tom Hoyland</a></span>'s talk at [DevOps Notts](https://www.meetup.com/DevOps-Notts/events/262473868/) last year ([there was a recording of this talk at DevOpsDays London 2019](https://www.youtube.com/watch?v=v-fZfiVxX6Q), or if you prefer text, I [wrote up his talk](/posts/2019/10/12/devopsdays-london-2019/#building-and-growing-an-agile-team)). Tom shared some of the great things that can happen when you've got access to metrics for your team, as well as the extra observability on team morale, and I decided I needed to start it with my team.

So why am I writing about this now, over a year later? Well, I was pretty happy with the healthcheck I came up with, and I wanted to share it at the time - but forgot - and also because I'm just starting to look at a new one with my current team and I'd like to have this out there for feedback.

# The Healthcheck

When setting up this initial healthcheck, I decided that I wanted to dig into a few areas that I knew were key for the team, and it'd be good to have some data to back up conversations, in particular around whether we felt we were in control of our delivery, and around how happy the team was with the codebases we were working on.

I personally had a few requirements for the healthcheck that I wanted to use. Firstly, I wanted it to be fully anonymous as I wanted the team to feel comfortable sharing open, honest feedback. If there was any chance for team members to feel like they'd be reprimanded on their comments (whether there was base to that thought or not), they'd not want to share openly, so I ensured it was anonymous by making sure that Google forms did not record who was submitting the form, and gave the team the confidence that it was anonymous.

I also made it a conscious choice to remove any in-between option for each of the questions. I wanted to make sure that members of the team (like myself when filling out surveys) couldn't be lazy and just pick the middle option, and instead had to think whether there was a positive or negative slant on their feelings.

The healthcheck itself was composed as a Google form, and on Tuesdays and Thursdays I put in a 5 minute calendar event in the team calendar, and I would also nudge the team to fill it in. This meant we had four data points a sprint, per person, and didn't feel like overkill of nagging people every day for more detail, but also felt like it wasn't too little information to share.

## Blurb

I started the form by giving a bit of blurb for folks who were coming to it fresh:

<blockquote>
As part of my Scrum master duties, I’m implementing a “health check” survey. I’ll book in 15 minutes a few times over the sprint in which I’d like everyone to please fill in an anonymous survey around how they feel we’re doing.

This is a health check based on https://labs.spotify.com/2014/09/16/squad-health-check-model/ which is going to be used to gauge the health of the team, and give us some metrics across the sprint of how we’re doing.

I’ll monitor the number of responses, but won’t be checking the data until Retro, where I’ll spend a bit of time looking at how people feel over time.

There are purposefully only 4 answers, so you can’t say “meh”, but have to go one way or another on how you feel.

If there’s anything you want to add to the list for the next sprint, we’ll talk about them at retro
</blockquote>

## Questions

The team was asked to choose the option that best captured their feelings at the time for the below questions:

- Dependencies
  1. We had no dependencies whatsoever / the dependencies we had were incredibly low-touch and easy
  1. We had dependencies that were mostly resolved, and not too much of a burden
  1. We had some dependencies that started to make things slower to deliver than they should have
  1. Our dependencies blocked our delivery completely
- Codebase health
  1. Our codebases are full of high-quality code, with zero tech debt
  1. Our codebases are mostly high-quality code, but there is tech debt and old patterns that we need to make better
  1. We're not very happy with the code quality of our codebases, and we need to get rid of some of the cruft
  1. Our codebase should be rewritten, because there's no hope in restoring it to any semblance of glory
- Learning
  1. I've learned some really amazing things, and feel invigorated with my new knowledge
  1. I've learned a couple of things, but still feel like I'm not doing that much new work
  1. I'm not feeling like I'm doing anything new or different
  1. I feel like I'm wasting my time and just doing boring commodity work
- Fun
  1. I don't sleep at night because I'm too excited to get to the office to spend it with my team
  1. I enjoy working with the people in my team, and I feel we have fun
  1. The team dynamics are ok, but don't really make me feel as happy or engaged as other teams
  1. There is a very unfriendly environment and I'm not happy
- Pawns
  1. I feel I have very strong ownership of what is happening and that I can make a difference
  1. I have some good ownership of delivery, but there are some things out of my control
  1. I don't really feel like I get a chance to own anything
  1. I have no idea what's going on outside of the given sprint and don't believe I can do anything about it
- Pace of delivery
  1. I felt we could've taken on way more work, because we smashed through everything we had really quickly
  1. We had a good amount of work, but at times it felt like we were rushing a bit too much to deliver
  1. We're moving too quickly, with too much work committed to, to be sustainable
  1. We've started to incur serious burnout as a result of the pace, and we need to stop

# What did I learn?

So what did I learn? Unfortunately I won't be able to share the data itself, but it helped me have confidence in my assumptions of how the team was feeling, and having the data visualised was super interesting. For example (using fake data):

![a pie chart visualising the breakdown for one of the answers](https://media.jvt.me/429d1b84ef.png)

It highlighted a case of a team member being pretty unhappy, and also showed that as a team we weren't engaged as other teams, which is clear as next to us sat a team that were always having a great time working with each other - it's hard having such a clear difference between teams in morale.

One bit of feedback I had was that this was not "actionable", to which future versions will have a "comments" box for each section, so folks can provide their thoughts if there's something specific to add.

We only ended up doing this for one sprint (partly due to the above comment about it not being "actionable" enough) but in that sprint I actually learned a tonne about the team, and helped surface some real issues that were not made obvious during regular ceremonies/one-to-ones.

However, I also learned that this is not enough time to run this from, and I'd really want to run this across a whole quarter, and at the end of the quarter we'd be able to look at the data, and see how things changed over time. This would help us be able to gauge how the team's morale changed over time, and we'd be able to see if it correlated with significant events such as production issues, successful releases, or team fun days.

I personally found that having no middle ground worked, and didn't have any feedback to the contrary about it.

# Feedback

Do you run your own healthchecks? What works well with yours that you'd recommend? What could I make better with this one?
