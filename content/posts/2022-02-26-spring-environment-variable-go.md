---
title: Converting Spring Boot Property Variables to Environment Variables with Go
description: A command-line script to convert a Spring Boot property to an environment variable.
tags:
- blogumentation
- go
- command-line
- spring-boot
image:
date: 2022-02-26T21:26:07+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: spring-environment-variable-go
syndication:
- "https://brid.gy/publish/twitter"
image: /img/vendor/spring-logo.png
---
Since [I migrated my personal Spring Boot applications to run on Kubernetes](https://www.jvt.me/posts/2021/10/25/kubernetes-migration/), I've been using Spring Boot's [environment variables support](https://docs.spring.io/spring-boot/docs/2.6.4/reference/html/features.html#features.external-config.typesafe-configuration-properties.relaxed-binding.environment-variables) to configure the application.

After doing this manually for a while, I've found that it's time to automate it, so I've reached for Go as a means to provide a handy command-line program:

```go
package main

import (
	"fmt"
	"io"
	"os"
	"regexp"
	"strings"
)

func convert(s string) string {
	s = strings.ReplaceAll(s, ".", "_")
	s = strings.ReplaceAll(s, "-", "")

	listRe := regexp.MustCompile(`\[([0-9]+)\]`)
	s = listRe.ReplaceAllString(s, "_${1}_")

	s = strings.ReplaceAll(s, "__", "_")
	return strings.ToUpper(s)
}

func main() {
	data, err := io.ReadAll(os.Stdin)
	if err != nil {
		panic(err)
	}
	propertyAndValue := strings.Split(strings.TrimSuffix(string(data), "\n"), "=")

	if len(propertyAndValue) == 1 {
		fmt.Println(convert(propertyAndValue[0]))
	} else {
		fmt.Println(convert(propertyAndValue[0]) + "=" + propertyAndValue[1])
	}
}
```

That can be run like so, handling the property's value, as well as list-based configuration:

```sh
$ go run main.go <<< spring.main.log-startup-info
SPRING_MAIN_LOGSTARTUPINFO
$ go run main.go <<< spring.main.log-startup-info=1234.foo.bar
SPRING_MAIN_LOGSTARTUPINFO=1234.foo.bar
$ go run main.go <<< my.service[0].other
MY_SERVICE_0_OTHER
```

