---
layout: post
title:  Open S-awesome
description: A month of giving back, and a very honest post-mortem of what I learned.
categories: opensource freesoftware community
---

In December, an event called [24 Pull Requests][24pr] promotes giving back to various FLOSS projects in _an advent-calendar esque_ way.

I managed to make all 24 contributions, which can be found below:

- [jamietanna/dotfiles-arch](https://github.com/jamietanna/dotfiles-arch)
    - [WIP: Update README](https://github.com/jamietanna/dotfiles-arch/pull/45)
    - [WIP: Add SSH config file](https://github.com/jamietanna/dotfiles-arch/pull/44)
- [HackSocNotts/wit-deprecated](https://github.com/HackSocNotts/wit-deprecated)
    - [Move to the AGPL](https://github.com/HackSocNotts/wit-deprecated/pull/37)
- [HackSocNotts/hacknotts.com](https://github.com/HackSocNotts/hacknotts.com)
    - [Move to the AGPL](https://github.com/HackSocNotts/hacknotts.com/pull/16)
    - [Add sample nginx config](https://github.com/HackSocNotts/hacknotts.com/pull/15)
- [HackSocNotts/HackSocNotts.github.io](https://github.com/HackSocNotts/HackSocNotts.github.io)
    - [Use Jekyll data files for the Exec details](https://github.com/HackSocNotts/HackSocNotts.github.io/pull/21)
    - [Move to the AGPL](https://github.com/HackSocNotts/HackSocNotts.github.io/pull/20)
    - [Add link to the WiT site](https://github.com/HackSocNotts/HackSocNotts.github.io/pull/19)
    - [Add htmlproofer to test the site integrity](https://github.com/HackSocNotts/HackSocNotts.github.io/pull/18)
    - [Remove any unnecessary files for Jekyll build](https://github.com/HackSocNotts/HackSocNotts.github.io/pull/17)
    - [Fix README Markdown syntax highlighting](https://github.com/HackSocNotts/HackSocNotts.github.io/pull/16)
    - [Programatically display contributors to the site](https://github.com/HackSocNotts/HackSocNotts.github.io/pull/15)
- [HackSocNotts/wit](https://github.com/HackSocNotts/wit)
    - [Add PHP-FPM and Nginx configs](https://github.com/HackSocNotts/wit/pull/36)
- [haiwen/seahub](https://github.com/haiwen/seahub)
    - [Add instructions for how to set up in a virtualenv](https://github.com/haiwen/seahub/pull/1433)
    - [Add missing translations for Sysadmin settings page](https://github.com/haiwen/seahub/pull/1432)
- [anthraxx/arch-security-tracker](https://github.com/anthraxx/arch-security-tracker)
    - [WIP: Add missing requirements.txt file](https://github.com/anthraxx/arch-security-tracker/pull/42)
- [adtac/fssb](https://github.com/adtac/fssb)
    - [Remove generated nope executable](https://github.com/adtac/fssb/pull/6)
    - [Clarify that syscall arguments map to registers](https://github.com/adtac/fssb/pull/5)
- [nevik/gitwatch](https://github.com/nevik/gitwatch)
    - [Add systemd unit file](https://github.com/nevik/gitwatch/pull/38)
- [chriskempson/base16](https://github.com/chriskempson/base16)
    - [Add link to preview themes](https://github.com/chriskempson/base16/pull/71)
- [agiz/youtube-mpv](https://github.com/agiz/youtube-mpv)
    - [Remove system-wide systemd install method](https://github.com/agiz/youtube-mpv/pull/26)
- [duffn/dumb-password-rules](https://github.com/duffn/dumb-password-rules)
    - [Add Virgin Trains](https://github.com/duffn/dumb-password-rules/pull/33)
- [benbalter/retlab](https://github.com/benbalter/retlab)
    - [Add screenshot to the README](https://github.com/benbalter/retlab/pull/4)
- [bertrandkeller/overkyll-jekyll-theme](https://github.com/bertrandkeller/overkyll-jekyll-theme)
    - [Add screenshot to the README](https://github.com/bertrandkeller/overkyll-jekyll-theme/pull/6)

A total of 16 (66%) of the contributions I made were through projects I've previously contributed to. In effect, a mere third of my contributions over the month were for new projects I found.

I found that looking forward during the month, I would collate a list of "easy" pull requests - these would be things I would much more easily be able to collect and get things `sorted` with. These would be some minor changes, such as adding links or pictures, and I would save them in a saved note, while browsing reddit or Hacker News threads. However, these minor changes, although they can be seen to be useful, didn't really add too much to the end user's experience, which is ideally what should be focussed on for the contributions we make.

Because of this, I found that I didn't really have many large contributions to be proud of, unlike something like Hacktoberfest. I say that, but there are a couple of contributions such as the use of `htmlproofer` and programatically listing contributors to [`hacksocnotts.co.uk`](http://hacksocnotts.co.uk).


One thing you'll notice is that I made a number of commits to the HacksocNotts repos: _11_ in total, in fact. This number is a lot higher than I would have hoped; but again, a number of these contributions are ones that we have previously discussed as a "nice-to-have" and as I had the chance to work on changes, it made sense for me to make them. However, the issue with this is that Hacksoc is all about the members learning - and I shouldn't be taking that away from them. Instead of making these contributions, I should have made them as issues, and then given the community the chance to learn for themselves how to go about doing these. Although I was personally able to learn a lot, it isn't up to me to be learning through the Hacksoc sites!

Overall, I am happy that I went through the experience, to see if I could, and what sort of level of commitment it would require. However, it's shown me how allocating time to side projects (on a deadline, no less) during a very busy month is not the best method of breeding strong contributions. I now know for the future not to push myself to hit a deadline with too high a limit, and instead realise that I need to aim for much more attainable goals.

PS: I would say that actually, the script that let me determine which contributions I made over the month was slightly more useful in some cases. It can be found at [`get_pr.py`](https://gitlab.com/jamietanna/jvt.me/blob/master/get_pr.py), and will hopefully shed some insight into how the above Markdown list was generated automagically.

[24pr]: http://24pullrequests.com/
