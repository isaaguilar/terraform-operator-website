---
title: Tasks
weight: 2
seo:
  title: Tasks
  description: This is the tasks page
  extra:
    - name: 'og:type'
      value: website
      keyName: property
    - name: 'og:title'
      value: Tasks
      keyName: property
    - name: 'og:description'
      value: This is the tasks page
      keyName: property
    - name: 'twitter:card'
      value: summary
    - name: 'twitter:title'
      value: Tasks
    - name: 'twitter:description'
      value: This is the tasks page
layout: docs
---



Tasks perform a set of tasks and multiple tasks make up a workflow. There are three main groupings of tasks:

- Terraform
- Setup
- Scripts

### Terraform

Terraform is the task that calls on `terraform` to perform the init | plan | apply workflow. Those familiar
with Terraform are familiar with this workflow because it's at the heart of how terraform is executed.

The terraform tasks are split up into three pods as well. Each task performs one of the three actions. In order theses are:

- init
- plan
- apply

Upon a successful exit code sent from the task's executing script, the controller will trigger the next task.

### Setup

No terraform is without setup. The setup task is responsible for downloading the terraform module and any other
files required to perform a successful terraform run.

### Scripts

These are special tasks that are executed between Terraform tasks. Terraform users understand that not every
terraform workflow is a standalone execution; it would be nice if it was.

Scripts allow users to write their own logic, do file manipulation, ensure vars, run tests, or a plethora of
other things as a stage in the terraform operator workflow.


## Modifying and Extending Tasks

To make modification to the executing script of any of the tasks, try and get familiar with the tasks repo
[https://github.com/GalleyBytes/terraform-operator-tasks](https://github.com/GalleyBytes/terraform-operator-tasks).
This separation of the tasks from the main repo is brand new. More documentation is soon to follow.

Check back soon for a better guide on modifying tasks.

