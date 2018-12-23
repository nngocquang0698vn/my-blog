---
title: Executing an Interactive Python Shell (REPL) for a Script
description: 'Using `python -i` to get an interactive REPL after running a Python source file.'
categories: blogumentation
tags: cli python blogumentation tools howto
image: /img/vendor/python-logo-notext.png
no_toc: true
---
Sometimes you want to be able to get a [REPL][repl] (**R**ead **E**val **P**rint **L**oop) shell when running a Python script. This can help you interactively test manipulations of data and functions with your code, without having to amend your script, write the file, and then re-run it.

For this, you have two choices:

You can either run Python interactively, and `import` the file:

```sh
$ python
Python 3.6.4 (default, Jan  5 2018, 02:35:40)
[GCC 7.2.1 20171224] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import script
>>>
```

Alternatively, you can use `python -i`:

```sh
$ python -i script.py
```

For instance, given the Python source file `script.py`:

```python
def output(arg):
    print(arg)


output('hi')
```

Running `python -i`:

```sh
$ python -i script.py
hi
>>> output(1)
1
>>> output({ 'a': 'b' })
{'a': 'b'}
>>>
```

As you can see, we can now use the `output` function from the REPL. It also prints `hi`, as that code is executing due to it being within the main body of the code.

[repl]: https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop
