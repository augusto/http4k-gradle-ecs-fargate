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
1. First run terraform on the infra folder (`terraform apply`). You might want to update the region in the variables.
Copy the output ECR url and put in build.gradle. Also note the output LB URL.
2. Upload the container to ECR (`gradle jib`)
3. Update variables in the deploy folder (image URL). Deploy by running terraform in the deploy folder (`terraform apply`).
4. Poke the app using the LB url (might need a minute for the ECS task to come online). The LB forwards port 80
to one container and port 8080 to the second container. Both containers run the same image.

# Issues!!
Because we love problems!

- At the moment, the image in ECR cannot be changed, as it's an immutable repo (good thing!), we would need to 
run gradle in such a way that it creates images with different tags (maybe a timestamp?) and then TF would need 
to pick this automatically or that would need to be passed as a variable.
- Some values and variables have to be kept in sync manually, but this could be easily solved by setting them
via [environment variables](https://www.terraform.io/docs/cli/config/environment-variables.html#tf_var_name  ) (or another solution?) 
- Supposedly terraform manages rolling deploys to ECS using the lifecycle `create_before_destroy=true` on the 
task definitions, but haven't tried this.
- The containers should be changed to [distroless containers](https://github.com/GoogleContainerTools/distroless/) for security.  
- Terraform _feels like_ it's not the right tool to deploy containers, but it does the job.
- Some logging platforms require an extra container to forward logs from cloudwatch to the SaaS solution.
- Security roles are a bit too lax.