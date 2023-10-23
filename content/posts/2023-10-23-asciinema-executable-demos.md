---
title: "Building resilient, runnable command-line demos with Asciinema and `demo`"
description: "How to use the `demo` library alongside Asciinema to make it easier to build and maintain demos for your command-line tools."
tags:
- blogumentation
- command-line
date: 2023-10-23T21:47:13+0100
license_prose: CC-BY-NC-SA-4.0
license_code: MIT
slug: asciinema-executable-demos
---
In my opinion one of the harder aspects of building command-line tools is crafting demos for your tooling that show off the functionality you've built, and then _keeping them up-to-date_.

This two-fold problem is one that I've recently found a very good solution, and after [Changelog did an interview about Asciinema](https://changelog.com/podcast/561), I thought I should definitely get down to blogging about it.

I've been using [Asciinema](https://asciinema.org) since 2017, and really love it as a way to record demos of command-line tooling, and I've used it across a number of blog posts and talks since then.

Although Asciinema solves the ability to record demos, it doesn't solve the ability to keep the demos up to date. To do this, we need to be able to script the demos, so they're much easier to re-record.

Now, we could wrap the command(s) we want to demo in a shell script, but for something a little more jazzy and featureful, we can use a library I came across in April, [github.com/saschagrunert/demo](https://github.com/saschagrunert/demo).

Using `demo` gives us a lightweight framework for running commands, which allows us to add comments to command(s), as well as running the demos more easily.

For instance, we can write the following program:

```go
package main

import "github.com/saschagrunert/demo"

func main() {
	// Create a new demo CLI application
	d := demo.New()

	// Register the demo run
	d.Add(example(), "demo-0", "just an example demo run")

	// Register the demo run
	d.Add(ls(), "demo-1", "ls the current directory")

	// Run the application, which registers all signal handlers and waits for
	// the app to exit
	d.Run()
}

// example is the single demo run for this application
func example() *demo.Run {
	// A new run contains a title and an optional description
	r := demo.NewRun(
		"Demo Title",
		"Some additional",
		"multi-line description",
		"is possible as well!",
	)

	// A single step can consist of a description and a command to be executed
	r.Step(demo.S(
		"This is a possible",
		"description of the following command",
		"to be executed",
	), demo.S(
		"echo hello world",
	))

	// Commands do not need to have a description, so we could set it to `nil`
	r.Step(nil, demo.S(
		"echo without description",
		"but this can be executed in",
		"multiple lines as well",
	))

	// It is also not needed at all to provide a command
	r.Step(demo.S(
		"Just a description without a command",
	), nil)

	return r
}

func ls() *demo.Run {
	r := demo.NewRun(
		"Let's just run `ls`",
	)

	r.Step(demo.S(
		"First, a `sleep`",
	), demo.S(
		"sleep 1",
	))

	r.Step(demo.S(), demo.S(
		"ls",
	))

	return r
}

```

Then, we can run this interactively using the CLI:

```sh
go run main.go -0
```

This shows:

<asciinema-player src="/casts/asciinema-executable-demos/example.json"></asciinema-player>

Or for a different demo:

```sh
go run main.go -1
```

This then shows:

<asciinema-player src="/casts/asciinema-executable-demos/interactive.json"></asciinema-player>

Alternatively, we can run it non-interactively:

```sh
go run main.go -1 -i -a -t0
```

Which runs like so:

<asciinema-player src="/casts/asciinema-executable-demos/auto.json"></asciinema-player>

As we can see, this can be quite useful with being able to codify multiple types of examples, and add optional descriptions.

Combining Asciinema and `demo` can result in a much easier means for building and maintaining your command-line tools' documentation.

Since discovering it, I've found this to be a key part of dependency-management-data's [examples](https://dmd.tanna.dev/example/). The great thing about using `demo` is that you can even run these examples as part of your build pipeline. As part of dependency-management-data, these demos provide a full integration test for common use-cases.
