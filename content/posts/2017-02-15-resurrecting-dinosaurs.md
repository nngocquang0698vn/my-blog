---
title: Resurrecting dinosaurs, what could possibly go wrong?
description: "How containerised apps (AppImage, Snappy and Flatpak) could eat our users"
categories:
- fosdem
tags:
- fosdem
- opensource
- containers
- docker
- flatpak
- snappy
- appimage
date: 2017-02-15
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: resurrecting-dinosaurs
---
> This article is developed from a talk by [Richard Brown at FOSDEM 2017][dinosaurs-fosdem]. Although aimed towards the desktop market, there are a lot of learnings that can be applied to the services ecosystem.

# A Brief History Lesson

Richard started off the talk by discussing the past - in particular, Windows 3.1/95, and the term "DLL Hell".

At this point in time, there was no backwards compatibility in the Application Binary Interface that Windows provided. These DLLs would be stored within either `C:\WINDOWS\` or `C:\WINDOWS\SYSTEM`, in such a way that applications would be able to load them automagically. However, because of the global state of these libraries, and the lack of a fixed ABI, it would mean that between upgrades of your Windows installation, applications would constantly break.

As you can imagine, this was an absolute nightmare for service and maintenance for developers and sysadmins alike. For the developers, they would have to develop and test that _every possible DLL combination_ would work. But then, to make it even worse, they would also have to do the same for patches.

With Windows 2000, Microsoft managed to fix this. Or so they thought. They created the SideBySide assembly, `SxS`, which would make it possible to have DLL "containerisation", which would mean that the memory space and loaded DLLs for all applications would be different. This would mean that "Private DLLs" could be loaded from any directory by the application, such that they would be able to version pin their libraries.

In order to help fix these issues, the [DLL Universal Problem Solver][dups] was released, to audit the DLLs being used by applications, and to help migrate the legacy applications that were still using global DLLs.

However, this turned out to be less than ideal, for four main reasons:

- **Security**: When a DLL was found to have a vulnerability, that DLL had to be located amongst the countless applications that used that version, and be updated. But what if that then broke an app?
- **Maintenance**: How can the developer actually update their app once it's installed on the end-user machine? By shipping an updater that can check if it needs updates, and if so, perform them.
- **Legal**: Are we actually, legally, allowed to redistribute the DLLs?
- **Storage**: More copies of the same files drives more disk consumption.

This issue was largely fixed using the distribution model that \*nix uses. Distributions themselves handle these points:

- **Security**: Audits are done via third parties, ensuring that packages are secure. Monitoring of CVEs and embargoed lists are done, and updates are shipped to the users.
- **Maintenance**: Testing that packages work with the new library version bump, and once they are, rolling out the changes to the end-user.
- **Legal**: Lawyers will be able to perform audits and ensure compatibility and compliance in a more structured and maintainable way.
- **Storage**: *N/A*

This can additionally be mitigated by the use of shared libraries. These allow the sharing of library functionality across multiple files, while only using a single library file.

- **Security**: _Fewer_ insecure libraries to have to find and then update, therefore making it easier to patch
- **Maintenance**: Less person-power required to actually perform the maintenance and updates
- **Legal**: Easier to review and audit licenses
- **Storage**: Less files, therefore less disk usage!

Distributions have the fun job of handling compatibility - where they have have multiple versions of applications with different library requirements. Each developer will have specified the version they built it with, but don't want to care what version each distribution is on, and what the end user is going to be using. Additionally, they don't want to be worrying about what the other versions of a library another developer has chosen. Instead, they want the application to _just work_.

Additionally, the developers don't want to have to perform repeats of their builds across different environments. This can be done by using a system such as the [Open Build Service][obs] which will perform distribution-specific builds. However, this doesn't mitigate the need to actually learn about the toolsets and packaging formats that each distribution needs. Having to get up to speed on all the platforms your application is going to be used makes things much harder to get out of the door. So often, application developers won't worry about it! Problem solved. It's then up to the hard work of distribution maintainers to get the application packaged correctly.

But this means that then there is the compromise between "pace of change" and "_it just works_". You either release as you want, and therefore make it harder for the end user to upgrade as they have to fight with versions, or you realise that your latest updates will arrive to your users a bit later.

The reason distributions take a bit longer to push out changes is often due to their fixed release schedules. For instance, Ubuntu use April (`xx.04`) and October (`xx.10`) as their main release timelines. Between that time, there are (usually) no major or minor package updates, only bug or security patches. Therefore, it means that versions of applications and libraries have to be frozen for stability. However, when you're at the will of a distribution's development speed, you have to worry about hitting issues such as the [distribution's version lagging behind][debian-xscreensaver], and therefore your software receiving complaints, when the problem is actually the pace they work at.

One method to avoid the issues of a fixed-release distribution is to work with rolling distributions, that are more cutting-edge, and will have releases much more regularly - for instance, with [Arch Linux][arch], I can perform updates at least 3-4 times per week, as packages are constantly being released.



# Where We Are Now

The solution for this problem is to make it possible for developers themselves to perform releases, such that they can package their application in a format that the end user will be able to use. Currently, [FlatPak][FlatPak], [Snappy][Snappy] and [AppImage][AppImage] are the main formats for creating a bundle of application(s) and libraries to provide a usable, out-of-the-box package for an application, that will work independent of the user's Operating System. The perk of this is it gives the developers the chance to package things in their own time, and make it available to the end user, without having to rely on maintainers.

However, it's often made with an assumption that "my app, _and its dependencies_ require `$version` of `$library`". But because there is no common base for what should be included in a distribution, this assumption can make things very difficult in the end. For instance, to do it correctly for your application, you will need to find all the versions of all the dependencies, that are different to the distros you're aiming for, and add them into the image. This could mean that you install them via the package manager, or that you compile them from source. This means that you will then bundle everything that _might not_ supported by the end platform.

This is made slightly better by using the concept of a framework/runtime to target, which basically says "target this _Middledistro_ and it'll be cool". However, Richard goes on to discuss how this is a really bad idea, and that instead we can simplify this by simply having a well defined [Linux Standard Base][lsb-wiki].

# One Step Forward, Two Steps Back

**But wait** - does this look familiar? We're back to where we started.

- **Security**: If there's an issue in a common library, all container images need to be updated
	- Not only at a library or application level, but at an underlying Operating System level - i.e. `libc` or `openssl` issues
- **Maintenance**: Fragmentation of libraries, versions, and even base Operating Systems used for any given images.
- **Legal**:
	- Are the licenses for all the dependencies used correct and compliant?
	- As the developer is distributing a compiled image, do all the tools fit within licensing constraints?
	- Developer is the one now, who has to audit and review
- **Storage**: Multiple copies of _whole OS_ and multiple versions of libraries and applications.

Additionally, these questions that aren't easy to answer, in the case that there is a security issue on the scale of [Heartbleed][heartbleed-wiki]?

- What happens if a developer is on holiday?
- What happens if a developer abandons the project?
- What happens if the [bus factor][bus-factor] is tested?


# Thinking as a Distribution

The issue with the above points is that if at any point a project is being used actively, but the developer stops making changes for any point, who's going to pick up the slack? Will a user slate their distribution if, in an incredibly unlikely example, suddenly LibreOffice has a security issue but it isn't maintained any more? If they don't understand they're using i.e. Snappy, but just that they got hacked?

Therefore, in order to really do this right - and _honestly_ as developers, we should be doing it right - is to think about things as if we were a distribution. We have to act as if we're a maintainer, and we have to answer questions like these:

- Can this library break my application if its ABI changes? If yes, move it into our bundle
- Can I actually rely on the ABI to not change? If no, move it to the bundle

But then, we additionally need to start testing the different platforms and combinations to make sure that it will _just work_ everywhere, in the right way. This adds a lot of overhead to someone who just wants to push out their application for people to use it. Sound familiar?

# Where do we go from here?

Richard proclaims that until there is a "Linux Standard Base for the container age", portability cannot be promised by anyone. Because there are just so many combinations and different versions of tools and applications and libraries, nothing can be safely said to work, until it is fully standardised.

Alternatively, give up on your containerised applications is the advice Richard gives. He mentions that distributions have been building on decades of tools, and have the talent for dealing with these sorts of problems in the real world, on a huge scale, for _years_. We shouldn't be reinventing the wheel, just because we can. The distribution maintainers are a team of well practiced, intelligent people, who have been doing this for so long - whereas application developers buying into this containerised work will be coming in with fresh eyes, and therefore won't be nearly as experienced to handle these issues.

An alternate method to deal with this is to have the users who want the more cutting-edge applications to move to a rolling release distribution. The whole point of these distributions is to make ti much easier to get into the user's hands, and to guarantee an integrated "built together" experience, such that things are tested a bit more carefully across the whole distribution.

# How This Relates to Containerised Deployments

Although the talk, and this article, have been primarily concerned with the use of containers for packaging applications for desktop users, there is a huge amount of work recently in containers for server-oriented applications such as web services. They're used for building self-contained applications, that (much like the aforementioned tools) have all the dependencies they need, and are used to enable composability of services, and to increase the deployment speeds - from anywhere up to an hour to spin up and provision a machine, to literally a matter of seconds.

However, they're following the same issues - everything is bundled into a single container, which is then used by other projects and is deployed into use.

- **Security**:
	- What if there's a security update for the base OS/image that we depend on?
	- What if there's a security update for the packages or libraries we depend on?
	- What if we have to build packages or libraries from source?
- **Maintenance**:
	- How can we automate the process of rolling out a new update to all the machines that are relying on the image?
- **Legal**:
	- Are we able to distribute everything that's in the image?
	- How do we perform audits and reviews?
- **Storage**:
	- We now have hundreds of layers of images littered around our machines, many of which are no longer required. Each has its own version of dependencies and applications.

The issue of security updates is one that I've had to think about as part of [`adc5c6a`][jvtme-adc5c6a] and [`8edd6ce`][jvtme-8edd6ce] on my personal website, and that is done via an i.e. `apt update && apt upgrade` as the first major step within each Docker build. This makes sure that I pull my latest base image for Debian, and then make sure all upgrades are performed, such that the box that's deployed is using the latest packages and libraries as of that time. However, there is no "refresh" job that will perform an automated rebuild in order to make sure I'm constantly up to date with versions. For instance, if I were on holiday, or just not committing to my website, there could be a number of security updates that are unprotected. Additionally, although the base image is updated, none of the dependencies are - they are currently locked into the versions that they always have been. Although this is only around a month, there should be a more regular refresh (at least to ensure security fixes are available).

This is something that should be considered when planning the orchestration and architecture of applications built on container platforms. Compared to a standard OS install, which can potentially have tools like i.e. Chef Agent running on the box, making sure updates are installed when required, a container is meant to be an immutable, deployable, instance of an application in a bundled state. Therefore, something needs to be run in an automated timeframe to roll out new security updates and fixes, as well as ensure that the applications are at their latest version.

In conclusion, although containers are useful for bundling dependencies into a single place, at the same time, that means that you will be using outdated software that cannot be easily refreshed without a container rebuild. In order to keep secure when using containers, infrastructure must be put in place to automate this. Containers also bring the issue of having to perform this extra maintenance and bundling yourself, on a potentially commercially unsupported distribution.

[dinosaurs-fosdem]: https://fosdem.org/2017/schedule/event/dinosaurs/
[dups]: https://www.tutorialspoint.com/dll/dll_tools.htm
[obs]: http://openbuildservice.org/
[debian-xscreensaver]: https://news.ycombinator.com/item?id=11412081
[arch]: http://archlinux.org
[AppImage]: http://appimage.org/
[Snappy]: https://snapcraft.io/
[FlatPak]: http://flatpak.org/
[lsb-wiki]: https://en.wikipedia.org/wiki/Linux_Standard_Base
[bus-factor-wiki]: https://en.wikipedia.org/wiki/Bus_factor
[heartbleed-wiki]: https://en.wikipedia.org/wiki/Heartbleed
[jvtme-adc5c6a]: https://gitlab.com/jamietanna/jvt.me/commit/adc5c6a6a0c707554c3723c3a58c2c0d72226070
[jvtme-8edd6ce]: https://gitlab.com/jamietanna/jvt.me/commit/8edd6ce0ee2ac59dbcb00cd14af673c6f3c36345
