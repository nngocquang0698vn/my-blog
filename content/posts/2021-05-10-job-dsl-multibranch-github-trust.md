---
title: "Configuring a Jenkins Multibranch Pipeline to Specify the Trust Permissions with Job DSL"
description: "How to specify the trust permissions for a GitHub project on a Jenkins Multibranch pipeline, when using Job DSL."
tags:
- blogumentation
- jenkins
- job-dsl
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-05-10T15:49:03+0100
slug: "job-dsl-multibranch-github-trust"
image: /img/vendor/jenkins.png
---
When creating a Jenkins Multibranch pipeline, you may find that you want to tweak the permissions that are used to allow specifying whether you want to trust PRs from only people with Write/Admin access to a repo, everyone, or no one.

If your repos are public, then this is more of an issue as seen recently with [crypto-mining on GitHub.com](https://techxplore.com/news/2021-04-github-crypto-mining-campaign-exploiting-server.html) as well as various repeated attempts at hacking infrastructure by modifying Jenkins configuration in repos, which are then run unsandboxed on a remote build agent.

If you want to configure this with Job DSL, you'll find that it's not actually possible out-of-the-box with the DSL. However, we've got [emerino's answer on Stack Overflow](https://stackoverflow.com/a/52999384) and [Ivan's comment on JIRA](https://issues.jenkins.io/browse/JENKINS-63788?focusedCommentId=404597#comment-404597) to help us:

```groovy
multibranchPipelineJob('...') {
  configure {
    def traits = it / navigators / 'org.jenkinsci.plugins.github__branch__source.GitHubSCMNavigator' / traits
      traits << 'org.jenkinsci.plugins.github_branch_source.ForkPullRequestDiscoveryTrait' {
        strategyId 2
        trust(class: 'org.jenkinsci.plugins.github_branch_source.ForkPullRequestDiscoveryTrait$TrustEveryone') // this is the most open, and likely not required unless you're in a completely private GitHub environment!
      }
    // note that these also are required, otherwise it leads to only the `ForkPullRequestDiscoveryTrait` being taken into account
    traits << 'org.jenkinsci.plugins.github_branch_source.BranchDiscoveryTrait' {
      strategyId 1
    }
    traits << 'org.jenkinsci.plugins.github__branch__source.OriginPullRequestDiscoveryTrait' {
      strategyId 2
    }
  }
}
```

Note that the IDs can be discovered from the GitHub branch source plugin's source code.
