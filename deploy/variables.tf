# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
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

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}