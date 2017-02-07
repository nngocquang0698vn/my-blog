---
layout: post
categories: fosdem
tags:
title: Resurrecting dinosaurs, what could possibly go wrong?
description: "How containerised apps could eat our users"
---
DLL hell - Win 3.1/95
- no ABI backwards compat
- most DLLS in `C:\WINDOWS\` `C:\WINDOWS\SYSTEM`
- things would break constantly between upgrades
- made it a service/maintenance nightmare
- applications stealing resources from others

*had* to dev and test on every possible DLL combination
then the same for patches

Win2000 meant to have fixed it
- SideBySide (SxS) - DLL "containerisation"
	- mem space different for app, DLLs
	- 'Private DLLs' could be loaded from App dir
- Windows File Protection - isolation of system DLLs
- DLL Universal Problem solver - audit DLL in use, help migrate legacy apps

*NOPE*
- security - DLLs with vulns, in countless app folders
- maintenance - how can we update app? ship an updater!
- legal - can we actually, legally, redistribute these?
- storage - more disk consumption

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

