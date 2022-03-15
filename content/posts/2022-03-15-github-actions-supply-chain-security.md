---
title: "Automagically Auditing GitHub (Actions) Security using OpenSSF Scorecards"
description: "How to use the OpenSSF Scorecards GitHub Action to audit your GitHub and GitHub Actions configuration, and a breakdown of some of the issues raised by it."
tags:
- blogumentation
- github
- github-actions
- security
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-03-15T15:03:43+0000
slug: "github-actions-supply-chain-security"
image: https://media.jvt.me/cdce072f1e.png
syndication:
- "https://brid.gy/publish/twitter"
---
In January, [GitHub blogged about _Reducing security risk in open source software with GitHub Actions and OpenSSF Scorecards V4_](https://github.blog/2022-01-19-reducing-security-risk-oss-actions-opensff-scorecards-v4/), which includes a means for further improving your GitHub repository management, as well as use of GitHub Actions.

In recent years, a lot of attacks have been [through the supply chain](https://securityintelligence.com/articles/supply-chain-attacks-open-source-vulnerabilities/), and a misconfigured GitHub repository or organisation can lead to attacks such as being able to [use GitHub Actions to auto-approve malicious PRs](https://portswigger.net/daily-swig/unresolved-github-actions-flaw-allows-code-to-be-approved-without-review), allowing bad actors to get code into the codebase.

As soon as I'd read the GitHub blog post, I set about applying it to projects at work. Over the last couple of months, it's been really beneficial, picking up a few gaps in security that aren't covered in the [GDS Way for GitHub Actions](https://gds-way.cloudapps.digital/standards/source-code.html#using-github-actions-and-workflows), which we aim to follow.

I thought I'd show you the process of how straightforward it is to set up, and some of the common issues that can get picked up.

We'll use [my `jamietanna/jamietanna` repo](https://github.com/jamietanna/jamietanna/tree/1677f8140a421da2636614a53e7bb881e6558f2c) as an example.

# Can I use it?

As per the note on [the GitHub Action](https://github.com/ossf/scorecard-action), it may not be usable if you've got a private repo:

<blockquote>The Scorecards GitHub Action is free for all public repositories. Private repositories are supported if they have <a href="https://docs.github.com/en/get-started/learning-about-github/about-github-advanced-security">GitHub Advanced Security</a>. Private repositories without GitHub Advanced Security can run Scorecards from the command line by following the <a href="https://github.com/ossf/scorecard#using-scorecards-1">standard installation instructions</a>.</blockquote>

# Setting it up

The documentation shared in GitHub's blog is pretty good, as well as the documentation [on the Action itself](https://github.com/ossf/scorecard-action#installation), so I won't repeat too much here.

## Creating the GitHub token

Although I don't think it is required, I'd recommend an Owner sets up the token for the access, and uses [this handy PR's tweak](https://github.com/ossf/scorecard-action/pull/145) to auto-fill the scopes required for the token.

## Adding the workflow

If we use the UI in GitHub Actions, we'll see the following YAML generated:

<details>

<summary><code>.github/workflows/main-scorecards-analysis.yaml</code></summary>

```yaml
name: Scorecards supply-chain security
on:
  # Only the default branch is supported.
  branch_protection_rule:
  schedule:
    - cron: '33 16 * * 1'
  push:
    branches: [ main ]

# Declare default permissions as read only.
permissions: read-all

jobs:
  analysis:
    name: Scorecards analysis
    runs-on: ubuntu-latest
    permissions:
      # Needed to upload the results to code-scanning dashboard.
      security-events: write
      actions: read
      contents: read

    steps:
      - name: "Checkout code"
        uses: actions/checkout@ec3a7ce113134d7a93b817d10a8272cb61118579 # v2.4.0
        with:
          persist-credentials: false

      - name: "Run analysis"
        uses: ossf/scorecard-action@c1aec4ac820532bab364f02a81873c555a0ba3a1 # v1.0.4
        with:
          results_file: results.sarif
          results_format: sarif
          # Read-only PAT token. To create it,
          # follow the steps in https://github.com/ossf/scorecard-action#pat-token-creation.
          repo_token: ${{ secrets.SCORECARD_READ_TOKEN }}
          # Publish the results to enable scorecard badges. For more details, see
          # https://github.com/ossf/scorecard-action#publishing-results.
          # For private repositories, `publish_results` will automatically be set to `false`,
          # regardless of the value entered here.
          publish_results: true

      # Upload the results as artifacts (optional).
      - name: "Upload artifact"
        uses: actions/upload-artifact@82c141cc518b40d92cc801eee768e7aafc9c2fa2 # v2.3.1
        with:
          name: SARIF file
          path: results.sarif
          retention-days: 5

      # Upload the results to GitHub's code scanning dashboard.
      - name: "Upload to code-scanning"
        uses: github/codeql-action/upload-sarif@5f532563584d71fdef14ee64d17bafb34f751ce5 # v1.0.26
        with:
          sarif_file: results.sarif
```

</details>

However, I'd recommend removing the comments for the version pinned hashes, as we've found that Dependabot won't update them automagically, so there's no point them staying and being forever incorrect.

# Outcomes

Once this runs, we can see 11(!) issues raised on this repo by Scorecards:

![Screenshot of the GitHub UI for the header of the jamietanna/jamietanna repo, with the Security tab showing 11 notifications](https://media.jvt.me/cbb162d346.png)

When browsing to the Code scanning alerts UI in GitHub we can see the following issues:

![A table view of the code scanning alerts in the GitHub UI, showing Code-Review (High), Token-Permissions (High), Dependency-Update-Tool (High), Security-Policy (Medium), SAST (Medium), Fuzzing (Medium), three entries for Pinned-Dependencies (Medium) and CII-Best-Practices (Low)](https://media.jvt.me/53313d2fba.png)

Let's go through them, to give you a feel for what these are. Note that the rules themselves also have a fair bit of detail in them too, which makes it easier to understand why they're asking you to make changes.

## `Code-Review` rule

In this repo, I've got branch protection purposefully turned off, and allow pushes from the GitHub Actions bot, as [the point of this repo is to be auto-updating](https://www.jvt.me/posts/2022/01/12/autogenerated-profile-readme/).

I've found that even when code review restrictions are required, if you're on a repo with very few regular committers, you'll have an issue flagged, as having fewer committers leads to high [lottery factor](https://vancelucas.com/blog/the-lottery-factor/).

## `Token-Permissions` rule

A common issue is that we default to tokens being able to read and write, allowing a malicious action to modify the repository.

In the [repo settings for Actions](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository#setting-the-permissions-of-the-github_token-for-your-repository) you can specify this:

![Workflow permissions in the repository settings, showing the default set to "Read and write permissions", and a second option "Read repository contents permission"](https://media.jvt.me/1b5f7af227.png)

This can be mandated at the organisation level, as well, but will likely break things expecting write access by default, so it's worth rolling it out carefully.

If you don't want to, or aren't able to do this, you can still make your Actions have a top-level permissions set, with the minimal permissions required using the [workflow-based configuration using `permissions`](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#modifying-the-permissions-for-the-github_token):

```yaml
permissions:
  contents: read
```

## `Dependency-Update-Tool` rule

In this case, I've not configured a tool like [Dependabot](https://github.com/dependabot) or [Whitesource Renovate](https://www.jvt.me/posts/2021/09/26/whitesource-renovate-tips/).

This isn't just important for keeping on top of security updates, but it's also handy to keep your projects using the latest versions of libraries for bug and feature releases, too, and helping spot when version upgrades introduce breaking changes.

## `Branch-Protection` rule

As mentioned above, because this repo is auto-updating, I don't want to enable branch protection or code review.

This check, as well as ensuring branch protection is set, also checks for required status checks on branches, as branch protection by default just removes force pushes, but doesn't stop anyone pushing broken code to i.e. `main`.

## `Security-Policy` rule

Because this repo doesn't have a `SECURITY.md`, and there isn't one present in an org-level `.github` repo, it's unclear for folks what the process is to raise security concerns.

## `SAST` rule

Static Analysis Security Testing is handy for picking up on common issues in codebases, and Scorecards explicitly looks for the [CodeQL GitHub Action](https://github.com/github/codeql-action).

As a lot of languages are supported, this is a straightforward one to fix, but can likely be ignored if you have a similar tool that's performing these checks for you.

## `Fuzzing` rule

To better understand and catch cases where invalid/unexpected input is entered into the application, we should be using fuzzing tools, such as using [Google's OSS-Fuzz](https://github.com/google/oss-fuzz).

## `Pinned-Dependencies` rule

This is an interesting one. I'm a big fan of version pinning libraries and tools to reduce the risk of breakage, but it for some reason doesn't copy over when I think about GitHub Actions tags.

The recommendation here is to make the following change:

```diff
 - name: Install Go
-  uses: actions/setup-go@v2
+  uses: actions/setup-go@bfdd3570ce990073878bf10f6b2d79082de49492
   with:
     go-version: '^1.17'
```

This means that we're definitely pinned to the version at that point in time, as the tag can be re-pushed at any time. This is useful because it means we don't need to do as many version updates, but also means that we could have a malicious dependency introduced in one build that then disappears in another.

When pinning to the hash, a tool like Dependabot can still produce [an automated bump in the future](https://github.com/co-cddo/federated-api-model/pull/127), so we don't have to deal with SHAs ourselves.

## `CII-Best-Practices` rule

This is [a more extensive set of checks](https://bestpractices.coreinfrastructure.org/en/criteria/0) to perform and is appropriately marked as a low priority issue.

I would definitely see this as something to strive towards, but not necessarily make a requirement straightaway.

# Conclusion

Hopefully you can see some of the benefits that are provided by using Scorecards' security scanning, without it being an exhaustive walk through all the rules that could flag up, and it can help you with securing your repositories further.
