---
title: "Checking the migration status with `golang-migrate`"
description: "How to check what version of the schema is curently applied when using `golang-migrate`."
tags:
- blogumentation
- go
- sql
date: 2023-06-19T09:04:56+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: golang-migrate-status
---
If you're using [`golang-migrate`](https://github.com/golang-migrate/migrate) to perform your database migrations, you may wonder how to check what the current state of your migrations is.

I recently found myself doing the same, but finding an absence of anything explicitly documenting this, so thought I'd [write it as a form of blogumentation](https://www.jvt.me/posts/2017/06/25/blogumentation/).

When running the `version` subcommand:

```sh
# for migrate v4.15.2
migrate -database "$DATABASE_URL" -path db/migrations version
```

We then receive the timestamp of the current migration state.

For instance, if we have the two migrations:

```
1481574547_create_users_table.up.sql
1481840000_alter_users_table.up.sql
```

The `version` subcommand reporting a `1481574547` would indicate that we have not yet applied `1481840000_alter_users_table`.
