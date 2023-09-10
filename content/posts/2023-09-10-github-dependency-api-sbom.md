---
title: "Prefer using the GitHub Software Bill of Materials (SBOMs) API over the Dependency Graph GraphQL API"
description: "Why you should use GitHub's Software Bill of Materials API instead of the Dependency Graph GraphQL API."
date: 2023-09-10T20:52:26+0100
tags:
- blogumentation
- github
- graphql
- sbom
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/36fd7d2a48.png
slug: github-dependency-api-sbom
---
As mentioned in [_Analysing our dependency trees to determine where we should send Open Source contributions for Hacktoberfest_](https://www.jvt.me/posts/2022/09/29/roo-hacktoberfest-dependency-analysis/), GitHub has a [dependency graph GraphQL API](https://docs.github.com/en/graphql/overview/schema-previews#access-to-a-repositorys-dependency-graph-preview) which allows retrieving the dependency graph for a given repository.

However, the format of the data can be quite awkward to work with. For instance with a Go module:

```json
{
  "data": {
    "repository": {
      "dependencyGraphManifests": {
        "totalCount": 7,
        "edges": [
          {
            "node": {
              "filename": "go.mod",
              "dependencies": {
                "totalCount": 87,
                "nodes": [
                  {
                    "packageName": "github.com/andybalholm/brotli",
                    "packageManager": "GO",
                    "requirements": "= 1.0.5"
                  }
                ]
              }
            }
          }
        ]
      }
    }
  }
}
```

Or with a Ruby gem:

```json
{
  "data": {
    "repository": {
      "dependencyGraphManifests": {
        "totalCount": 3,
        "edges": [
          {
            "node": {
              "filename": "indieweb-endpoints.gemspec",
              "dependencies": {
                "totalCount": 3,
                "nodes": [
                  {
                    "packageName": "http",
                    "packageManager": "RUBYGEMS",
                    "requirements": "~> 5.0"
                  },
                  {
                    "packageName": "link-header-parser",
                    "packageManager": "RUBYGEMS",
                    "requirements": "~> 5.0"
                  },
                  {
                    "packageName": "nokogiri",
                    "packageManager": "RUBYGEMS",
                    "requirements": ">= 1.13"
                  }
                ]
              }
            }
          }
        ]
      }
    }
  }
}
```

We can see that the `requirements` field can be a little awkward to consume, as it doesn't provide the exact version number as-is.

However, if we use the [Software Bill of Materials (SBOMs) endpoint](https://docs.github.com/en/rest/dependency-graph/sboms?apiVersion=2022-11-28), we instead receive:

```json
{
  "sbom": {
    "packages": [
      {
        "SPDXID": "SPDXRef-go-github.com-andybalholm-brotli-1.0.5",
        "name": "go:github.com/andybalholm/brotli",
        "versionInfo": "1.0.5",
        "downloadLocation": "NOASSERTION",
        "filesAnalyzed": false,
        "supplier": "NOASSERTION",
        "externalRefs": [
          {
            "referenceCategory": "PACKAGE-MANAGER",
            "referenceLocator": "pkg:golang/github.com/andybalholm/brotli@1.0.5",
            "referenceType": "purl"
          }
        ]
      }
    ]
  }
}
```

Or with a Ruby gem:

```json
{
  "sbom": {
    "SPDXID": "SPDXRef-DOCUMENT",
    "spdxVersion": "SPDX-2.3",
    "packages": [
      {
        "SPDXID": "SPDXRef-rubygems-http",
        "name": "rubygems:http",
        "versionInfo": "~> 5.0",
        "downloadLocation": "NOASSERTION",
        "filesAnalyzed": false,
        "supplier": "NOASSERTION"
      },
      {
        "SPDXID": "SPDXRef-rubygems-nokogiri",
        "name": "rubygems:nokogiri",
        "versionInfo": ">= 1.13",
        "downloadLocation": "NOASSERTION",
        "filesAnalyzed": false,
        "supplier": "NOASSERTION"
      },
      {
        "SPDXID": "SPDXRef-rubygems-link-header-parser",
        "name": "rubygems:link-header-parser",
        "versionInfo": "~> 5.0",
        "downloadLocation": "NOASSERTION",
        "filesAnalyzed": false,
        "supplier": "NOASSERTION"
      }
    ]
  }
}
```

We don't get exact versions when we're using a repo that doesn't use a lockfile, so it isn't always the most actionable response, but it's better than what we had before, and the use of the SPDX-2.3 format means there's much better library support to allow consuming the data more easily.
