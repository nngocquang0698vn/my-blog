---
title: Learn how to build tools
description: A guest post on Letters to a New Developer about learning to automate and build tools to progress in your career.
tags:
- letters-to-a-new-developer
- automation
canonical_url: https://letterstoanewdeveloper.com/2023/05/29/learn-how-to-build-tools/
date: 2023-05-29T07:57:24-06:00
license_prose: 'All-Rights-Reserved'
license_code: 'All-Rights-Reserved'
slug: learn-how-to-build-tools
---
<blockquote>This article was <a href="https://letterstoanewdeveloper.com/2023/05/29/learn-how-to-build-tools/" class="u-repost-of">originally published</a> for <a href="https://letterstoanewdeveloper.com/">Letters to a New Developer</a>.</blockquote>

Dear new developer,

Our jobs and lives are full of repetition, and one of the beauties of being developers is that we can take steps to automate away some of the repetition.

Learning to automate, or at least minimise, repetition optimises your work. You can get your tools or boilerplate code out of the way, and focus your work's unique benefits. Aside from automating the task at hand, removing repetition has a tonne of other benefits.

## Learn how to make small changes to make you more efficient

Something I've enjoyed over the years is improving my ability to complete tasks, whether that means learning a keyboard shortcut to save clicking around a couple of menus, or learning parts of git I wouldn't usually use. Observing repetitive tasks isn't just something that can improve your own life, but can be used to discover behaviours in your team or organisation that could be improved.

It's a little morbid, but <span class="h-card"><a class="u-url" href="https://www.hanselman.com/">Scott Hanselman</a></span> has written about [how you have a finite number of keystrokes you have left](https://www.hanselman.com/blog/do-they-deserve-the-gift-of-your-keystrokes) until you die, and so making small improvements to shave a few keystrokes here and there can allow you to save time to work on more meaningful things in your life.

Suppose  you're working on a project with Gradle, and you're consistently finding you write `./gradlew clean build` or `../../../gradlew test` a lot. A helper script could allow you to call g clean build, which works regardless of where in the project you're running from and saves you 9-16 keystrokes. Not to mention the small but present mental load of determining where `gradlew` lives.

Every improvement you make to how you work adds up, and before long can make you feel like you've got superpowers. It's a pretty fun outcome 🦸

## Learn more about your company, team, tools

As a newer developer in your team or company, finding areas to automate and improve is a great opportunity to find out why things are the way they are, as well as illustrating how to improve things.

One of the first widely used pieces of automation I built at my first company was a script to open a browser window pointing directly to the logs for our web application. This gave me a good understanding of how our web application worked and where and how logs were stored, and this script allowed engineers to much more easily load the latest logs for our web application without needing to search for the right CloudWatch log group.

There will almost certainly be areas of your teams' processes that could be better managed, as well as common tasks that could be automated (fully or partially). By looking at possible areas to automate, you'll get a much better understanding of how things work.

## Learn more and different things about your language

By building tools, you can learn more about how your language and tools work. As mentioned above, I built a tool to open the latest logs for our web application. This sounds trivial, it wasn't. It involved:

- Take an optional command-line argument for whether to use the test environment or production
- Send a GET request to a JSON metadata endpoint to get information about the app's AWS CloudFormation deployment
- Construct a URL to AWS CloudWatch log group
- Open the browser

My team was writing a lot of Chef cookbooks, which is a configuration management tool built in Ruby, so I opted for Ruby as a way to give myself a chance to practise it, and because I knew that the team would have Ruby installed.

This seemingly straightforward script gave me chances to learn more about and try out different approaches. For example, I wrote a smaller project to play around with debugging. I also tried different HTTP clients to compare them with what Ruby's standard library offered.

## Try something new

Building tools is an opportunity to try new libraries, new languages, and new technologies, especially as tools are often fairly small in scope and work required.

As a backend engineer who's been using Linux and the command-line for several years by the time I got my first job, I was comfortable building command-line tools. I'd got lots of experience building shell scripts, but wanted to build something with a bit more structure and with a standard library to rely on, so started scripting in Python and Ruby.

But as a backend engineer who focuses a lot on building tools for the command-line, every so often I build something web-based. This gives me an appreciation of different tooling, and lets me learn how to build tools that work for folks who don't necessarily want - or need - to use the command-line.

If you're an engineer who's used to always writing everything by hand, why not try a low-code tool, like IFTTT or Zapier? If you usually reach for a scripting language like Ruby or JavaScript, try a plain shell script to get a feel what it's like to not have a standard library to use.

## Learn how to build tools for others

Building tools forces you to learn about how to think outside of your own use case. Instead, you'll think about the user experience of the tool for people who aren't you .

If you are building a command-line tool, does it have a `-h` or `--help` flag? Do errors explain what's gone wrong, or does someone need to look at the source code to understand what's happening? Can you build it in a way that feels familiar - for instance, following conventions used by similar tooling - instead of defining your own interface?

The most important question is "does it solve the problem it's built for", which requires insight into the problem area as well as learning from others what they're trying to do with it.

Aside from making it possible for others to use, consider how you'll package the tool for installation or how others will access it.

For instance, are you assuming that everyone is on the same Operating System? Mac OSX's versions of tools are different to those on Linux or Windows. This means that you need to write tools to either be compliant with the different versions, or you document additional requirements for running the scripts.

How would you package a tool? If it's a shell script it may be self-contained, but what if it's a ~1GB set of files? If it's a web application, does it require someone to log in, if so how will access be managed? If it's using a scripting language, do you know what language versions will work with the tool?

Notice in my web application logs example above I used Ruby since I knew everyone would have it installed. I also knew everyone was on a specific version of Ruby, which made deployment even easier.

## Have fun

Finally, have some fun with it!

A friend of mine [paid for a new PlayStation 5 by setting up an automation to save 20p every time he tweeted](https://brunty.me/post/tweeting-paid-for-my-playstation-5/).

You too can do something interesting that doesn't have to be within the realms of work.

## How to get started

From the ideas above, does anything immediately jump out at you to want to pursue?

If not, a good start would be to write a shell function or alias to make it shorter to write `git add` or `git commit`.

Then, write a tool that takes a JSON file and pretty-prints it to the terminal.

Start with a language you already know, and see how you get on - enjoy!
