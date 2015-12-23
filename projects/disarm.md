---
layout: project
title: disARM
image: projects-disarm.png
github:
gitlab:
description: 
---
disARM is the final coursework from my first year Introduction to Programming course at Nottingham. We were tasked with creating a disassembler, which would take in a compiled ARM Executable and Linked Format file, and output the instructions that the file contains. I asked my lecturer whether it were possible to determine what label the <code>ADR</code> and <code>ADRL</code> instructions were pointing to, but he mentioned it was not. However, I decided to look into the ELF format, and discovered the Symbol table. Following this, I was able to work out the correct addresses, and insert them instead of some offset.
This project was one of my first large achievements, and as such I am really happy with the resulting program. The code, however, is not at all something I'm happy with, but I realise a few years really does make a difference.

