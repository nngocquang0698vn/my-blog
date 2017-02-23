---
layout: project
title: jvt.me
image: jvtme.png
github:
gitlab: jamietanna/jvt.me
description: My personal website and blog, built on Jekyll.
tech_stack:
- jekyll
- capistrano
- docker
- gitlabci
- daktilo
- gulp
- browsersync
project_status: ongoing
---

The design for my personal site is adapted using the Daktilo, because I'm a developer, not a designer, although I would have loved to have created my own design.

I've integrated Jekyll-backed site in with `gulp` in order to provide extra functionality such as minification and integration with Browsersync. This has given me some more knowledge about working with the NodeJS ecosystem, and hooking things together.

Due to the added dependencies, and having to have both Ruby and NodeJS dependencies, I decided it would be a good time to test out performing continuous builds and deployments using Docker. This would provide me a contained set of dependencies in a container that would be portable, and save me having to install all the dependencies each and every time a build or deploy was made. Instead, I was able to contain it into the single build image, and therefore speed up deployments hugely on my end server.

The site is released under the GNU General Public License 3.0 and the theme under the MIT License.
