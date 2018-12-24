---
title: "Viewing Git history of a file in `git log` while ignoring file renames"
description: "How to track changes to files in Git without pesky file renames getting in the way, using `git log --follow`"
categories:
- blogumentation
- git
tags:
- git
- cli
- shell
- blogumentation
image: /img/vendor/git.png
date: 2018-09-11
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
---
You'll often want to see the various changes that have been made to a file over time:

<asciinema-player src="/casts/git-log-file-renames/no-follow.json"></asciinema-player>

```
$ git log --stat _posts/2017-03-25-why-you-should-use-gitlab.md
commit 28e1ba234e887c01da3e8d62571dac1f6215612d
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sun Aug 5 18:37:58 2018 +0100

    Correct incorrectly-cased GitHub

    As part of #206.

 _posts/2017-03-25-why-you-should-use-gitlab.md | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

commit be85ad604f4a0f1bb9a5892c3651abfc375ea28a
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sun Apr 8 20:52:36 2018 +0100

    Add GitLab logo for sharing metadata

    Closes #244.

 _posts/2017-03-25-why-you-should-use-gitlab.md | 1 +
 1 file changed, 1 insertion(+)

commit 545d1d80963083a34781fa700e08bd2cd5403033
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Jul 8 23:05:41 2017 +0100

    Remove link for deleted Google Doc

    Turns out GitLab have now deleted the article - so we shouldn't be
    linking to it any more as our tests will fail.

 _posts/2017-03-25-why-you-should-use-gitlab.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 550c90d37a86283c080213054483f6d54133f890
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Apr 22 19:42:11 2017 +0100

    Add/fix categories

    Some of the posts don't quite fit in with the right categories.

 _posts/2017-03-25-why-you-should-use-gitlab.md | 1 +
 1 file changed, 1 insertion(+)

commit 3304581bdc8d58560f3fe2e7c1803607d23aaf11
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Mar 25 10:51:09 2017 +0000

    Capitalise `Lab` in GitLab

    Looks like it's been wrong all this time - would be embarrassing if this
    was posted and it was wrong.

 _posts/2017-03-25-why-you-should-use-gitlab.md | 78 +++++++++++++-------------
 1 file changed, 39 insertions(+), 39 deletions(-)

commit 6e777721c9fee2ee29aff80f613dbf0b884a056f
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Mar 25 10:47:47 2017 +0000

    Fix link on Why-GitLab article

 _posts/2017-03-25-why-you-should-use-gitlab.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 51bb45c770913117650a9b8f1319bc375e518986
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Mar 25 10:45:10 2017 +0000

    Remove TODO from Why-GitLab article

 _posts/2017-03-25-why-you-should-use-gitlab.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 5239f250d87cbf9ca27097ce7ff482f2a45814ae
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Mar 25 10:36:57 2017 +0000

    Promote: Why-GitLab article

 _posts/2017-03-25-why-you-should-use-gitlab.md | 197 +++++++++++++++++++++++++
 1 file changed, 197 insertions(+)
```

However, what we won't see in this output is any file renames that may have occured, or any history for those renames. For instance, the bottom commit is actually a rename, which we can see when we `git show` that commit:

```
$ git show 5239f250d87cbf9ca27097ce7ff482f2a45814ae
commit 5239f250d87cbf9ca27097ce7ff482f2a45814ae
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Mar 25 10:36:57 2017 +0000

    Promote: Why-GitLab article

diff --git a/_drafts/why-you-should-use-gitlab.md b/_posts/2017-03-25-why-you-should-use-gitlab.md
similarity index 100%
rename from _drafts/why-you-should-use-gitlab.md
rename to _posts/2017-03-25-why-you-should-use-gitlab.md
```

This can be quite annoying, and if the file has been refactored multiple times, you manually have to trace these changes through.

Alternatively, we can take advantage of the `--follow` flag in `git log`, which as per the man pages:

> --follow: Continue listing the history of a file beyond renames (works only for a single file).

If we use this flag on the same above command:

<asciinema-player src="/casts/git-log-file-renames/follow.json"></asciinema-player>

