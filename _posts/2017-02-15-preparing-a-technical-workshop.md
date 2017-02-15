---
layout: post
title: Preparing a Technical Workshop - A Checklist
description: What you need to remember to ask the organisers and what to consider in order to ensure you __??__.
categories:
---

There are a number of things that you need to know ahead of making a technical presentation. These have come out recently as part of preparing for the [InspireWIT 2017][inspirewit2017] conference at Capital One, but also leading on from previous presentations I've made. In order to make it easier for others to start on a presentation, I've documented them below.

## General Admin

- What is the workshop title?
- What is the workshop description?
  - Does it provide enough insight for someone who's never coded before?
  - Does it provide enough insight for someone who's well versed in the topic?
- Do you know how long your workshop will take?
	- Do you know how long the workshop is _meant to_ take?
	- Do you know if people will arrive on time? I.e. if it's after lunch, people may arrive a bit later
	- Do you know how many people are attending?
	- Do you know what level of knowledge they are at? I.e. beginner, advanced

## The Machines

- What OS are provided machines running on?
  - Are you comfortable with that OS?
  - Are you comfortable providing technical assistance for attendees?
- Can attendees use their own machine?
  - If attendees use their own machines, can/will they preinstall software?
	- If attendees use their own machines, will you be comfortable providing technical assistance?
- Can the presenter use their own machine?
  - If presenting on own machine, do you have the right AV components?
  - If presenting on own machine, do you have the right network access?

## The Format

### Presentation

- Can you run your slides on any machine?
	- Or do you need it to run on your own machine?
- Can the attendees access the slides?

### Workshop

- Are you writing code?
	- What editor should people have to use? Does it matter?
	- What IDE should people have to use? Does it matter?
	- What language are you writing in?

## The Demographics

- What level of knowledge does the talk expect of the subject area?
- What level of knowledge does the talk expect of the language used?
- What level are you pitching at?
- What are the demographics of the attendees at the event?
- What are the demographics of the attendees at the workshop?
- Ask questions at the start of the workshop to gauge level of knowledge and adapt accordingly
  - Plan content to be suited to low, medium and (potentially) advanced attendees, with the option to skip chunks of content


## The Dependencies

### People

- Will you need volunteer helpers to make sure there is help around?
- Will you need volunteer helpers that know the tech you're playing with?

### Tech

- What dependencies will you need?
	- Can these be pre-installed to save download time during the workshop?
	- I.e. do you need NodeJS? If so, what version?
	- I.e. do you need `expressJS v1.3.2`?
	- I.e. do you need IntelliJ?
- Are there any other dependencies you can think of that you _may_ need downloaded as part of the workshop?
	- Can these be pre-installed to save download time during the workshop?
- What language-specific tools will you need?
	- I.e will you need `IDLE` for Python development? Will you need PyCharm?
- Will the workshop require a stable internet connection?
- Will the workshop require access to online resources?
- Will the workshop require any existing online accounts?
	- I.e. an email account, Facebook account
- Will the workshop require signing up to an online account?
	- Will the attendees know ahead-of-time?
	- How will this work for minors who need parental guidance?
- Can the workshop be done on a tablet or phone?
	- If so, how will they install required tools?
	- Are the tools ones that have been researched by the presenter?
- Will the attendees require a tablet or phone to test on?
- Are resources at some easily accessible URL such that attendees don't have to copy down long URLs into their machines?
- What if I can't get software installed in time?
  - Is there an online IDE I can use?
  - Can I spin up a VPS that has temporary access?
		- Why not check out [`workshopr`][workshopr]?

[inspirewit2017]: http://2017.inspirewit.com
[workshopr]: {{ site.baseurl }}/projects/workshopr/
