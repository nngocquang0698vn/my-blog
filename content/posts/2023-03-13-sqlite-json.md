---
title: "Querying JSON with SQLite"
description: "How to use `json_each` and `json_extract` to query a JSON field in SQLite."
date: 2023-03-13T21:43:02+0000
tags:
- blogumentation
- sqlite
- json
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "sqlite-json"
image: https://media.jvt.me/0cc01860d8.png
---
I really like the fact that a lot of the database engines are allowing for native JSON querying, not least with SQLite, as I'm using it for various projects at the moment.

However, I can _never_ seem to remember the incantation for how to actually perform the JSON query.

Let's say that we have the following schema and data:

```sql
CREATE TABLE data (
  id integer PRIMARY KEY,
  json TEXT,
  array TEXT
);

INSERT INTO data (json, array) VALUES('
{
  "name": "go",
  "depTypes": [
    "require",
    "indirect"
  ]
}',
  '[ "require", "indirect" ]'
);

INSERT INTO data (json, array) VALUES('
{
  "name": "ruby",
  "depTypes": [
    "dev"
  ]
}',
  '[ "dev" ]'
);
```

If we wanted to parse our `array` type, we could query:

```sql
select data.id, arr.value from data, json_each(data.array) as arr;
```

And if we wanted to query a JSON field within `json`, we could query:

```sql
select id, json_extract(data.json, '$.name') name from data;
```

And to query the `depTypes` array within `json`:

```sql
select data.id, depType.value from data, json_each(json_extract(data.json, '$.depTypes')) depType;
```
