---
title: "Providing a basic implementation of Ruby's `ARGF.read` in Go"
description: "Creating a Go helper method to read from `stdin` or a file, inspired by Ruby's `ARGF.read` method."
tags:
- blogumentation
- go
- ruby
date: 2022-03-22T11:22:30+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: go-argf-read
image: https://media.jvt.me/b41202acf7.png
syndication:
- "https://brid.gy/publish/twitter"
---
While I write more Go command-line utilities, I find that I'm generally reading from `stdin`, but sometimes need to read input from files.

I was happy using file redirection in my shell, for instance:

```sh
$ ./helper <<< stdin
$ ./helper < file.txt
```

As a lot of my scripts are using Ruby, as a better alternative to Bash scripting, I learned that `ARGF.read` is a great alternative to this, where instead of the user of a script needing to invoke based on whether they were using a file or `stdin`, we can instead read from either much more easily.

For instance:

```sh
$ ruby -e 'puts ARGF.read' <<< "this is stdin"
this is stdin
$ ruby -e 'puts ARGF.read' file.txt
This is from a file
$ ruby -e 'puts ARGF.read' file.txt - <<< "this is stdin"
This is from a file
this is stdin
```

Although [`ARGF.read` can do a lot more](https://thoughtbot.com/blog/rubys-argf), I generally use it for a single file.

As I'm writing a lot more Go at the moment, I wanted something similar, so I've come up with the following method to read from `stdin` or a file on the command-line arguments if present:

```go
func ArgfRead() (string, error) {
	var bytes []byte
	var err error

	if len(os.Args) >= 2 {
		bytes, err = os.ReadFile(os.Args[1])
	} else {
		bytes, err = io.ReadAll(os.Stdin)
  }

	if err != nil {
		return "", err
	}
	return strings.TrimSuffix(string(bytes), "\n"), nil
}
```
