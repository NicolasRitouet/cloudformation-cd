# Infrastructure as code - Continuous Delivery of Cloudformation stacks

> Continuous Delivery of Cloudformation stacks using CodePipeline and Change-sets

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