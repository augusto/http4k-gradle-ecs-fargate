data "aws_alb" "main" {
  name = "ecs-test-load-balancer"
}

# Generate a random string to add it to the name of the Target Group. This is a 'workaround' to be able
# to replace target groups: https://github.com/hashicorp/terraform-provider-aws/issues/1315
resource "random_string" "alb_prefix" {
  length  = 4
  upper   = false
  special = false
}

# Port 80 -> app2
resource "aws_alb_target_group" "app1" {
  name        = "ecs-test-app1-target-group-${random_string.alb_prefix.result}"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "app1" {
  load_balancer_arn = data.aws_alb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app1.id
    type             = "forward"
  }
}

# Port 8080 -> app2
resource "aws_alb_target_group" "app2" {
  name        = "ecs-test-app2-target-group-${random_string.alb_prefix.result}"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Port 8080 on the LB
resource "aws_alb_listener" "app2" {
  load_balancer_arn = data.aws_alb.main.id
  port              = 8080
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app2.id
    type             = "forward"
  }
}
