# operations-example-deno-AWS

This Operations Repo is a low-friction way to deploy your [Deno][1] app to AWS. It provides two different ways as examples:

1. Spin up an AWS EC2 VM and use `docker-compose` to launch a container serving the app,
2. Configure an AWS Elastic Container Service (ECS) task to host a container serving the app.

## What does it do?

There are two independent Actions used in this Ops Repo, providing two different ways to accomplish the same thing: Hosting your Deno app in the cloud, for public access.

| Action | Link |
|:------:|:----:|
| [Deploy Docker to EC2][2]  | <img src="https://github.com/bitovi/operations-example-deno-ec2/assets/8335079/1aaa61a6-e8fc-42b5-b1c8-4466840e6126" height="25%" width="25%" /> |
| [Deploy Docker to ECS][3]  | <img src="https://github.com/bitovi/operations-example-deno-ec2/assets/8335079/bab32753-c6d8-49ba-a5a3-e461ca1162a9" height="25%" width="25%"> |

We provide this Operations Repo as an example of how to use either Action for your Deno app. In a real-world scenario, you'd probably only pick one.

## How does it work?

You might notice there isn't any application code in this repo. That's intentional! **Deno** apps are capable of being served by simply providing the URL of their "main" code to the Deno runner.

So that's what we've done in this Operations Repo. The `Dockerfile` and `docker-compose.yml` are fed into Bitovi's open-source GitHub Actions, which take care of the provisioning and deployment into AWS resources.

Alternatively, you can use these Actions in the same repo as your application code, which will result in your app deploying on any push to the branches you've configured!

All you need is [an AWS account][6] and your [Deno][1] code.

### The `Dockerfile`

The Dockerfile is quite simple:

- It starts `FROM` the latest Deno runner image.
- `EXPOSE` the port specified by your app code, in this case `8000`.
- A default `ENV` var is set as the URL of the app's main code file. The Deno runner uses this to start the app.
- The env var can be overridden with any other app's URL at build- or run-time, without changing the Dockerfile. In this way, this ops repo can be used to deploy _any_ Deno app!

### The `docker-compose` file

The `docker-compose.yml` file is used by the [Deploy Docker to EC2][2] Action to spin up a VM and launch the app. It isn't needed for the ECS action: that Action is driven purely from [the Workflow's inputs][4].

In fact, you could drive your ECS deployment from a repo with no app code, and only the Workflow!

## Overriding the `DENO_URL` environment variable

We've provided three variations of how to override the `DENO_URL` environment variable:

1. Set the `DENO_URL` environment variable in the `docker-compose.yml` file.
1. Provide a `repo_env` file with the `DENO_URL` environment variable.

For local development: Use the `-e "DENO_URL=<your deno url>"` flag when running your Docker/docker-compose commands.

## Deploying and Destroying your Cloud Infrastructure

There is one variable to consider when deploying and destroying your AWS deployment: `stack_destroy` in the EC2 workflow, and `tf_stack_destroy` in the ECS workflow.

> These variables will be named consistently in upcoming releases!

In either case, this is the one variable that triggers deploying and destroying the environment.

If `[tf_]stack_destroy` is `false`, the environment will be provisioned and your app will be deployed.

If it is `true`, the environment and application will be **destroyed**.

This mechanism enables a **GitOps** workflow: the state of the environment is determined by the content of the code, and changes to the code trigger changes in the environment.

## Other Best Practices and Tips

There are a handful of additional practices and patterns that are worth mentioning in this example Ops Repo. 

These are examples of patterns to keep in mind when developing your own workflows, and there are any number of options and additional features you can apply. Make sure to get familiar with [the GitHub Actions Syntax docs][7].

### Control the Action Triggers with Event Filters

Both workflows will only trigger on pushes to `main`.

> You can, of course, configure this to your liking; you can create branch-based environments, for example. GitHub provides several automatic variables that can be used to name things uniquely. [See here for more info.][8]

The workflows in this repo also use the `paths-ignore` filter to ignore changes to certain files. 

Specifically, the Actions will _not_ run if: 

- _only_ this `README.md` is changed, or
- _only_ the workflow's counterpart is changed (eg, `EC2` change will not trigger `ECS` workflow)

The filter code:

```yaml
on:
  push:
    branches: [ main ]

    # DON'T run if only either of these files are changed.
    # If any other files are also changed, the workflow *will* run.
    paths-ignore:
      - README.md
      - .github/workflows/deploy_EC2.yaml
```

The [Actions syntax docs][5] describe it well:

> When **all** the path names match patterns in `paths-ignore`, the workflow **will not** run. If **any** path names do not match patterns in `paths-ignore`, *even if some path names match the patterns*, the workflow **will** run.

### Prevent Multiple Concurrent Workflow Runs

This repo's workflows are configured to prevent multiple runs of the same workflow at the same time, using `concurrency groups`.

Typically we would want any _new_ workflow runs to supercede any _in-progress_ runs. That is, if a workflow is running, and a new change comes in and triggers a new run, the first run should be cancelled, and the second run will continue. The Actions parameter for this behavior is `cancel-in-progress`.

We want to only consider runs of the _the same workflow_ when cancelling anything. So we use a `concurrency group` to identify the workflows to consider for cancellation.

In our case, we have two workflows that we want to be independent of each other, so we group them separately. This mechanism can also be used to separate environments, branches, tags, or anything else.

The code:

```yaml
# deploy_EC2.yaml
jobs:
  EC2-Deploy:
    ...
    # ensures last-in-first-out ordering
    concurrency:
      group: ec2
      cancel-in-progress: true


# deploy_ECS.yaml
jobs:
  ECS-Deploy:
    ...
    # ensures last-in-first-out ordering
    concurrency:
      group: ecs
      cancel-in-progress: true
```



[1]: https://deno.com/
[2]: https://github.com/bitovi/github-actions-deploy-docker-to-ec2
[3]: https://github.com/bitovi/github-actions-deploy-ecs
[4]: .github/workflows/deploy.yaml#L45
[5]: https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#onpushpull_requestpull_request_targetpathspaths-ignore
[6]: https://aws.amazon.com/free
[7]: https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions
[8]: https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables