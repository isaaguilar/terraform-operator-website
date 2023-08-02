---
title: Complete Terraform Operator example
weight: 4
seo:
  title: Complete example
  description: A full example using the Terraform Operator
  extra:
    - name: 'og:type'
      value: website
      keyName: property
    - name: 'og:title'
      value: Complete Terraform Operator example
      keyName: property
    - name: 'og:description'
      value: A full example using the Terraform Operator
      keyName: property
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: Complete Terraform Operator example
    - name: 'twitter:description'
      value: A full example using the Terraform Operator
layout: docs
---

## Complete Terraform Operator example

There is a lot of moving parts in the Terraform resource, so here is a complete example to illustrate many of the features.

### Goal

The goal for this example is to provision a `Simple Queue Service` aka `SQS` from AWS.

<div class="note">
It could be anything that terraform support, but this lets us show many features and requirements.
</div>

### The helm

For this example, we will wrap everything in a helm. We will keep it very simple with just 4 files.

#### File 1: Chart.yaml

This has absolutely nothing fancy in it, just a name and description and some helm tags.

```yaml
apiVersion: v2
name: example
description: Example chart for terraform operator
type: application
version: 1.0.0
```

#### File 2: values.yaml

This has absolutely nothing fancy in it, just a name for the queue we want to create.

```yaml
queue:
  name: "my-queue"
```

#### File 3: main.tf

