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

We provide this Operations Repo as an example of how to use either Action for your app.



## How does it work?

You might notice there isn't any application code in this repo. That's intentional! **Deno** apps are capable of being hosted by simply providing the URL of their "main" code to the Deno runner.

So that's what we've done in this Operations Repo. The `Dockerfile` and `docker-compose.yml` are fed into Bitovi's open-source GitHub Actions, which take care of the provisining and deployment into AWS resources.

All you need is an AWS account, and your [Deno][1] code.

### The Dockerfile

The Dockerfile is quite simple. It starts `FROM` the latest Deno runner image.






[1]: https://deno.com/
[2]: https://github.com/bitovi/github-actions-deploy-docker-to-ec2
[3]: https://github.com/bitovi/github-actions-deploy-ecs