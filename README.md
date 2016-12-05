# Infrastructure as code - Continuous Delivery of Cloudformation stacks

[![CircleCI](https://img.shields.io/circleci/project/github/NicolasRitouet/cloudformation-cd.svg)]()
[![MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

> Continuous Delivery of Cloudformation stacks using CodePipeline and Change-sets

## Description

This is a complete setup to enable continuous delivery of an infrastructure using Github PR for manual verification of a change-set.


## Getting started

Cloudformation parameters are stored in a file named `.env` at the root of the project.
```js
[
  { "ParameterKey": "Project", "ParameterValue": "cloudformation-cd" },
  { "ParameterKey": "oauthToken", "ParameterValue": "xxxxxxxxxxxx" },
  { "ParameterKey": "repo", "ParameterValue": "nicolasritouet/cloudformation-cd" },
  { "ParameterKey": "branch", "ParameterValue": "master" }
]
```

### Push a new stack

```bash
make create STACK=cloudformation-cd
```

### Update an existing stack

```bash
make update STACK=cloudformation-cd
```

### Display stack's output

```bash
make output STACK=cloudformation-cd
```

### Display stack's events

```bash
make watch STACK=cloudformation-cd
```

### Create a new change-set

```bash
make changeset STACK=cloudformation-cd
```

### Describe a change-set

```bash
make describe-changeset CHANGESET-NAME=name-of-changeset
```


### Test syntax of makefile

```bash
make test-syntax
```

### Todo

- loop over all stacks
- create the PR message (title as first line and rest as message based on change-set output)
- verify if a PR is already created and append changes if necessary