Follow the [The Terraform script](#TerraformScript) to make this file.

The specific name of this file doesn't matter, you just need to change it in the terraform operator also.

#### File 4: templates/aws-sqs.yaml

Follow the [The Terraform resource](#TerraformResource) to make this file.

The specific name of this file doesn't matter, as long as it is in the `templates` folder.

### <a name="TerraformScript"></a> The Terraform script

For this purpose we will use a simple tf script. For this we will 

#### Step 1: Define the providers

For this, we need the AWS provider only. We make it simple, and just use defaults since we will use environment variables to inject the authentication for AWS.

```terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}
provider "aws" {
}
```

#### Step 2: Provision resources

Like we said above, for this example we just provision a very simple `SQS`.

To show how to parameterize the script, we will define a variable `QUEUE_NAME` and later pull the value from helms `queue.name` for it (ie, the default we made in `values.yaml`).

```terraform
variable "QUEUE_NAME" {
  description = "Your queues name"
}
resource "aws_sqs_queue" "sqs" {
  name = var.QUEUE_NAME
}
```

#### Step 3: Get the output

And presumable, we would actually need this queue somewhere, so let's output the url to connect on.

```terraform
output "SqsQueueUrl" {
  value = aws_sqs_queue.sqs.id
  sensitive = true
}
```

#### Putting it all together

The final `main.tf` files therefore looks like this:

```terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}
provider "aws" {
}
variable "QUEUE_NAME" {
  description = "Your queues name"
}
resource "aws_sqs_queue" "sqs" {
  name = var.QUEUE_NAME
}
output "SqsQueueUrl" {
  value = aws_sqs_queue.sqs.id
  sensitive = true
}
```


### <a name="TerraformResource"></a>The Terraform resource

So far, we have just touched terraform code. Now it is time to get it running in our kubernetes cluster using the Terraform Operator.

#### Step 1: The basics

We will build up the yaml in stages, so it is easier to show and tell. We start of with the very basics.

```yaml
apiVersion: tf.galleybytes.com/v1beta1
kind: Terraform
metadata:
  name: provision-aws-sqs
spec:
```

#### Step 2: The terraform Version

At this point in time, it is necessary to specify which Terraform version to use based on images available for the Terraform Operator. Go to [Terraform Operators Github packages](https://github.com/orgs/GalleyBytes/packages?tab=packages&q=+terraform-operator-tftaskv) and find the version matching your operator. Then click that link and find the tag matching the terraform version you want to run. Here, we will pick 1.4.6.

```yaml
  terraformVersion: "1.4.6"
```

#### Step 3: (optional) Specify working storage

Per default, Terraform operator will allocate 2Gi of storage to processes the script. But this is a tiny tf script, so let's reduce that a bit.

```yaml
  persistentVolumeSize: 500Mi
```

#### Step 4: (optional) Specify history

Per default, Terraform operator will keep history of all previous executions. But honestly, there is no point in that, so lets just keep latest, and inform the operator to clean up also.

```yaml
  keepLatestPodsOnly: true
  setup:
    cleanupDisk: true
```

#### Step 5: (optional) Deletion policy

We want our tf script to run the destroy when the terraform kubernetes resource is deleted.

```yaml
  ignoreDelete: false
```

#### Step 6: The tfstate location

Terraform keeps a state of how the world looks, and it needs to keep that somewhere. Obviously the most useful place to put it is right next to our terraform operator resource.

Here is our first bit of Helm syntax to specify the namespace, since we will actually be deploying this yaml using helm.

`secret_suffix` can be anything, as long as it is un-changed after creation.

```yaml
  backend: |-
    terraform {
      backend "kubernetes" {
        secret_suffix    = "aws-sqs"
        namespace = "{{ .Release.Namespace }}"
        in_cluster_config  = true
      }
    }
```

#### Step 7: Output to secret

Since we specified an output in the tf script, we also want to tell Terraform Operator where this output actually needs to be stored.

```yaml
  outputsSecret: "aws-sqs"
```

This is the secret you actually want to consume in your deployment, example:

```yaml
#example deployment for consuming secret
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      containers:
        envFrom:
        - secretRef:
            name: aws-sqs
```

#### Step 8: Feed tf script to operator

Here we tell Helm how to package the `main.tf` file. Notice path is based off the helms base path.

```yaml
  terraformModule:
    inline: |-
      {{ (.Files.Get "main.tf") | nindent 6 }}
```

#### Step 9: AWS credentials

Here we have 2 choices. Either follow the example in [Global Variables](/docs/features/globalenvs/) so that credentials is available to all tf scripts.

Or we can define it in the yaml for this task alone:

```yaml
  taskOptions:
  - for: ["plan", "apply", "plan-delete", "apply-delete"]
    env:
    - name: AWS_SECRET_ACCESS_KEY
      valueFrom:
        secretKeyRef:
          name: mycreds
          key: AWS_SECRET_ACCESS_KEY
    - name: AWS_REGION
      value: eu-north-1
    - name: AWS_ACCESS_KEY_ID
      valueFrom:
        secretKeyRef:
          name: mycreds
          key: AWS_ACCESS_KEY_ID
```

Now, what does this mean? It means for the `plan`, `apply`, `plan-delete`, `apply-delete` we want these 3 variables to be defined.

Notice that it is **VERY** important that you also specify the `delete` variants, or if you ever delete your resource the deletion will hang forever since the tf script will fail.

<div class="note">
Terraform uses `destroy` as the name of the process for tearing down resources.
Terraform Operator uses `delete`, but it means the same thing.
</div>


#### Step 10: Script parameters

Next step is to send our helm values into the tf script. We do that by using `TF_VAR_` prefix, so that Terraform will see them.

```yaml
  taskOptions:
  - for: ["plan", "apply"]
    env:
    - name: TF_VAR_QUEUE_NAME
      value: {{ .Values.queue.name | required "You forgot to give a value to queue.name" | quote }}
  - for: ["plan-delete", "apply-delete"]
    env:
    - name: TF_VAR_QUEUE_NAME
      value: ""
```

<div class="note">
Here, we give a different value for the `delete` variants. For this example it is totally unnecessary, but if e.g. you are pulling the value from a configmap or secret and those are deleted along with the terraform resource, the terraform resource would have no nowhere to obtain this value from during the delete phase.
</div>

#### Putting it all together

The final `templates/aws-sqs.yaml` files therefore looks like this:

```yaml
apiVersion: tf.galleybytes.com/v1beta1
kind: Terraform
metadata:
  name: provision-aws-sqs
spec:
  terraformVersion: "1.4.6"
  persistentVolumeSize: 500Mi
  keepLatestPodsOnly: true
  setup:
    cleanupDisk: true
  ignoreDelete: false
  backend: |-
    terraform {
      backend "kubernetes" {
        secret_suffix    = "aws-sqs"
        namespace = "{{ .Release.Namespace }}"
        in_cluster_config  = true
      }
    }
  outputsSecret: "aws-sqs"
  terraformModule:
    inline: |-
      {{ (.Files.Get "main.tf") | nindent 6 }}
  taskOptions:
  - for: ["plan", "apply", "plan-delete", "apply-delete"]
    env:
    - name: AWS_SECRET_ACCESS_KEY
      valueFrom:
        secretKeyRef:
          name: mycreds
          key: AWS_SECRET_ACCESS_KEY
    - name: AWS_REGION
      value: eu-north-1
    - name: AWS_ACCESS_KEY_ID
      valueFrom:
        secretKeyRef:
          name: mycreds
          key: AWS_ACCESS_KEY_ID
  - for: ["plan", "apply"]
    env:
    - name: TF_VAR_QUEUE_NAME
      value: {{ .Values.queue.name | required "You forgot to give a value to queue.name" | quote }}
  - for: ["plan-delete", "apply-delete"]
    env:
    - name: TF_VAR_QUEUE_NAME
      value: ""
```

### Deploy

Finally, use helm to deploy your chart.

```bash
helm install -n demo-namespace demo-terraform-operator path-to-chart
```

Wait until it is done, and check the secret (notice it is created immediately, but values are only applied after tf script finish)

```bash
kubectl -n demo-namespace get secrets aws-sqs -o yaml
```

and test destroy works:

```bash
helm uninstall -n demo-namespace demo-terraform-operator
```
