---
title: "Moving talks.jvt.me to reveal-hugo"
description: "Migrating my custom Reveal.JS setup to using reveal-hugo."
categories:
- announcement
tags:
- announcement
- revealjs
- hugo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-02-17T00:00:00
slug: "moving-talks-to-reveal-hugo"
---
As part of the [Merge Request _Convert Reveal.JS slides to reveal-hugo_](https://gitlab.com/jamietanna/talks/merge_requests/18), [talks.jvt.me](https://talks.jvt.me) is now built using [Josh Dzielak](https://dzello.com/)'s project [reveal-hugo](https://github.com/dzello/reveal-hugo).

This makes the setup of the project much more simple, and means I now have a well tried-and-tested structure for creating [Reveal.JS](https://github.com/hakimel/reveal.js/) presentations.

As mentioned in the merge request description:

> Instead of using a homegrown, overly engineered setup for my slides, it's easier to re-use existing setup such as reveal-hugo, especially as I now use Hugo for jvt.me.

My original setup was creating [revealjs-starter](/projects/revealjs-starter/) which used Ruby's ERubis templating language with a custom YAML config file and a Rakefile to tie together the build process, which was then served with Rackup. Most of these would be symlinks from the starter project so there wouldn't need to be as much duplication, but it wasn't really the best practice for a lot of repetition.

This was partly as Ruby is my new favorite scripting language, but also as I didn't want to use something like [generator-reveal](https://github.com/slara/generator-reveal) as it was a bit Node-heavy and I wasn't a fan.

When I got used to my horrible Ruby setup, it was pretty straightforward to work with, but after months of not touching a presentation it was not as fun coming back to the repo, as I would have to re-learn how it all works.

As part of the move to reveal-hugo, it also meant that I needed to script the conversion of the existing setup to reveal-hugo's expected setup. And this migration needing quite a lot of scripting also showed just how bad the original setup was.

This also means I have the blazing fast speed of Hugo, as well as making it much easier to manage GitLab CI setup:

```diff
diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 9a3c41be7..319d22413 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -2,23 +2,22 @@ variables:
   GIT_SUBMODULE_STRATEGY: recursive

 stages:
   - deploy

 netlify:
   stage: deploy
   image: registry.gitlab.com/jamietanna/jvt.me/builder:master
   script:
-    - "./.ci/build-reveal-site.sh chef-infrastructure-as-cake"
-    - "./.ci/build-reveal-site.sh came-for-the-campus-stayed-for-the-community"
-    - "./.ci/build-reveal-site.sh overengineering-personal-website"
-    - "./.ci/build-reveal-site.sh free-open-source-software"
-    - "mkdir public"
-    - "touch public/index.html"
-    - "./.ci/deploy-reveal-site.sh chef-infrastructure-as-cake 'Chef: Infrastructure as Cake'"
-    - "./.ci/deploy-reveal-site.sh came-for-the-campus-stayed-for-the-community 'Came for the Campus, Stayed for the Community'"
-    - "./.ci/deploy-reveal-site.sh overengineering-personal-website 'Overengineering Your Personal Website - How I Learn Things Best'"
-    - "./.ci/deploy-reveal-site.sh free-open-source-software 'Free and Open Source Software'"
-    - apk add --update curl
+    - hugo -d public
     - curl https://github.com/netlify/netlifyctl/releases/download/v0.4.0/netlifyctl-linux-amd64-0.4.0.tar.gz -LO
     - tar xvf netlifyctl-linux-amd64-0.4.0.tar.gz
     - ./netlifyctl deploy -s b758cf8f-9eeb-4770-ba63-ce7defafe8f6 -P public -A $NETLIFY_ACCESS_TOKEN
```

Which wasn't very scalable, as each new presentation requires a build step _and_ a deploy step.

Where I previously had these two files to orchestrate the build steps `.ci/build-reveal-site.sh`:

```sh
#!/usr/bin/env sh

cd "$1"
# Install front-end dependencies
npm install
./node_modules/bower/bin/bower --allow-root install
# install rake+erubis
bundle install --path vendor/bundle
bundle exec rake
```

Which is then "deployed" by `.ci/deploy-reveal-site.sh` into the right folder, and adding a link to the `index.html`:

```sh
#!/usr/bin/env sh

# `-L` to resolve symlinks and output the files as they are
cp -LR "$1/out" "public/$1"
mv "public/$1/slides.html" "public/$1/index.html"
echo "<a href='$1/'>$2</a>" >> public/index.html
```

reveal-hugo also has an easier ability to customize the setup for Reveal.JS itself on a per-presentation basis which is much easier than the existing setup I had which wasn't as flexible.

I'm really enjoying the developer experience of reveal-hugo in comparison to my existing setup!
