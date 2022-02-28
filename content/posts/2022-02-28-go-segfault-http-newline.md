---
title: "Gotcha: Segfault when HTTP headers include newlines with Go"
description: "Why you may be receiving a segfault when using `http.Client` with HTTTP headers that include newlines."
tags:
- blogumentation
- go
date: 2022-02-28T21:44:13+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: go-segfault-http-newline
image: https://media.jvt.me/b41202acf7.png
syndication:
- "https://brid.gy/publish/twitter"
---
I'm writing a Go program to allow me to upload images to my [Micropub server](/posts/2019/08/26/setting-up-micropub/) more easily from the command-line.

As part of this, I wanted to store my Micropub access token in a file, `~/.secrets/micropub.txt`, and read it at runtime.

The code is roughly the same as below:

```go
package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

func main() {
	content, err := ioutil.ReadFile(os.ExpandEnv("$HOME/.secrets/micropub.txt"))
	if err != nil {
		log.Fatal(err)
	}

	token := string(content)
	call("http://localhost:8080/micropub", token)
}

func call(urlPath string, accessToken string) {
	client := &http.Client{}

	req, err := http.NewRequest("GET", urlPath, nil)
	if err != nil {
		panic(err)
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("Authorization", "Bearer "+accessToken)
	rsp, _ := client.Do(req)
	if rsp.StatusCode != http.StatusOK {
		log.Println(rsp)
		log.Printf("Request failed with response code: %d", rsp.StatusCode)
	}
}
```

What was very odd is that when executing it, I was receiving the following segfault:

```
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x10 pc=0x5fc31d]

goroutine 1 [running]:
main.call({0x663a2c, 0x24}, {0xc00004ff38, 0x4})
	/home/jamie/workspaces/tmp/media-upload/main.go:31 +0x23d
main.main()
	/home/jamie/workspaces/tmp/media-upload/main.go:17 +0x9d
exit status 2
```

Those of you more clued up with Go may have spotted that I wasn't handling the `err` from `client.Do`, which if I was, it'd have told me:

```
panic: Get "http://localhost:8080/micropub/media": net/http: invalid header field value "Bearer eyJ...\n" for key Authorization

goroutine 1 [running]:
main.call({0x663a2c, 0x24}, {0xc00004ff38, 0x4})
        /home/jamie/workspaces/tmp/media-upload/main.go:32 +0x307
main.main()
        /home/jamie/workspaces/tmp/media-upload/main.go:17 +0x9d
exit status 2
```

The solution here is that we need to make sure we trim the newline from the end of the string:


```diff
 import (
 	"log"
 	"net/http"
 	"os"
+	"strings"
 )

 func main() {
 		log.Fatal(err)
 	}

-	token := string(content)
+	token := strings.TrimSuffix(string(content), "\n")
 	call("http://localhost:8080/micropub/media", token)
 }
```

As writing this post, I wonder if it's actually worth documenting, as it seems pretty standard and expected, but I thought I may as well hit publish as I'd gone to the effort of writing it up!
