---
title:  Hacktoberfest 2016
description: A few words about my excitement for the start of Hacktoberfest, and some ideas on how to get started yourself.
categories:
- guide
- opensource
tags:
- hacktoberfest
- opensource
- freesoftware
- community
date: 2016-09-30
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: hacktoberfest
---
# On Hacktoberfest

[The month of Hacktoberfest has returned to us again][hacktoberfest-announce], thanks to the teams over at [DigitalOcean][digitalocean] and [GitHub][github].

For those of you who haven't experienced a Hacktoberfest before, it's a month long event aiming to expose more people to contributing to Open Source (software in which "source code made available with a license in which the copyright holder provides the rights to study, change, and distribute the software to anyone and for any purpose" [Wikipedia: Free Software][wiki-free-software]) / Free Software ("users are freely licensed to use, copy, study, and change the software in any way, and the source code is openly shared so that people are encouraged to voluntarily improve the design of the software" [Wikipedia: Free Software][wiki-free-software]) projects, henceforth referred to **F**ree and **O**pen **S**ource **S**oftware) for the rest of this article; the reward being kick-ass T-shirts (my favourite tech T-shirts without a doubt) and a bunch of cool stickers!

The task at hand is relatively simple; contribute four Pull Requests (the act of sending of your own personal changes) to any number of projects. This means that you need to find four different contributions that you can add to the project. This can be anywhere from documentation to a whole new set of functionality.

To register yourself to participate in Hacktoberfest, check out the [official site][hacktoberfest], and register with your GitHub account. This will pull your name and email address, and will allow the team behind Hacktoberfest to monitor your progress more easily.

# Getting Involved

## Example Contributions

As an idea of what sort of additions you can make, it may be worth seeing the range of Pull Requests I have made over the years.

### Smaller Contributions

For instance, below are some of the smaller Pull Requests I have made over time:

