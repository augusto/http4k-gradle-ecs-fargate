# ecs.tf

resource "aws_ecs_cluster" "main" {
  name = "ecs-test-cluster"
}