---
title: Global Environment Variables
weight: 1
seo:
  title: Global Environment Variables
  description: Configure global environment variables for the controller to inject into all workflows
  extra:

    # og
    - name: 'og:type'
      value: website
    - name: 'og:title'
      value: 'Feature: Global Environment Variables'
    - name: 'og:description'
      value: Configure global environment variables for the controller to inject into all workflows
    - name: 'og:image'
      value: 'https://s3.amazonaws.com/classic.isaaguilar.com/tfo-logo-cir.png'

    # twitter
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: 'Feature: Global Environment Variables'
    - name: 'twitter:description'
      value: Configure global environment variables for the controller to inject into all workflows
    - name: 'twitter:image'
      value: 'https://s3.amazonaws.com/classic.isaaguilar.com/tfo-logo-cir.png'
layout: docs
showJumpToSection: false
---

Unlike most of the features, **global environment variables** are configured at the controller level
rather than at the tf resource.

### Global Environment Variable Configuration

To configure global envs, update the controller's Deployment by adding any number of `env` vars with the
following prefixes:

- `TFO_VAR_`
- `TFO_SECRET_`

The un-prefixed versions will be added to every task in every tf resource.

#### Example using helm (preferred)

Here an example, how you could provide the same AWS credentials to all executed terraform tasks.

```yaml
controller:
  env:
  - name: TFO_SECRET_AWS_SECRET_ACCESS_KEY
    valueFrom:
      secretKeyRef:
        name: aws-creds-dev
        key: AWS_SECRET_ACCESS_KEY
  - name: TFO_SECRET_AWS_ACCESS_KEY_ID
    valueFrom:
      secretKeyRef:
        name: aws-creds-dev
        key: AWS_ACCESS_KEY_ID
```

The helm chart also supports `envFrom`, so that you can just pull all values from a secret (or configmap). Notice it does NOT auto apply the prefix.

```yaml
controller:
  envFrom:
  - secretRef:
      name: all-keys-from-this-secret
```

#### Example controller deployment using kubectl

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: "terraform-operator"
  # ... data omitted
spec:
  # ... data omitted
  template:
    # ... data omitted
    spec:
      containers:
      - name: "terraform-operator"
        # ... data omitted
        env:
        - name: TFO_SECRET_AWS_SECRET_ACCESS_KEY
          valueFrom:
            secretKeyRef:
              name: aws-creds-dev
              key: AWS_SECRET_ACCESS_KEY
        - name: TFO_SECRET_AWS_ACCESS_KEY_ID
          value: NotReallyASecret
        envFrom:
        - secretRef:
            name: all-keys-from-this-secret
```

# How it works

The environment variables prefixed with `TFO_VAR_` and `TFO_SECRET_` are stripped of the prefix and added
to a ConfigMap or Secret. Environment variables then get injected into all the tasks via `envFrom`.

From the example above, tasks would get the environment variables: `AWS_SECRET_ACCESS_KEY` and `AWS_ACCESS_KEY_ID`.
