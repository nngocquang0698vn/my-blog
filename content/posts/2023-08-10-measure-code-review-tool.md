---
title: "Analysing GitHub Pull Request review times with SQLite and Go"
description: "How measuring how long code review took as a team lead to being able to change our processes, and then deliver much more effectively."
tags:
- blogumentation
- sqlite
- go
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2023-08-10T20:20:00+0100
slug: "measure-code-review-tool"
---
In [_Improving Team Efficiency By Measuring and Improving Code Review Cycle Time_](https://www.jvt.me/posts/2021/10/27/measure-code-review/), I mentioned that one thing we can do to understand if code review is causing delays is to measure it.

Since then, I've also worked on building this at Deliveroo with one of my colleagues, just before we started using [PluralSight Flow](https://www.pluralsight.com/product/flow), which didn't quite give some of the metrics we wanted out of it.

With a bit of free time in my time between jobs, I thought I'd at least blogument the data fetching and parsing that I've found works, and so if anyone else goes to do this, they've got something to start with.

Unlike previous attempts I wanted to:

- build it as an Open Source project
- write it with Go
- use SQLite as the underlying datasource
- try building a CLI using [urfave/cli/](https://github.com/urfave/cli/)

The project can be found at [gitlab.com/tanna.dev/ghprstats](https://gitlab.com/tanna.dev/ghprstats), which has some docs on how to get started with it.

I'm not sure I'm quite happy with how I've internally implemented it, but happy it's done and I can iterate over it.

## How it works

At its core, we are using the following four APIs from GitHub to retrieve the data about a given Pull Request:

- [List reviews for a pull request](https://docs.github.com/en/rest/pulls/reviews?apiVersion=2022-11-28#list-reviews-for-a-pull-request)
- [List review comments on a pull request](https://docs.github.com/en/rest/pulls/comments?apiVersion=2022-11-28#list-review-comments-on-a-pull-request)
- [List issue comments](https://docs.github.com/en/rest/issues/comments?apiVersion=2022-11-28#list-issue-comments)
- [List timeline events for an issue](https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#list-timeline-events-for-an-issue)

These are then used to look at who is interacting with the changes, as well as using the timeline events to determine the state(s) the PR is in over time.

We fetch the data up-front and then sync it to the SQLite database, after which it can be queried or more easily distributed.

## What it looks like

For a few PRs worth of data, running `ghprstats report cycle-time` results in the following (converted to HTML table for ease of viewing):

<table class="go-pretty-table">
  <thead>
  <tr>
    <th>PR</th>
    <th>PR Title</th>
    <th>Changes</th>
    <th>Initial State</th>
    <th align="right"># Reviews</th>
    <th align="right"># Comments</th>
    <th>First Commenter</th>
    <th>Time to first comment</th>
    <th>First Reviewer</th>
    <th>Time to first review</th>
    <th>Second Commenter</th>
    <th>Time to second comment</th>
    <th>Second Reviewer</th>
    <th>Time to second review</th>
    <th>Time to close</th>
    <th>Merged?</th>
    <th>PR link</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td>snarfed/oauth-dropins#284</td>
    <td>Migrate IndieAuth to full authorization_code grant</td>
    <td>+82,-36 lines changed across 3 files</td>
    <td>ready</td>
    <td align="right">2</td>
    <td align="right">13</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>snarfed</td>
    <td>4768</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>7150</td>
    <td>true</td>
    <td>https://github.com/snarfed/oauth-dropins/pull/284</td>
  </tr>
  <tr>
    <td>cucumber/common#2024</td>
    <td>Add further examples for valid Cucumber files to pretty-print</td>
    <td>+108,-0 lines changed across 1 files</td>
    <td>ready</td>
    <td align="right">0</td>
    <td align="right">6</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>false</td>
    <td>https://github.com/cucumber/common/pull/2024</td>
  </tr>
  <tr>
    <td>deepmap/oapi-codegen#648</td>
    <td>Generate anonymous objects referenced in schemas</td>
    <td>+1303,-50 lines changed across 35 files</td>
    <td>draft</td>
    <td align="right">8</td>
    <td align="right">14</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>false</td>
    <td>https://github.com/deepmap/oapi-codegen/pull/648</td>
  </tr>
  <tr>
    <td>endoflife-date/endoflife.date#3330</td>
    <td>Remove Gorilla toolkit archiving</td>
    <td>+4,-3 lines changed across 1 files</td>
    <td>ready</td>
    <td align="right">1</td>
    <td align="right">4</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>marcwrobel</td>
    <td>187</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>188</td>
    <td>true</td>
    <td>https://github.com/endoflife-date/endoflife.date/pull/3330</td>
  </tr>
  </tbody>
</table>

With SQL access to the raw data, it may also be easier to run queries like the below to better understand the data.

For instance, how can we work out the most frequent approvers?

```sql
select
  login,
  count(author_id) as num_reviews
from
  reviews
  inner join users on author_id = users.id
where state = 'APPROVED'
group by
  author_id
order by
  num_reviews desc
limit 10

```

Or how can we find out which PRs started as a draft vs ready for review?

```sql
select
  pulls.owner,
  pulls.repo,
  pulls.id,
  title,
  (
    case
      when i.initial_state is null then 'ready'
      else i.initial_state
    end
  ) as initial_state
from
  pulls
  left join (
    select
      (
        case
          when event = 'ready_for_review' then 'draft'
          else 'ready'
        end
      ) as initial_state,
      timeline.created_at,
      timeline.owner,
      timeline.repo,
      pull_id
    from
      timeline
    where
      (
        event = 'ready_for_review'
        or event = 'convert_to_draft'
      )
    order by
      created_at asc
    LIMIT
      1
  ) i on pulls.owner = i.owner
  and pulls.repo = i.repo
  and pulls.id = i.pull_id;
```
