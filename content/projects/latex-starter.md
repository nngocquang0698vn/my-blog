---
layout: project
title: LaTeX Starter project
image:
github:
gitlab: jamietanna/latex-starter
description: Project generator for creating LaTeX documents opinionated structure.
tech_stack:
- beamer
project_status: ongoing
---
When writing my slides in LaTeX Beamer, I found that there were a number of unchanging configurations that I'd share across each set of documents.

This project simply makes it possible to get an (opinionated) setup for LaTeX by running i.e. `./latex-starter/setup.sh document psyjvta-dissertation`. This will configure the directory structure and set up a `Makefile` using `latexmk`, although I have it on [my backlog to integrate `latexrun`](https://gitlab.com/jamietanna/latex-starter/issues/7) due to its [cleaner build output]({{< ref 2017-04-13-latexrun >}}).
