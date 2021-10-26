---
title: "Listing Which GitHub Pull Requests are in a Project"
description: "How to list the PRs inside a Project on Github, for example, via a Ruby client."
tags:
- blogumentation
- github
- github-projects
- ruby
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-10-26T09:20:14+0100
slug: "github-api-list-projects"
image: /img/vendor/GitHub_Logo.png
---
Let's say that you want to list the pull requests that are in a given GitHub Project board.

Unfortunately, there's no handy way that is provided as part of the API, so we need to get a little creative.

First, you'll need to generate a personal access token with at least the `public_repo` scope.

For instance, we'll use [Wiremock 2.29.0](https://github.com/wiremock/wiremock/projects/4) as an example.

Next, we'll need to discover this project boards' project ID for the API:

```sh
curl \
  -H "Authorization: Bearer ..." \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/wiremock/wiremock/projects
[
  {
    "owner_url": "https://api.github.com/repos/wiremock/wiremock",
    "url": "https://api.github.com/projects/12649878",
    "html_url": "https://github.com/wiremock/wiremock/projects/4",
    "columns_url": "https://api.github.com/projects/12649878/columns",
    "id": 12649878,
    "node_id": "MDc6UHJvamVjdDEyNjQ5ODc4",
    "name": "WireMock 2.29.0",
    "body": "New features + fixes for the v2.29.0 release.",
    "number": 4,
    "state": "open",
    "creator": {
      ...
    },
    "created_at": "2021-06-10T14:56:59Z",
    "updated_at": "2021-06-30T16:18:09Z"
  }
]
```

Now we have the `id`, we can start to list all the cards on the project.

We do this by listing all the columns on the project, then each of the cards on the columns - unfortunately it's a little wasteful, and on larger boards could be quite slow.

We then take advantage of the fact that if an Issue/PR is tagged against a project, the card's contents is just the URL of the Issue/PR, so we can filter for anything with this present.

Next, we will want to make sure that the provided URL is actually a PR, not an Issue, so we query the PR API to validate that it is a PR.

For instance, using the [Ruby GitHub Gem](https://piotrmurach.github.io/github/), the code would look like the following:

```ruby
require 'github_api'

board_id = ARGV[0]
github = Github.new oauth_token: ENV['TOKEN']

github.projects.columns.list(board_id) do |col|
  pulls = github.projects.cards.list(col.id).filter_map do |card|
    next unless card.content_url
    next unless card.content_url.include? '/issues/'

    parts = card.content_url.split '/'
    # need to filter for things that are actually PRs, as they have the same `/issues/` URL as an Issue URL
    begin
      pr = github.pull_requests.get parts[4], parts[5], parts[-1]
      pr.html_url
    rescue Github::Error::NotFound
      # almost certainly was an Issue, not a PR, so we can ignore it
      next
    end
  end
  next if pulls.empty?

  jj pulls
end
```

We then can run this with:

```sh
env TOKEN=... ruby list-project.rb 12649878
```

And it'll dump out the HTML URLs of the PRs that are part of that project!

```json
[
  "https://github.com/wiremock/wiremock/pull/1378",
  "https://github.com/wiremock/wiremock/pull/1376"
]
```

You can hopefully see other opportunities, like filtering based on the column that a project is in, so we can query for i.e. PRs that in the "done" column, or to list all the Projects a PR can be found in.
