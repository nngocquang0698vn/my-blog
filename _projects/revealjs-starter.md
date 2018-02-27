---
layout: project
title: Reveal.js Starter project
image:
github:
gitlab: jamietanna/revealjs-starter
description: Project generator for creating Reveal.js slides with an opinionated structure.
tech_stack:
- revealjs
project_status: ongoing
---
When I decided to move from creating slides for talks using LaTeX Beamer to Reveal.js, after I had written a couple of slides in Reveal.js, I found that there was a large amount of boilerplate that wouldn't change.

This project simply makes it possible to get an (opinionated) setup for Reveal.js by running i.e. `rake 'init[rake_ruby_builds_slides, Rake and Ruby builds]'`. This will configure the directory structure and install dependencies, making it possible to get up and running as quickly as possible.

I have adopted this as the standard way of working for new talks in my [talks repo](/projects/talks/).
