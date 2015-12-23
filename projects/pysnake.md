---
layout: project
title: PySnake
image: projects-pysnake.png
github: jamietanna/pysnake
gitlab:
description: PySnake is a Snake game written in PyGame, with a few extra game mechanics to throw off the experienced.
tech_stack:
- pygame
---
PySnake is the result of a first year *Foundations of Software Engineering* project, where we practiced pairs programming while learning Python and Pygame.

We were tasked with proposing and creating a game in Pygame, while taking part in common agile approaches to development; we worked on an iterative release cycle, focussing on quick throwaway prototypes in order to develop the knowledge required to build our final project.

Our initial prototype was for a different idea altogether; *Angry Joolz* was a clone of Angry Birds where the birds were replaced with the likeness of our lecturer. This was too time consuming, and difficult, for the scale of the project, and so we decided to pivot to the idea of a Snake game that had additional gameplay mechanics in order to appeal to experienced Snake players.

The final game followed the same principle as the original Snake game; collect food, while avoiding your own tail and the walls. This was in-of-itself relatively simple once we had worked out how PyGame worked. However, the gameplay was repetitive and nothing particularly innovative, so we decided to add some new features.

Firstly, we added changes to the tail length, such as allowing the player to reduce the tail size if they ate a certain food type. However, we decided that this would cause the game to become much easier, as players would be able to reduce the only handicap that the game mechanics provide.

Our next decision was to add a more challenging game mechanic - bouncing balls that would try to hit the player. These would be of two types; the Standard Ball and the Killer Ball, the latter of which being 1.5 times quicker than the other.

We then went on to add different food items, such as the Berries of Bane, which 'cursed' the player, turning their tail invisible. The Mysterious Melon would generate a random effect, such as freezing, or spawning more balls.

Finally, we added a "level editor" of sorts, allowing a player to define their own settings for the level, such as the number of food items and the size of the balls that a level could spawn.

The project was the first exposure I had to using version control, as we were advised to use the school of Computer Science's Subversion server. Since experiencing just how useful it was for working with others, I decided that I would use it for all my future projects.
