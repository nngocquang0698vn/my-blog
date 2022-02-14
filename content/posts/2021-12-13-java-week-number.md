---
title: "Getting the Date from a Week Number in Java"
description: "How to get the date from a week number and year in Java."
tags:
- blogumentation
- java
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-13T20:33:47+0000
slug: "java-week-number"
image: https://media.jvt.me/7e70383567.png
---
When I started to publish week notes to my site through my Micropub server, I wanted to programmatically set up the metadata for a post, which looks like:

```yaml
title: "Week Notes 21#49"
description: "What happened in the week of 2021-12-06?"
```

In this case, we need the short year name, the week number, and the ISO8601 date for the Monday of that week.

Looking around for a way to do this in Java, I found that we can use `IsoFields` in conjunction with `LocalDate` to create the date, for instance:

```java
int year = 2020;
int week = 53;
LocalDate desiredDate =
  LocalDate.now()
  .withYear(year)
  // this doesn't work
  .with(IsoFields.WEEK_OF_WEEK_BASED_YEAR, week):

System.out.println(desiredDate);
```

Fortunately [this StackOverflow answer](https://stackoverflow.com/a/32186362) highlights that we can use `TemporalAdjusters.previousOrSame` to pick up the Monday of the week, like so:

```java
int year = 2020;
int week = 53;
LocalDate desiredDate =
  LocalDate.now()
  .withYear(year)
  .with(IsoFields.WEEK_OF_WEEK_BASED_YEAR, week)
  .with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));

System.out.println(desiredDate);
```
