---
layout: project
title: Dotfiles
image: projects-dotfiles.png
github: jamietanna/dotfiles-arch
gitlab:
description: My configuration files for my Linux installations; be it Vim, Zsh, or BSPWM.
---
My dotfiles are all the configuration files I use with my Arch install, such as Vim and my Window Manager, BSPWM. These configs are shared on Github so I can easily clone them wherever I am, and also so others can see how I like things configured.

I try to keep my dotfiles following good practices, both with Git, and with its code. As such, my commit messages explain the reasonings for the changes, in such a way that I'll be able to go back and work out why I added it.

I recently added the ability to bootstrap my system by simply cloning the repo and running `./bootstrap.sh`, which installs my dotfiles in the correct places and installs all associated dependencies needed.

I keep a branch for each of my devices, which allows me to have separate settings in each; in reality both branches are incredibly similar, and only differ with respect to DPI settings.
