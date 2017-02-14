---
layout: post
categories: fosdem
tags:
title: Resurrecting dinosaurs, what could possibly go wrong?
description: "How containerised apps (AppImage, Snappy and Flatpak) could eat our users"
---
> This article is developed from a talk by [Richard Brown at FOSDEM 2017][dinosaurs-fosdem]. Although aimed towards the desktop market, there are a lot of learnings that can be applied to the services ecosystem.

## A Brief History Lesson

Richard started off the talk by discussing the past - in particular, Windows 3.1/95, and the term "DLL Hell".

At this point in time, there was no backwards compatibility in the Application Binary Interface that Windows provided. These DLLs would be stored within either`C:\WINDOWS\` or `C:\WINDOWS\SYSTEM`, in such a way that applications would be able to load them automagically. However, because of the global state of these libraries, and the lack of a fixed ABI, it would mean that between upgrades of your Windows installation, applications would constantly break.

As you can imagine, this was an absolute nightmare for service and maintenance for developers and sysadmins alike. For the developers, they would have to develop and test that _every possible DLL combination_ would work. But then, to make it even worse, they would also have to do the same for patches.

With Windows 2000, Microsoft managed to fix this. Or so they thought. They created the SideBySide _?system?_, `SxS`, which would make it possible to have DLL "containerisation", which would mean that the memory space and loaded DLLs for all applications would be different. This would mean that "Private DLLs" could be loaded from any directory by the application, such that they would be able to _??_.

In order to help fix these issues, the [DLL Universal Problem Solver][dups] was released, to audit the DLLs being used by applications, and to help migrate the legacy applications that were **TODO: what exactly was going on here again?**


However, this turned out to be less than ideal, for four main reasons:

- **Security**: When a DLL was found to have a vulnerability, that DLL had to be located amongst the countless applications that used that version, and be updated. But what if that then broke an app?
- **Maintenance**: How can the developer actually update their app once it's installed on the end-user machine? By shipping an updater that can check if it needs updates, and if so, perform them.
- **Legal**: Are we actually, legally, allowed to redistribute the DLLs?
- **Storage**: More copies of the same files drives more disk consumption.

This issue was largely fixed using the distribution model that \*nix (**does UNIX?**) uses. Distributions themselves handle these points:

- **Security**: Audits are done via third parties, ensuring that __??__. Monitoring of CVEs and embargoed lists are done, and updates are shipped to the users.
- **Maintenance**: Testing that packages work with the new library version bump, and once they are, rolling out the changes to the end-user.
- **Legal**: Lawyers will be able to perform audits and ensure compatibility and compliance in a __??__ way.
- **Storage**: *N/A*









- **Security**:
- **Maintenance**:
- **Legal**:
- **Storage**:






## How This Relates to Containerised Deployments



```markdown
- Windows File Protection - isolation of system DLLs

distros would do this for you
- security is done via audits, monitoring CVEs, embargoed lists
- maintenance - checking that packages work when updated with new versions, then rolling out
- legal - lawyers who would be able to audit, ensure compatibility + compliance!

shared libraries?
- less files therefore disk space
- fewer _insecure_ libraries - easier to patch
- less manpower for maintenance/update
- easier to review/audit licenses


compat:
- distros with different versions of different libraries, apps
- different apps need different libraries
	- devs don't care what version you're running - want it to _just work_
	- also, what version another dev has chosen for their version

portability:
- don't want to repeat all your builds across different environments
- don't want to learn lots of toolsets
- often, _isn't_ worried about - up to distro maintainer

pace of change vs it just works
- fixed release schedule
- freeze package/library versions - stability
- holds back new apps
- don't need to worry about devs
- rolling distros resolve this - increase efficiency

##

AppImage, Snappy, FlatPak - provide "bundle" with apps + libraries
runs in some sort of sandbox/container
- all the above are fine! _just works_ on whatever platform you want
- app + framework on top of host OS

make assumption - "my app _and its dependencies_" require this version of `$library`
no common base of what's available for each distro - it's all _assumed_

to do it correctly - need to find all the versions of dependencies that are different to the distros aiming for (i.e Fedora) and add them in
everything that _might not_ be supproted by end platform

framework/runtime - "target this _Middledistro_ and it'll be cool"
- but really, why not just a well defined Linux Standard Base?


- app devs can distribute at own pace, not wait for maintainers

**But we're back where we were**!!
if it's up to the dev, what happens if the maintainer leaves? but people still use it? or they're on holiday and heartbleed hits?


##

have to think as a distro
- can this break app if ABI changes? yes - move to bundle
- can I rely on ABI? No - move to bundle

dev+test on all platforms and combinations

means the dev has to act as a maintainer - much more work to think about (to do it right)

"LSB for the container age" needs to be made
- without, portability promise is unachievable

distros - decades of tools, talent for dealing with problems (in the real world) for _years_
don't reinvent the wheel, just because we can!

## Rolling Releases

get apps into user's hands much quicker, more easily - best model available for this
guaranteed an integrated "built together" experience `??`
```

[dinosaurs-fosdem]: https://fosdem.org/2017/schedule/event/dinosaurs/
[dups]: https://www.tutorialspoint.com/dll/dll_tools.htm
