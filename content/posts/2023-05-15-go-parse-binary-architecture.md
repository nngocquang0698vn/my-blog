---
title: "Which OS and CPU architecture is this binary compiled for?"
description: "How to use Go to parse an arbitrary executable to work out the Operating System and CPU architecture it's compiled for."
tags:
- blogumentation
- go
date: 2023-05-15T10:44:46+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: go-parse-binary-architecture
image: https://media.jvt.me/b41202acf7.png
---
Let's say that we have three binaries, and we want to detect the Operating Systems and CPU architectures in use:

```
ls
dmd
dmd-darwin
dmd.exe
url
```

If we run this through [the `file` command](https://linux.die.net/man/1/file), we can see the following information:

```
$ file dmd
dmd: ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, BuildID[sha1]=85939f5f8c4d7fca5b91d0a7998c56a23467ed27, for GNU/Linux 3.2.0, with debug_info, not stripped
$ file dmd-darwin
dmd-darwin: Mach-O universal binary with 2 architectures: [x86_64:Mach-O 64-bit executable x86_64] [arm64]
dmd-darwin (for architecture x86_64):   Mach-O 64-bit executable x86_64
dmd-darwin (for architecture arm64):    Mach-O 64-bit executable arm64
$ file dmd.exe
dmd.exe: PE32+ executable (console) x86-64 (stripped to external PDB), for MS Windows
$ file url
url: Mach-O 64-bit executable arm64
```

However, let's say that we want to automagically determine this information as part of our Go binary, rather than relying on the `file` command being present.

Fortunately, Go's standard library includes [the `debug` package](https://pkg.go.dev/debug) which contains - for our use case - packages to help parse the three Operating System binaries we want to:

- [`debug/elf`](https://pkg.go.dev/debug/elf) for Executable and Linked Format (ELF) binaries used on Linux Operating Systems
- [`debug/macho`](https://pkg.go.dev/debug/macho) for Mach-O binaries used on Mac OS
- [`debug/pe`](https://pkg.go.dev/debug/pe) for Microsoft Windows Portable Executable (PE) binaries used on Windows

This allows us to write a program such as:

```go
package main

import (
	"debug/elf"
	"debug/macho"
	"debug/pe"
	"fmt"
	"log"
	"os"
)

func main() {
	if len(os.Args) != 2 {
		log.Fatal("Need more args")
	}
	command := os.Args[1]

	err := parseMac(command)
	if err != nil {
		log.Println("Doesn't look like a Mach-O file:", err)
	}

	err = parseMacUniversalBinary(command)
	if err != nil {
		log.Println("Doesn't look like a Mach-O Universal Binary:", err)
	}

	err = parseElf(command)
	if err != nil {
		log.Println("Doesn't look like an ELF file:", err)
	}

	err = parsePE(command)
	if err != nil {
		log.Println("Doesn't look like a PE file:", err)
	}
}

func parseMac(command string) error {
	f, err := macho.Open(command)
	if err != nil {
		return err
	}

	fmt.Printf("%s is a Mach-O binary with CPU architecture %v\n", command, f.Cpu.String())

	return nil
}

func parseMacUniversalBinary(command string) error {
	f, err := macho.OpenFat(command)
	if err != nil {
		return err
	}
	fmt.Printf("%s is a Mach-O universal binary with architectures: \n", command)
	for _, fa := range f.Arches {
		fmt.Printf("- %v\n", fa.Cpu.String())
	}

	return nil
}

func parseElf(command string) error {
	f, err := elf.Open(command)
	if err != nil {
		return err
	}

	fmt.Printf("%s is an Executable and Linked Format (ELF) binary with CPU architecture %v\n", command, f.Machine.String())

	return nil
}

func parsePE(command string) error {
	f, err := pe.Open(command)
	if err != nil {
		return err
	}

	fmt.Printf("%s is a PE binary with CPU architecture 0x%x\n", command, f.Machine)

	return nil
}
```

Which then gives us the following output:

```
$ go run main.go tmp/dmd
2023/05/15 10:39:54 Doesn't look like a Mach-O file: invalid magic number in record at byte 0x0
2023/05/15 10:39:54 Doesn't look like a Mach-O Universal Binary: invalid magic number in record at byte 0x0
tmp/dmd is an Executable and Linked Format (ELF) binary with CPU architecture EM_X86_64
$ go run main.go tmp/dmd-darwin
2023/05/15 10:39:56 Doesn't look like a Mach-O file: invalid magic number in record at byte 0x0
tmp/dmd-darwin is a Mach-O universal binary with architectures:
- CpuAmd64
- CpuArm64
2023/05/15 10:39:56 Doesn't look like an ELF file: bad magic number '[202 254 186 190]' in record at byte 0x0

# note that unfortunately PE executables don't have a lookup table
$ go run main.go tmp/dmd.exe
2023/05/15 10:40:00 Doesn't look like a Mach-O file: invalid magic number in record at byte 0x0
2023/05/15 10:40:00 Doesn't look like a Mach-O Universal Binary: invalid magic number in record at byte 0x0
2023/05/15 10:40:00 Doesn't look like an ELF file: bad magic number '[77 90 144 0]' in record at byte 0x0
dmd.exe is a PE binary with CPU architecture 0x8664
$ go run main.go url
url is a Mach-O binary with CPU architecture CpuArm64
2023/05/15 10:40:06 Doesn't look like a Mach-O Universal Binary: not a fat Mach-O file in record at byte 0x0
2023/05/15 10:40:06 Doesn't look like an ELF file: bad magic number '[207 250 237 254]' in record at byte 0x0
```
