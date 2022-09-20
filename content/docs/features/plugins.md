---
title: Plugins
weight: 1
seo:
  title: Plugins
  description: Configure plugins to give your workflows additional functionality
  extra:

    # og
    - name: 'og:type'
      value: website
    - name: 'og:title'
      value: 'Feature: Terraform Operator Plugins'
    - name: 'og:description'
      value: Use Terraform Operator plugins to give your workflows additional functionality
    - name: 'og:image'
      value: 'https://s3.amazonaws.com/classic.isaaguilar.com/tfo-logo-cir.png'

    # twitter
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: 'Feature: Terraform Operator Plugins'
    - name: 'twitter:description'
      value: Use Terraform Operator plugins to give your workflows additional functionality
    - name: 'twitter:image'
      value: 'https://s3.amazonaws.com/classic.isaaguilar.com/tfo-logo-cir.png'
layout: docs
showJumpToSection: false
---

<div class="comment"><code>plugins</code> is an optional field in the <a href="http://localhost:1313/docs/references/v0.9.0/#TerraformSpec_v1alpha2_tf.isaaguilar.com">Terraform spec</a>.</div>

Plugins are tasks that run during a workflow but are not part of the main workflow. Plugins can be treated as just another task, however, plugins do not have completion or failure detection.

<img src="/images/plugins.png" alt="Terraform Operator Workflow Diagram"></img>

Example definition of a plugin:

```yaml
  plugins:
    monitor:
        image: ghcr.io/galleybytes/monitor:latest
        imagePullPolicy: IfNotPresent
        when: After
        task: setup
```

The above plugin task will run after the setup task has completed.

Alternatively, a plugin can be triggered to start at the same time of another task. For example:

```yaml
  plugins:
    monitor:
        image: ghcr.io/galleybytes/monitor:latest
        imagePullPolicy: IfNotPresent
        when: At
        task: setup
```

Each plugin is run once per generation. Plugins that are older than the current generation are automatically reaped.