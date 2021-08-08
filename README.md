First stab in the dark to deploy a couple of containers using ECS.

# The app
The app is a tiny http4k app with 2 endpoints
- http://localhost:9000/hello?name=World
- http://localhost:9000/health

Some operations:
* The app can be run with `gradle run`
* Build the container with `gradle jibDockerBuild` and execute locally with `docker run -it --rm -p9000:9000 hello-world`
* Deploy the container to ECR with `gradle jib`

The environment and app are provisioned with terraform
* `infra`: Has the basic infrastructure (ECR, VPC, subnets, ALB)
* `deploy`: Has the bits required to deploy and manage the container: ECS tasks, ALB routing & some security groups.

The separation of the 2 is not great, as several variables are required on both, and some resources might make
sense to live in the other module (e.g. `deploy/security.yml` could be in `infra`)

# How do I run this?
AWS will charge you for running this! I think the only resource outside the free tier is the ALB.

1. Have the aws cli configured and terraform installed. 
1. Run `gradle provisionInfra`. This will run `terraform apply` on the infra folder. You might want to update the 
   region on `build.gradle`. Terraform will output the LB URL, which is required later to poke the app.
1. run `gradle deployContainer`. This will trigger the `jib` plugin and build the code, build the container and upload it to ECR.
1. Poke the app using the LB url (might need a minute for the ECS task to come online). The LB forwards port 80
to one target group and port 8080 to the second target group. Both containers run the same image.
1. Destroy all AWS resources with `gradle destroyInfra`.

# Issues!!
Because we love problems!

- Some values and variables have to be kept in sync manually, but this could be easily solved by setting them
via [environment variables](https://www.terraform.io/docs/cli/config/environment-variables.html#tf_var_name) (or another solution?) 
- Some logging platforms require an extra container to forward logs from cloudwatch to the SaaS solution.
- Security roles are a bit too lax.
- Containers should be deployed on the private subnets.
- Because of the separation of the infra and deploy modules, infra cannot be destroyed (or potentially updated) without
  tearing down first the containers.

Notes:
- This was tested with Gradle 6.8.3, Java 11.0.8 and Terraform 0.13.7.
- At the moment, the image in ECR cannot be changed, as it's an immutable repo (good thing!). To solve this, we
  use the git commit hash as the image tag. So to release a new version, a commit must be made. This works well
  for CI/CD envs, but not to deploy _test_ versions.
- The containers should be changed to [distroless containers](https://github.com/GoogleContainerTools/distroless/) for security.
- Looks like Terraform manages rolling deploys to ECS, but needs more testing.
- Using Terraform to do deploys containers doesn't feel right, but it does the job.
- Might be good to add an autoscaling group as an example, even though ECS will recover if the container aborts.
- Add a security manager for extra security.
- Update example to also use path based routing.
- Override the image tag (git hash) in order to do local tests without commits (maybe using a UUID)