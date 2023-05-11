# sync-github-repos

This repository is intended to sync GitHub Actions found in the marketplace to a separate GitHub organization, but it can be used to sync repositories in general as well.

Format of input file matches the [gh-actions-sync](https://docs.github.com/en/enterprise-server@3.8/admin/github-actions/managing-access-to-actions-from-githubcom/manually-syncing-actions-from-githubcom#example-using-the-actions-sync-tool) tool.

Syntax:

```csv
SOURCE_ORG/SOURCE_REPO:TARGET_ORG/TARGET_REPO
```

Example:

```csv
jfrog/setup-jfrog-cli:joshjohanning-org/setup-jfrog-cli
SonarSource/sonarqube-scan-action:joshjohanning-org/sonarqube-scan-action
azure/login:joshjohanning-org/azure-login

```

> **Note:**
> Make sure to leave a trailing space in the input file you create.
