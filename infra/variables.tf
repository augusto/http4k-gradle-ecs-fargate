# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "eu-west-2"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "3"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "testEcsTaskExecutionRole"
}
variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 9000
}
variable "health_check_path" {
  default = "/health"
}