---
title: Task Options
weight: 1
seo:
  title: Task Options
  description: Configure task options to customize the workflow tasks
  extra:

    # og
    - name: 'og:type'
      value: website
    - name: 'og:title'
      value: 'Feature: Terraform Operator Task Options'
    - name: 'og:description'
      value: Use Terraform Operator task options to customize the workflow tasks
    - name: 'og:image'
      value: 'https://s3.amazonaws.com/classic.isaaguilar.com/tfo-logo-cir.png'

    # twitter
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: 'Feature: Terraform Operator Task Options'
    - name: 'twitter:description'
      value: Use Terraform Operator task options to customize the workflow tasks
    - name: 'twitter:image'
      value: 'https://s3.amazonaws.com/classic.isaaguilar.com/tfo-logo-cir.png'
layout: docs
showJumpToSection: false
---

<div class="comment"><code>taskOptions</code> is an optional field in the <a href="/docs/references/v0.9.0/#TaskOption_v1alpha2_tf.isaaguilar.com">Terraform spec</a>.</div>


`taskOptions` is an array of options that enable customizing any or all task pods. Multiple option sets can be created to customize each individual task. Some options are simply added to the pod spec intuitively. Others are used by the pod indirectly, like the pod's ServiceAccount Role Policy. Finally there are options that change the task's execution script.

## Examples

**Example #1:**

```yaml
  taskOptions:
  - for: ["init", "plan", "apply", "init-delete", "plan-delete", "apply-delete"]
    script:
      source: https://example.com/path/to/terraform-executor.sh
```

The above `taskOptions` apply to the tasks called out in the `for:` array. So _for_ each of the tasks, the `source`, which is the [task's run script](#task-execution-options), is modified to use `https://example.com/path/to/terraform-executor.sh`.

**Example #2:**

```yaml
  taskOptions:
  - for: ["preinit"]
    annotations:
      foo: bar
    script:
      source: https://example.com/my/preinit.sh
  - for: ["plan"]
    env:
    - name: TF_LOG
      value: DEBUG
```

This configuration sets the preinit task to execute the script from `https://example.com/my/preinit.sh` and also adds an annotation to the preinit pod `foo=bar`. A second configuration adds the environment variable `TFO_LOG=DEBUG` to the plan pod.


## Task Option Configuration Reference

When defining task options the user selects which [tasks by name](/docs/architecture/tasks/#tasks-by-name-and-order-of-execution) to apply the options too. This is done in the `for` option.

#### Task selection option

<table class="apitable">
<tr><th>Option</th><th>Description</th></tr>
<tr><td><code class="field">for</code></td><td>A list of tasks that will accept the options.</td></tr>
</table>



#### "Pod-like" options

These options are directly related with the Kubernetes Pod definition:

<table class="apitable">
<tr><th>Option</th><th>Description</th></tr>
<tr><td><code class="field">annotations</code></td><td>Key/value annotations that get added to the task pods's metadata annotations.</td></tr>
<tr><td><code class="field">labels</code></td><td>Key/value lablels that get added to the task pod's metadata labels.</td></tr>
<tr><td><code class="field">env</code></td><td>Environment variables, defined like the pod's container <a href="https://pkg.go.dev/k8s.io/api/core/v1#EnvVar">EnvVar</a>, that are added to the task pod's main container.</td></tr>
<tr><td><code class="field">envFrom</code></td><td> Environment variables that get injected from a ConfigMap or Secret source. This is defined like a pod container's <a href="https://pkg.go.dev/k8s.io/api/core/v1#EnvFromSource">EnvFromSource</a>.</td></tr>
<tr><td><code class="field">resources</code></td><td>Resource requests and limits for the pod. See <a href="https://pkg.go.dev/k8s.io/api/core/v1#ResourceRequirements">Resource Requirements</a>.</td></tr>
</table>

#### RBAC Options

When the task needs more permissions, the following rbac options can be set to configure rbac:

<table class="apitable">
<tr><th>Option</th><th>Description</th></tr>
<tr><td><code class="field">policyRules</code></td><td>RBAC Role rules that will be added to all runner pods. (This option actually affects all tasks because they all currently share a ServiceAccount. Making a unique service account per task is a TODO item at the moment.)</td></tr>
</table>

#### Task Execution Options

The main purpose of a task is to execute a script. There are several ways to change the task's default execution. Only one of the three will be used. The order of precedence is:

- `inline`
- `configMapSelector`
- `script`

<table class="apitable">
<tr><th>Option</th><th>Description</th></tr>
<tr><td><code class="field">script.inline</code></td><td>Define the script directly in the yaml.</td></tr>
<tr><td><code class="field">script.configMapSelector.name</code><br>&<br/><code class="field">script.configMapSelector.key</code></td><td>Select an existing ConfigMap name and  data key that has the script as the value.</td></tr>
<tr><td><code class="field">script.source</code></td><td>An https endpoint that has the script to execute. Example: <a href="https://gist.githubusercontent.com/isaaguilar/cb1a13bf8dd2c63fd088b6e74331ef6b/raw/9a2ab49e402c5061e41d28ea7aa11914e23fe54b/hello-world.sh">hello-world.sh</a></td></tr>
</table>



## Other Tasks

Aside from the built in [tasks by name](/docs/architecture/tasks/#tasks-by-name-and-order-of-execution) that ship with Terraform Operator, users may also want to add their own [plugin-tasks](/docs/features/plugins/) into a workflow.

Plugins are actually (unmonitored) tasks and accept `taskOptions` like any other task.

For example, given a plugin like the following:

```yaml
  plugins:
    monitor:
        image: "ghcr.io/galleybytes/monitor:latest"
        imagePullPolicy: "IfNotPresent"
        when: "After"
        task: "setup"
```

the plugin is assigned the "monitor" task name. So the plugin pod can be defined further with `taskOptions`:

```yaml
  taskOptions:
  - for:
    - "monitor"
    env:
    - name: CLUSTER_NAME
      value: "kind-kind"
    - name: DBHOST
      value: "database"
    - name: PGPASSWORD
      value: "pass"
    - name: PGUSER
      value: "pg"
    - name: PGDATABASE
      value: "crud"
    - name: PGPORT
      value: "5432"
    - name: ENV
      value: "devlocal"
```

