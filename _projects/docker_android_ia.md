---
layout: project
date: 2015-02-10
title: Docker Build System for Android on Intel Architecture
image: /assets/img/projects/docker_android_ia.png
github:
gitlab:
description: A Docker-based container infrastructure to build the Android Source Code for different Intel Architecture platforms.
tech_stack:
- docker
- python
- exim
- samba
- tmux
project_status: completed
---
While working at Intel, I was part of an Android tablet project for a large UK retailer. As part of this, we worked on building versions of the Android Operating System with custom patches. The turnaround for the whole build process was around 40 minutes, which at times was extremely unforgiving. Therefore, I was tasked with setting up a server internally that would allow us to build Android much more quickly.

I used Docker to set up isolated environments which would contain all necessary dependencies for the version of Android needed for different Intel devices, to ensure easy setup of environments in the future.

I found that when initially running Docker instances, I would have to enter a long command such as `docker run -v /path/to/volume:/android -ti kk-intel-444 /bin/bash` in order to spin up and connect, which got very tiresome, and was not very user friendly to other users on my team. Therefore, I set up a login system, pictured, which would list the images available, and run all of the required plumbing to set up the user with their Docker image.

However, an issue with this was that multiple users could then log in to two separate containers, and try to write to the same source folder, without knowing another user was using it. Therefore, I set up integration with [Tmux via the Python bindings](https://pypi.python.org/pypi/tmuxp) to programatically check existence of, create, or connect to different Tmux sessions. This then prevented accidental overwriting of key files, and the headaches it would no doubt cause.

I also added a wrapper script to map the `make` command with an email script, allowing the user who had set the build off to be notified as soon as the build was finished, as these builds take up to 40 minutes.

The server was also set up with Samba, which had shares for each Docker image type, providing an easy way in which to get access to the final zip file which could then be flashed onto a device.

Overall, this setup was so impressive for the company behind the tablet project that they then took upon the Docker setup, as well as took parts of the infrastructure such as Samba.
