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

We provide this Operations Repo as an example of how to use either Action for your Deno app. In a real-world scenario, you'd pick one.

## How does it work?

You might notice there isn't any application code in this repo. That's intentional! **Deno** apps are capable of being served by simply providing the URL of their "main" code to the Deno runner.

So that's what we've done in this Operations Repo. The `Dockerfile` and `docker-compose.yml` are fed into Bitovi's open-source GitHub Actions, which take care of the provisioning and deployment into AWS resources.

Alternatively, you can use these Actions in the same repo as your application code, which will result in your app deploying on any push to the branches you've configured!

All you need is an AWS account and your [Deno][1] code.

### The `Dockerfile`

The Dockerfile is quite simple:

- It starts `FROM` the latest Deno runner image.
- `EXPOSE` the port specified by the app code, in this case `8000`.
- A default `ENV` var is set as the URL of the app's main code file. The Deno runner uses this to start the app.
- The env var can be overridden with any other app's URL at build- or run-time, without changing the Dockerfile. In this way, this ops repo can be used to deploy _any_ Deno app!

### The `docker-compose` file

The `docker-compose.yml` file is used by the [Deploy Docker to EC2][2] Action to spin up a VM and launch the app. It isn't needed for the ECS action: that Action is driven purely from [the Workflow's inputs][4].

## Overriding the `DENO_URL` environment variable

We've provided three variations of how to override the `DENO_URL` environment variable:

1. Set the `DENO_URL` environment variable in the `docker-compose.yml` file.
1. Provide a `.env` file with the `DENO_URL` environment variable.

For local development: Use the `-e "DENO_URL=<your deno url>"` flag when running your Docker/docker-compose commands.


[1]: https://deno.com/
[2]: https://github.com/bitovi/github-actions-deploy-docker-to-ec2
[3]: https://github.com/bitovi/github-actions-deploy-ecs
[4]: .github/workflows/deploy.yaml#L45