```
$ git log --follow --stat _posts/2017-03-25-why-you-should-use-gitlab.md
commit 28e1ba234e887c01da3e8d62571dac1f6215612d
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sun Aug 5 18:37:58 2018 +0100

    Correct incorrectly-cased GitHub

    As part of #206.

 _posts/2017-03-25-why-you-should-use-gitlab.md | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

commit be85ad604f4a0f1bb9a5892c3651abfc375ea28a
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sun Apr 8 20:52:36 2018 +0100

    Add GitLab logo for sharing metadata

    Closes #244.

 _posts/2017-03-25-why-you-should-use-gitlab.md | 1 +
 1 file changed, 1 insertion(+)

commit 545d1d80963083a34781fa700e08bd2cd5403033
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Jul 8 23:05:41 2017 +0100

    Remove link for deleted Google Doc

    Turns out GitLab have now deleted the article - so we shouldn't be
    linking to it any more as our tests will fail.

 _posts/2017-03-25-why-you-should-use-gitlab.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 550c90d37a86283c080213054483f6d54133f890
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Apr 22 19:42:11 2017 +0100

    Add/fix categories

    Some of the posts don't quite fit in with the right categories.

 _posts/2017-03-25-why-you-should-use-gitlab.md | 1 +
 1 file changed, 1 insertion(+)

commit 3304581bdc8d58560f3fe2e7c1803607d23aaf11
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Mar 25 10:51:09 2017 +0000

    Capitalise `Lab` in GitLab

    Looks like it's been wrong all this time - would be embarrassing if this
    was posted and it was wrong.

 _posts/2017-03-25-why-you-should-use-gitlab.md | 78 +++++++++++++-------------
 1 file changed, 39 insertions(+), 39 deletions(-)

commit 6e777721c9fee2ee29aff80f613dbf0b884a056f
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Mar 25 10:47:47 2017 +0000

    Fix link on Why-GitLab article

 _posts/2017-03-25-why-you-should-use-gitlab.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 51bb45c770913117650a9b8f1319bc375e518986
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Mar 25 10:45:10 2017 +0000

    Remove TODO from Why-GitLab article

 _posts/2017-03-25-why-you-should-use-gitlab.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 5239f250d87cbf9ca27097ce7ff482f2a45814ae
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Mar 25 10:36:57 2017 +0000

    Promote: Why-GitLab article

 _drafts/why-you-should-use-gitlab.md => _posts/2017-03-25-why-you-should-use-gitlab.md | 0
 1 file changed, 0 insertions(+), 0 deletions(-)

commit 9d0cf783edff2796063a63fd23aecf90da48eb67
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Mar 25 10:36:14 2017 +0000

    Add Why-GitLab article description

 _drafts/why-you-should-use-gitlab.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit deeb7f29fad8b8fb1cbf1f498702eb7cc07a50a7
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Mar 25 10:30:47 2017 +0000

    Finalise Why-GitLab article

 _drafts/why-you-should-use-gitlab.md | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

commit c1dce562e4a49f62239a97f2d49dc5aa26e85843
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Mar 25 09:22:23 2017 +0000

    Fix image title text

 _drafts/why-you-should-use-gitlab.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 99363f9d0d043bcd0f2a80d8cf79b650300ebf46
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sat Mar 25 09:15:13 2017 +0000

    Almost finalise Why-GitLab article

 _drafts/why-you-should-use-gitlab.md | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

commit 65409c97942cdb2f5981226742ad9f08d9eb9bb3
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Wed Mar 22 01:03:42 2017 +0000

    Almost finish Why-GitLab article

 _drafts/why-you-should-use-gitlab.md | 87 +++++++++++++++++++++++++++---------
 1 file changed, 66 insertions(+), 21 deletions(-)

commit 091e03ab120d41e8b5db77353abb4693510bc3e0
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Tue Mar 21 21:48:40 2017 +0000

    Update Why-GitLab article

 _drafts/why-you-should-use-gitlab.md | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

commit 3ae1c29d6280b814c11b6140fe6834ef832f6ccb
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Tue Mar 21 18:37:05 2017 +0000

    Update Why-GitLab article

 _drafts/why-you-should-use-gitlab.md | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

commit f8b969c5ece43b5a4e07df95d3be57a8ac9e91ff
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Tue Mar 21 11:58:07 2017 +0000

    Update Why-GitLab article

 _drafts/why-you-should-use-gitlab.md | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

commit 82ebf4039c25cbc17622438a3a872a76c57b59b0
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Sun Mar 19 12:54:53 2017 +0000

    Update Why-GitLab article

 _drafts/why-you-should-use-gitlab.md | 37 ++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

commit a5d59ec5070fd92b8c90592264cb009ff603fc30
Author: Jamie Tanna <jamie@jamietanna.co.uk>
Date:   Fri Mar 17 00:24:53 2017 +0000

    Add initial work for Why-GitLab article

 _drafts/why-you-should-use-gitlab.md | 51 ++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
```

We can see that now we can see the various commits made to the file before and after file renames!

Note that in these examples we're using `--stat` as a way to demonstrate the files changed as part of a commit, but they are not required for the `--follow` flag.