- I have fixed [broken links](https://github.com/HackerCollective/resources/pull/53)
- I have fixed an [incorrect version string](https://github.com/jeffkaufman/icdiff/pull/56)
- I have fixed various spelling/grammar mistakes:
	- [Seafile][seafile]: [`haiwen/seahub`][seafile-contrib-1] [`haiwen/seafile`][seafile-contrib-2]
	- [SamyPesse/How-to-Make-a-Computer-Operating-System](https://github.com/SamyPesse/How-to-Make-a-Computer-Operating-System/pull/18)

### Medium Contributions

I stumbled upon [`youtube-mpv`][youtube-mpv], a tool which allowed sending any given URL to the `mpv` media player on Linux by chance, but immediately started using it. I had been performing similar actions, but by manually calling the media player with the given URL. The program consisted of a basic web server, which upon being sent a URL, will then spawn an instance of `mpv`.

Once I had been using `youtube-mpv` for a few days, I started to notice things that could be enhanced; in the initial version I started using, you had to manually start the server and leave it in the background. However, this wasn't very useful for me, so I set up a service that would autorun it whenever I logged in. This was fairly basic, but would only work from a certain hardcoded directory in my user account. Therefore, I wanted to make it more generic, so I would be able to install it to a global directory, and then forget about it.

By making it more generic, however, I found that I wanted to be able to install and upgrade it much easier. Therefore, I created a `PKGBUILD`, which in Arch Linux is a uniform way of describing how a piece of software should be installed. This took advantage of the way that I would require a generic path, and made it much easier to share with others; so they could also install it, without using hardcoded paths.

However, my first contribution was actually a clean up of the code; I found that the author had created a version for Python2 and Python3, with the caveat that there was a huge amount of code duplication, and that actually only a few lines needed to be different. Therefore, I took my Python knowledge, and made it into one file. This file then would determine which Python version was running, and require the correct packages for each Python version. This patch made it much less likely for bugs to occur - having two different code files with different versions could result in a bug being fixed in one file and not the other. Note that this is a slightly contrived example due to the project having just over 100 lines of code, and not being incredibly complex. But that doesn't mean that in the future, the codebase wouldn't be much more complex.

### Large Contributions

One larger Pull Request I have made was to update the Continuous Integration infrastructure for the [MRAA Project][mraa] from Ubuntu 12.04 to Ubuntu 14.04.

As part of this update, I had to produce a number of steps; first I had to accustom myself to the continuous integration scripts that Intel used for the MRAA project. Having used [Travis-CI][travis-ci] before, it was merely a case of getting the actual testing scripts under my belt and learning why they did things like they did. As I knew a couple of the developers, I was able to chat with them, but otherwise I would contact their mailing list.

Once I realised _why_ the project's testing was done as it was, it was a case of upgrading it to Ubuntu 16.04. This was actually only a two line change, but it didn't quite fix everything, due to some version inconsistencies.

I found that just running the automated tests was not very ideal, and took time to wait for it to work, only to find out about version inaccuracies, or similar. Therefore, I decided to set up a local environment in a [Vagrant Virtual Machine][vagrantup] to easily test the boxes. This testing environment provided me with the ability to locally check changes to the environment, and allow me to ensure that I had set everything up correctly before testing it on Travis.

While testing I found that with the new version, we would need to explicitly install the Python2 development headers; that the version of Node.JS v0.10 was outdated; and that v0.10 wasn't actually even being installed.

These changes made it possible to use a newer Operating System, which meant that the build would be run against newer versions of libraries and software.

## Finding a Project

Actually finding a project to help out with to is often a difficult task. There are literally millions of projects out there, and finding one that is relevant is difficult, especially as you want something that you would be more motivated to contribute to.

[Hacksoc Nottingham][hacksoc] can always do with community additions - for instance, the website, [HacksocNotts.co.uk][hacksoc-repo] can always do with new blog posts. See [Hacktoberfest Session](#hacktoberfest-session) for more details.

Alternatively, the Hacktoberfest team have set up a great resource for finding projects that have requested help [on their Featured Projects page][hacktoberfest-featured-projects]. The projects listed have assigned a number of issues the [`hacktoberfest` label][github-hacktoberfest-label] which makes it easy to discover issues that are targeted to new contributors. These may be a bit more manageable than other issues, and are of a slightly smaller size that make it easy to get started with. There are a few other sites which will provide you with project ideas, that can be found at [the Hacktoberfest site][hacktoberfest-resources]. These are all worth looking at, too, so you can find some more ideas for projects to work on.

## Determining Your Contribution

So now you've found a project that you want to work on, it's a case of actually deciding _what_ you want to actually do.

When I say that no contribution is too small, I honestly mean it. The FOSS community are incredibly welcoming, and are always happy to help accommodate new contributors. This is especially true because everyone has to start somewhere!

<!-- Documentation  -->
One incredibly valuable method of contribution is that of documentation. Documentation is as valuable as the code that it is written about. For instance, a project that doesn't easily describe how to get it set up and installed is useless; five or ten minutes of time cost to a single developer while they search around to set up the environment doesn't sound like a lot, but it adds up over time, over a number of developers. By helping reduce this time cost, you can save many hundreds of developer hours, which could save thousands of dollars just for a short amount of work from you.

The other great thing about working on documentation is that it gives you a great way to contribute if you're not as confident in your programming knowledge, or just want to get involved in a project without knowing it inside out. By working on the documentation, you'll learn a lot more about your project of choice, and this will lead to you being much more able to contribute more technical work in the future.

Remember that documentation doesn't just consist of the "how to get started", although that's always important. It can be anything from explaining what the project is, summarising the main things it does, and why you people should use it. Then there's information on how to use the project, such as what options you can use to run it, code snippets, sample code or how to run tests.
<!-- / -->

<!-- Browsing Open Issues  -->
A method of easily determining what needs to be done on a project is checking out the issue tracker. This will be a list feature requests, bugs, and other conversations between the community and the developer(s).

It's always worth reading through the issues to see what outstanding problems there are that people have reported, and trying to determine whether there are missing facts that could be useful, or whether this is something that you'd be interested in investigating. From here, it's a case of trying to reproduce the issue - if you can easily reproduce the issue, try debugging to find out if you can find the root of the problem. From there, you may have more of an idea how to fix it. Unfortunately the process to debug and fix an issue is out of the scope of this post.
<!-- / -->

<!-- New functionality  -->
Do you want the project to do something new? Do you wish that your shell's autocomplete added support for your favourite commands? Do you feel like helping out the developers by fulfilling someone else's feature request?
<!-- / -->

<!-- Refactoring / TODOs  -->
It can also be useful to scan through the source code, finding any `TODO`s commented in the code, or see if you can find any code that could be written better. If you find something you feel you could fix up, get stuck in!
<!-- / -->

For any changes made, make sure that the functionality of the project isn't broken - often projects will have a method in which to test the project against a set of tests. The method in which to test the project will differ, and of course if the documentation is lacking, make sure that you update it so future developers don't have to hunt it down!

As I mentioned before, no contribution is too small; make your first contribution a nice bite-sized contribution which will allow you to build some confidence and start to tackle slightly larger problems. Before long, you'll be able to start producing more complex contributions, and start working on projects much more easily.

## Actually Contributing It

In order to make your contribution, you will need to create a copy, or fork, of the repository. This can be done by navigating to the repo of choice, and selecting the "Fork" button, which will create a copy of the repository in your own account, so you can easily commit your changes at your own leisure.

From there, you will then need to clone your project locally, and you will then need to create a new branch, which will allow you to store your changes separately from the rest of the project.

```bash
git clone git@github.com:jamietanna/HacksocNotts.github.io
cd HacksocNotts.github.io
# create a branch with a relevant name
git checkout -b hacktoberfest-article
# do your work
...
git add ...
git commit
git push origin hacktoberfest-article
```

Ensure that before you push the commit that you:

- test the project works correctly - either by running built-in tests, or by manually determining your change works correctly, and does not break anything that previously worked (remember that software is very fragile, and that any minor change could cause a regression)
	- if you have added any new functionality, ensure that you add tests as well, to check that there is an automated way to determine whether the features work as expected in the future
- check the project's `CONTRIBUTING` document, to determine if there are any additional requirements that the project sets down
- check the project's `LICENSE`, and determine what the project legally allows you to do with it. More details can be found at [ChooseALicense][choosealicense] and [TLDR;Legal][tldrlegal].
- use a coding style that follows that of the project, be it explicitly or implicitly defined

So once you've actually made your changes, you need to be able to send it back to the original project. This requires you to create a Pull Request. This can be done through the GitHub interface. Once sent, the maintainer(s) will be able to discuss the contribution, and determine if there are any further steps required before they accept them into the project.

# Fancy a Hand?

If you're looking at getting started and would like some help, feel free to drop me a message in one of the formats in the page footer.

## Hacktoberfest Session <a name="hacktoberfest-session"></a>

On 6th October, I am running a [Git Workshop][git-workshop] which will serve as an introduction to Git and version control. In the interactive section of the workshop, I will be taking Hacksoc members through their first contribution - through a Pull Request to a blog post about Hacktoberfest on the Hacksoc website. The initial Pull Request can be found [on GitHub][hacksoc-repo-hacktoberfest-pr].

Also join us on the [`#Hacktoberfest` Slack channel][hacktoberfest-slack] to chat about what you're working on, get some ideas, and just get to know the others who are contributing. Additionally, you can even try and organise a Hacktoberfest meetup to work on FOSS contributions together.

# Keeping up momentum

Once Hacktoberfest is over, you may not really find the motivation to contribute to projects if you're not being rewarded by stickers and free T-shirts. But remember just how much time and cost you could be saving other developers. And also how much you're helping all these other people, just for the little things.

And remember that you can help out in any way possible - be it Pull Requests, providing more information on issue conversations, or reporting bugs. I honestly can't stress this enough - every little thing helps!



[seafile]: <https://seafile.com>
[seafile-contrib-1]: <https://github.com/haiwen/seahub/pull/1350>
[seafile-contrib-2]: <https://github.com/haiwen/seafile/pull/1753>
[hacktoberfest-announce]: <https://www.digitalocean.com/company/blog/ready-set-hacktoberfest/>
[hacktoberfest]: <https://hacktoberfest.digitalocean.com>
[hacktoberfest-featured-projects]: <https://hacktoberfest.digitalocean.com#featured-projects>
[hacktoberfest-resources]: <https://hacktoberfest.digitalocean.com#resources>
[github-hacktoberfest-label]: <https://github.com/search?l=&q=state%3Aopen+label%3Ahacktoberfest&ref=advsearch&type=Issues&utf8=%E2%9C%93>

[digitalocean]: <https://digitalocean.com>
[github]: <https://github.com>

[hacksoc]: <http://hacksocnotts.co.uk>
[hacksoc-repo]: <https://github.com/HackSocNotts/HackSocNotts.github.io>
[hacksoc-repo-hacktoberfest-pr]: <https://github.com/HackSocNotts/HackSocNotts.github.io/pulls/11>

[git-workshop]: <https://github.com/jamietanna/gittalk15/tree/master/intro-to-git-workshop>
[youtube-mpv]: <https://github.com/agiz/youtube-mpv>

[choosealicense]: <http://choosealicense.com/>
[tldrlegal]: <http://tldrlegal.com/>

[mraa]: <https://github.com/intel-iot-devkit/mraa>
[travis-ci]: <https://travisci.org>
[vagrantup]: <https://vagrantup.com>

[wiki-free-software]: <https://en.wikipedia.org/wiki/Free_and_open-source_software>
[wiki-open-source-software]: <https://en.wikipedia.org/wiki/Open-source_software>

[hacktoberfest-slack]: <https://hacksocnotts.slack.com/messages/hacktoberfest/>
