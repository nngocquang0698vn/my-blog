---
title: "Introducing `snyk-export-sbom` to export SPDX and CycloneDX SBOM from Snyk"
description: "Creating a new command-line tool for more easily retrieving Software Bill of Materials (SBOMs) from Snyk, as well as adding licensing information to SBOMs."
tags:
- sbom
- snyk
date: 2023-11-15T12:07:19+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: snyk-export-sbom
image: https://media.jvt.me/488b9a8339.png
---
I've written about [Software Bill of Materials (SBOMs)](https://about.gitlab.com/blog/2022/10/25/the-ultimate-guide-to-sboms/) a [fair bit](/tags/sbom/) recently and how they can be used to get more insight into your project's dependencies

As part of starting to use Snyk at work, I've been looking at how to integrate Snyk's data alongside [dependency-management-data](https://dmd.tanna.dev), using the [SBOM import functionality in dependency-management-data](https://dmd.tanna.dev/cookbooks/getting-started-sbom/).

Snyk has had support for [exporting a project's SBOM](https://apidocs.snyk.io/?version=2023-03-20#get-/orgs/-org_id-/projects/-project_id-/sbom), which does most of the work 👏 However, one thing that `snyk-export-sbom` does on top of the existing offering is that it gives us the ability to add licensing information to the generated SBOMs.

This is currently available [on the legacy API](https://snyk.docs.apiary.io/#reference/licenses/licenses-by-organization/list-all-licenses) so we can take this data and interweave it with the SBOM that Snyk produces. I've raised a feature request to get licensing data added to the new APIs, or even automagically inserted into the SBOMs Snyk produces, but until then, we've at least got this functionality in my tool.

You can find the project [on GitLab.com](https://gitlab.com/tanna.dev/snyk-sbom-export), which can be installed with:

```sh
go install gitlab.com/tanna.dev/snyk-sbom-export@latest
```

Then you can run it like so:

```sh
env SNYK_API_TOKEN=... snyk-sbom-export -orgID ... -format cyclonedx1.4+json
```

This will then iterate through each of the projects in your organisation, generating an SBOM and adding any licensing information it knows about your dependencies.

Something I didn't realise until _after_ I've built it is that [SBOM export is only available for Open Source projects](https://docs.snyk.io/more-info/error-catalog#snyk-os-9004), which is a bit disappointing 😅 I'm considering [writing export functionality myself using the legacy APIs](https://gitlab.com/tanna.dev/snyk-sbom-export/-/issues/1) to make it possible to get SBOMs from the data that Snyk collects on your projects.
