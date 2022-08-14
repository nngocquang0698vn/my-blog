---
title: "Learning a new language, or how I gained familiarity with Go"
description: "How I've eased into a new language, Go, as a Senior Software Engineer,\
  \ and some initial thoughts on the language."
date: "2022-08-12T15:58:06+0100"
syndication:
- "https://twitter.com/JamieTanna/status/1558108436176445443"
tags:
- "go"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "https://media.jvt.me/b41202acf7.png"
slug: "learning-new-language-go"
---
Every so often, engineers need to pick up a new language. After ~6 years of professional development using Java, with a bit of Ruby sprinkled in, coming to [Deliveroo](https://deliveroo.engineering) meant that I'd be starting to work on some Go codebases.

So when it came to accepting the offer, I ended up thinking about getting started with learning Go, so I could hit the ground running.

I'd never used Go before in earnest, despite <span class="h-card"><a class="u-url" href="https://twitter.com/pascaldoesgo">Pascal</a></span>, one of my colleagues at Capital One, always recommending it. It was always something that interested me, but I was investing in my Java skills with side projects, and didn't want to split my focus too much.

After attending a talk last year, [Five reasons why you should use Golang](https://www.meetup.com/digitallincoln/events/281382077/), I tried to build a RESTful API with Go using the standard library, but found it quite cumbersome compared to powerful frameworks like Spring Boot in Java land, especially after only spending about an hour trying to write Go, reading very few docs 😅

But when the realisation of writing Go as part of my day job appeared, I leapt at the chance.

I've since had a few conversations with colleagues in the team, as well as other new starters about how I ended up getting to the point I could contribute with a fair amount of confidence, and thought I'd document it.

# Tour of Go

I started with [the Tour of Go](https://go.dev/tour/) to get a good overview of the language, understanding a bit more of the syntax, and give me a good basis to know what I'm looking at in the code. Although Go is a fairly readable language when you're not used to it, there were a few bits that I wanted to brush up on.

# `micropub`, a CLI tool for the Micropub standard

Next, as a practical learner, I needed to get my hands dirty.

I'd been thinking of building a command-line interface to interact with my [Micropub](https://micropub.spec.indieweb.org/) server, and as I've seen a few very nice command-line interfaces built with Go recently, I thought I'd give it a go.

I decided not to worry too much about how I was writing it, just focussing on building the first version, which would produce an implementation for uploading media files.

This focus allowed me to look at purely how [Cobra](https://github.com/spf13/cobra) and [Viper](https://github.com/spf13/viper) worked and get the command-line portion of the code sorted, focussing on the interface rather than on best practices. As an engineer I really do like to strive for engineering excellence, but especially as I was so new to the language, I didn't want to put too much pressure on myself.

I did end up keeping a nice set of domain boundaries in terms of the packages that I used, having a `cmd` package for the command-line interface, and a `core` package for the underlying code. I would've refactored to this after the fact, but doing it up front also helped me play a bit with how Go's class-less structure works.

This first piece also gave me a chance to write my first HTTP call in Go, which was convenient to have it available in the standard library! Next, I added the ability to re-authenticate, which gave me a chance to use the [golang.org/x/oauth2 package](https://pkg.go.dev/golang.org/x/oauth2). This really highlighted the beauty of having a powerful standard library (or standard library adjacent tools like the `/x/` packages) by being able to very easily get up and running without bringing in an external dependency.

But if it weren't for Go's type system, and the way it does [structural typing](https://en.wikipedia.org/wiki/Structural_type_system) (also known as compile-time [duck typing](https://en.wikipedia.org/wiki/Duck_typing)), this wouldn't be nearly as straightforward. Compared to Java, where a class needs to explicitly implement an interface, it took a little bit of time to get used to it, but it's been a bit of a game changer for me.

Once I had the core implementation ready, I was able to start focussing on writing some tests, and then improving the style of tests, which then lead into how Go's quality tooling works, and integrating with [SonarCloud](https://sonarcloud.io/project/overview?id=jamietanna_micropub-go).

Finally, with all of this in place, I could look at managing releasing using [GoReleaser](https://goreleaser.com/), and learn how to easily distribute cross-platform binaries for Go tools.

# Replacing common automation with Go

I like automating away a lot of common tasks, and as such have [several scripts in my dotfiles](https://gitlab.com/jamietanna/dotfiles-arch/-/tree/main/terminal/home/bin) to do things like pretty-print JSON, unpack and pretty-print a JSON Web Token, or convert a filename in my site's repo to a post URL.

These small pieces of automation are a huge part of my quality-of-life and improve my effectiveness, and because I rely on them heavily as well as being able to automate tasks where appropriate, it was important for me to get a chance to see what Go's like for automating. Although I wouldn't necessarily write scripts in Go, it gave me a chance to also work with some common things like JSON (de)serialisation, which is a common operation in my job!

# `shorten`, a CLI tool for Bitly URL shortening

For a while I'd been thinking about using my short domain `u.jvt.me` a bit more. It was originally mean to be more useful when I was posting to `jamietanna.co.uk`, but since my identity is now `www.jvt.me`, the shorter `u.` didn't make as much sense.

But regardless, I thought it'd be good as a chance to more easily shorten URLs, especially as I'd been wanting to look a bit more [generating Go code from OpenAPI](https://www.jvt.me/posts/2022/04/06/generate-go-client-openapi/), ahead of hoping to make use of OpenAPI-driven code generation in the new job.

This was [a very small script](https://gitlab.com/jamietanna/dotfiles-arch/-/blob/main/go/home/go/src/jvt.me/dotfiles/shorten/main.go) that's been written hackily, and gave me a chance to play with Viper on its own.

# Building a RESTful API

This then gets me up to time where I'd actually joined Deliveroo, and we were starting work on building a [OpenAPI-design first API](https://www.jvt.me/posts/2022/06/27/roo-openapi-design-first/), which was due to my experience and love for OpenAPI and code generation.

Even before we got around to writing the HTTP logic for the service, there was a lot of business logic to work on, which was great because I could focus on pure Go things, within the confines of a consistent Deliveroo package structure, with a number of things preconfigured like linting.

Then, progressing into implementing the code with the OpenAPI Go code generator, [oapi-codegen](https://github.com/deepmap/oapi-codegen), it gave me more experience about the perks of great interfaces. One of our first hiccups with it was realising that it didn't support the [gorilla/mux](https://github.com/gorilla/mux) HTTP server, which is a common choice at Deliveroo, so I ended up contributing those changes to the library.

As we started doing more with our code generation, and then our OpenAPI, a few more issues popped up, giving me more chances to contribute back to the project. These helped give me some more "real world" experience, and I got some great feedback from the maintainers.

# Podcasts

Incidentally while writing this post (on and off for a few weeks), I was listening to the then-latest Go time, ["Go for Beginners"](https://changelog.com/gotime/239) and there's some great Go-specific resources in there that are recommended.

I've been listening to a _lot_ of Go Time, and have passively learned a lot more about the language, its history, and of some great projects.

# Other resources that may have helped

When speaking to new joiners about learning a new language, I've mentioned [Learn X in Y minutes](https://learnxinyminutes.com/), as something I've used in the past to remind me how a language/tech stack works. Although I didn't use it for Go, I've since had a look back at it and I'd recommend it as a good reference.

# Thoughts on Go so far

I'm really enjoying how fast Go is. I'd heard this from everyone that this is one of the selling points, but it truly is fast both to develop and operate, and can run on _much_ lower resource usages than Java. I'm looking forward to retiring some of my Java APIs and replace them with Go, largely for cost saving purposes!

Not only is it super fast to build, test and run, but also to develop! As an avid Vim gone Neovim user, I'm now able to develop Go applications purely in my favourite editor, using [gopls](https://pkg.go.dev/golang.org/x/tools/gopls) as a language server, with [vim-go](https://github.com/fatih/vim-go) on top of it for some additional benefits like being able to auto-fill structs. Although I love the Jetbrains products and have enjoyed using IntelliJ for Java development, it's nice to be in a purely keyboard-driven editor, where I can use a host of other great plugins that fit my workflow.

As mentioned in the Micropub section above, having the structural type system has made been a bit of a game changer for me. This allows libraries to take consistent interfaces (usually containing just one or two methods), instead of in Java where you'd need to transform between types somehow, or have your library contain bindings for each and every flavour of i.e. HTTP client. This is improved further by having a lot of common things - like an HTTP client and server - inbuilt in the standard library, because not only does it make it simpler to get going, but because the common interfaces are defined, lots of other packages just target that, allowing you to write code using a library, but then seamlessly run it using the Go standard library!

Something that's touted is error handling, and writing lots of `if err != nil`, but I'm not _yet_ finding it awkward. I do actually really like that error handling is explicit, and you get to decide each and every time what could go wrong, and how we can handle it. I do wish that it was easier to know what types of errors may be returned from a given function though.

I've definitely found working with JSON a little awkward, with needing to specify the struct tags to specify which JSON key maps to which field in a struct. I understand the reason behind it, but it still feels a bit cumbersome if you need to hand-roll it. But fortunately, code generation is powerful and fairly straightforward, so we can use tools like [oapi-codegen](https://github.com/deepmap/oapi-codegen), [JSON to Go](https://github.com/mholt/json-to-go) or hand-written code generation to give us these instead of writing it all by hand.

I've really enjoyed how straightforward it is to [quickly throw together a code generation tool](https://www.jvt.me/posts/2022/06/26/go-custom-generate/) in Go, and there are some great tools that take advantage of this. Because it's so speedy to write and run, as well as being able to seamlessly ship it as part of your project's build process, we can automate a lot of boilerplate away if needed.

On the topic of boilerplate, I absolutely love oapi-codegen and [kin-openapi](https://github.com/get-kin/kin-openapi), the responsiveness of the other maintainers, and the fact that I didn't need to fully consider actually writing my own OpenAPI-compliant code generator because I could use some pre-built tools. It's made wokring on a design-first OpenAPI service super straightforward, helped win a lot of my team over, and I'm really happy to be helping with maintaining it too.

One thing that has been a little difficult is knowing what a "good" project structure looks like. I've read quite a few posts and listened to a few podcasts, and kinda got a good idea, and since joining Deliveroo I've got a bit more understanding on some "real world" examples. I think the main thing I've learned is it's not that important, nor is trying to split your package's files up really neatly - I tried to apply my Java-y experience of one file per struct/set of methods, but have realised it's a bit harder than that, so to embrace big `$package/$package.go`s until it makes sense to break them down.

Ignore the Gophers who say things like "don't bring in dependencies, and only use the standard library", because it's not super realistic, and, in my experience, you shouldn't be fighting the verbosity of Go's inbuilt test assertions when you can instead use something nice like [stretchr/testify](https://github.com/stretchr/testify).

I've not really dug into concurrency yet - both because I've not done much of it before, but also because I'm not yet needing to do much of it right now.

I've also found it very weird going back to Java and trying to type Go 😅 Over the weekend I was writing some Java and really struggling. It's amazing how quickly my muscle memory has disappeared.

# Conclusion

I'm very much a practical learner, and learn through doing. I found it pretty handy to be able to use a number of small side projects to gain a bit of familiarity with the language, then having a real-world RESTful API to build and Open Source library to improve to solidify my knowledge.
