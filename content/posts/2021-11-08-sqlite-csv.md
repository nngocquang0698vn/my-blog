---
title: "Querying and Interacting with CSV Files More Easily with SQLite"
description: "How to use `sqlite3` to parse and query comma-separated value files. "
date: 2021-11-08T10:29:25+0000
tags:
- blogumentation
- csv
- sqlite
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "sqlite-csv"
image: https://media.jvt.me/0cc01860d8.png
---
I've recently been interacting with a number of CSV files as a data source, and I wanted to fairly quickly query and sort through the data.

As I was looking to write a Ruby script (as it's my primary scripting language) to do I what I wanted, I wondered if I could convert it to an SQLite database for easier querying.

It turns out, absolutely - it's a feature of SQLite and is super straightforward!

Let's say that we have a CSV file called `links.csv`, and we want to import them.

Let's boot up SQLite by running `sqlite3` and then executing:

```sql
.mode csv
.import /path/to/links.csv table_name
```

(Note that you need to provide a CSV header, so SQLite imports each field in the correctly named column)

You can then see what the table gets created as:

```sql
.schema
```

This then produces an in-memory (but can be dumped to file, so you don't have to keep re-importing) SQL database that you can now query much more easily, i.e.:

```sql
SELECT COUNT(*) FROM table_name;
-- 192
```
