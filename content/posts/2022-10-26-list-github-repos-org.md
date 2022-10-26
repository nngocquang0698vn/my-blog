---
title: "Listing all GitHub repositories in a GitHub Organisation"
description: "How to use the GraphQL API to list all the repositories that can be found in a given GitHub organisation."
date: 2022-10-26T14:21:57+0100
tags:
- blogumentation
- github
- graphql
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/36fd7d2a48.png
slug: list-github-repos-org
---
In my post [_Analysing our dependency trees to determine where we should send Open Source contributions for Hacktoberfest_](https://www.jvt.me/posts/2022/09/29/roo-hacktoberfest-dependency-analysis/#listing-repositories-to-scan), I mentioned that it can be handy to list all the repositories in a given GitHub organisation, to perform queries against them.

The previous solution I had was pretty awkward, and wasteful as it queried a lot of data via the RESTful API which it didn't then use. Fortunately, I've since dug into the GraphQL endpoint which allows us to query exactly what we need, which means we can write the following query, using the very handy [auto-paginating GraphQL Octokit plugin](https://www.npmjs.com/package/@octokit/plugin-paginate-graphql):

```javascript
const fs = require("fs");
const { Octokit } = require("@octokit/core");
const { paginateGraphql } = require("@octokit/plugin-paginate-graphql");
const MyOctokit = Octokit.plugin(paginateGraphql);
const octokit = new MyOctokit({ auth: process.env.GITHUB_TOKEN });

(async () => {
const resp = await octokit.graphql.paginate(
  `query paginate($cursor: String) {
    organization(login: "deliveroo") {
      repositories(first: 100, orderBy: {field: NAME, direction: ASC},
after: $cursor) {
        nodes {
          name
        }
        pageInfo {
          hasNextPage
          endCursor
        }
      }
    }
  }`
);

/*
resp = {
  organization: {
    repositories: {
      nodes: [
        {
          name: "deliveroo.engineering"
        },
        {
          name: "determinator"
        }
      ],
      pageInfo: {
        hasNextPage: false,
        endCursor: '...'
      }
    }
  }
}
*/

fs.writeFileSync('repos.txt', resp.organization.repositories.nodes.map((o) => o.name).join("\n"));
})();
```

When running this like so:

```sh
env GITHUB_TOKEN=... node get-repos.js
```

This then produces a file with one repo name per line, which is example what we wanted in the previous article.
