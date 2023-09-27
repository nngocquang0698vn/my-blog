---
title: "Using dependency-management-data with GitLab's Pipeline-specific CycloneDX SBOM exports"
description: "How to take advantage of SBOM export functionality in GitLab 16.4 with dependency-management-data."
tags:
- dependency-management-data
- sbom
- gitlab
date: 2023-09-27T21:24:00+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: dmd-gitlab
image: https://media.jvt.me/c02cdf0130.png
---
Earlier today I spotted an exciting result in the changelog for the release of GitLab 16.4, which happened last Friday, which added [Pipeline-specific CycloneDX SBOM exports](https://about.gitlab.com/releases/2023/09/22/gitlab-16-4-released/#pipeline-specific-cyclonedx-sbom-exports)

When I was working on dependency-management-data's expanded offerings other than the original Renovate datasource, I had investigated GitLab's existing [Dependency List API](https://docs.gitlab.com/ee/api/dependencies.html) but did not proceed with it because the structure of the data wasn't ideal.

However, with the GitLab 16.4 release, the availability to use CycloneDX SBOMs is really awesome, because using an existing well-supported standard for this means it's already supported in dependency-management-data as part of [a release earlier this month](https://www.jvt.me/posts/2023/09/10/dmd-sbom-dependabot/) 🎉

So how do we take advantage of this? We can [follow the documentation](https://docs.gitlab.com/ee/api/dependency_list_export.html#create-a-pipeline-level-dependency-list-export) (which notes that this is an experimental feature!) and run:

```sh
$ export GITLAB_TOKEN=glpat...
$ curl --request POST --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://gitlab.com/api/v4/pipelines/1018856246/dependency_list_exports" --data "export_type=sbom"
{
  "download": "https://gitlab.com/api/v4/dependency_list_exports/1008825/download",
  "has_finished": false,
  "id": 1008825,
  "self": "https://gitlab.com/api/v4/dependency_list_exports/1008825"
}
```

Once processed, we can then download the resulting SBOM, and import it into dependency-management-data with:

```sh
dmd import sbom --db dmd.db sbom.json --platform gitlab --organisation tanna.dev --repo gitlab-example-security-reports
```

And it's that simple! We now have all the data available in dependency-management-data 👏

You can see the data that's available from this SBOM [in the example app](https://dependency-management-data-example.fly.dev/datasette/datasette/dmd/sboms?_sort=rowid&repo__exact=gitlab-example-security-reports&organisation__exact=tanna.dev&platform__exact=gitlab).
