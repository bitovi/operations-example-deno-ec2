# operations-example-deno-AWS

Deploy a [Deno][1] app to AWS

## What is this?

This Operations Repo is a neat way to deploy your [Deno][1] app to AWS. It provides two different ways as examples:

1. Spin up an AWS EC2 VM and use `docker-compose` to launch a container serving the app,
2. Configure an AWS Elastic Container Service (ECS) task to host a container serving the app.

## What does it do?

There are two Actions used in this Ops Repo:

1. [Deploy Docker to EC2][2]
2. [Deploy Docker to ECS][3]

They are two different ways to accomplish the same thing: Hosting your Deno app in the cloud, for public access.

We provide this Operations Repo as an example of how to use either Action for your Deno app.

## How does it work?

You might notice there isn't any application code in this repo. That's intentional! **Deno** apps are capable of being served by simply providing the URL of their "main" code to the Deno runner.

So that's what we've done in this Operations Repo. The `Dockerfile` and `docker-compose.yml` are fed into Bitovi's open-source GitHub Actions, which take care of the provisining and deployment into AWS resources.

All you need is an AWS account, and your [Deno][1] code.

### The `Dockerfile`

The Dockerfile is quite simple:

- It starts `FROM` the latest Deno runner image.
- `EXPOSE` the port specified by the app code, in this case `8000`.
- A default `ENV` var is set as the URL of the app's main code file. This is used by the Deno runner to start the app.
- The env var can be overridden with any other app's URL at build- and run-time, without changing the Dockerfile  

### The `docker-compose` file

The `docker-compose.yml` file is used by the [Deploy Docker to EC2][2] Action to spin up a VM and launch the app.

## Overriding the `DENO_URL` environment variable

We've provided three variations of how override the `DENO_URL` environment variable:

1. Setting the `DENO_URL` environment variable in the `docker-compose.yml` file.
1. Using the `-e "DENO_URL=<your deno url>"` flag when running `docker-compose up`, or when running `docker-compose build`.
1. Providing a `.env` file with the `DENO_URL` environment variable.

[1]: https://deno.com/
[2]: https://github.com/bitovi/github-actions-deploy-docker-to-ec2
[3]: https://github.com/bitovi/github-actions-deploy-ecs