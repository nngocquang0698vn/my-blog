---
title: Emoji Support in Dunst
description: How to see Emoji when using the Dunst notification system.
categories:
- blogumentation
tags:
- archlinux
- dunst
- dotfiles
- blogumentation
- emoji
date: 2018-03-01
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
---
# TL;DR

- Install [an emoji font][aw-emoji]
- Restart Dunst
- Optional: explicitly configure `~/.config/dunst/dunstrc` to include the font

# A little more context

Although I've used [Dunst][dunst] for a couple of years, it wasn't until recently that I realised I wanted emoji support.

It came about when I switched over from Chromium to Firefox Nightly, and found that the WhatsApp Web interface would send notifications via Dunst. For instance, I would receive a popup similar to:

![Dunst notifications without emoji support, showing the raw Unicode characters instead of pictogram representation](/img/emoji-dunst/without-emoji.png)

As you can see, instead of receiving a pictogram representing ["Woman Gesturing OK"][woman-gesturing-ok], I was able to see the raw Unicode representation.

It turns out the lack of emojis showing was due to me not having any emoji fonts installed on my system. Following the [Fonts page on the Arch Wiki][aw-emoji] I found that as I liked Google's emoji, and they were packaged nicely, I would use them.

Once installed, I found that the font would automagically get loaded into Dunst and would render notifications correctly:

![Dunst notifications with emoji support, showing the correct pictogram representation](/img/emoji-dunst/with-emoji.png)

Just to ensure this would always reference this font (i.e. in the case multiple emoji fonts were installed), I configured Dunst by adding the following configuration in `~/.config/dunst/dunstrc`:

```diff
 [global]
-    font = Liberation Mono
+    font = Liberation Mono, Noto Emoji 12
```

To determine the font name to use, I ran the following command, and noted the name between the colons:

```bash
$ fc-list | grep -i noto
/usr/share/fonts/noto/NotoEmoji-Regular.ttf: Noto Emoji:style=Regular
/usr/share/fonts/noto/NotoColorEmoji.ttf: Noto Color Emoji:style=Regular
$ fc-list | grep -i noto | cut -f2 -d: | cut -c2-
Noto Emoji
Noto Color Emoji
```

[dunst]: https://github.com/dunst-project/dunst
[woman-gesturing-ok]: https://emojipedia.org/woman-gesturing-ok/
[aw-emoji]: https://wiki.archlinux.org/index.php/Fonts#Emoji_and_symbols
