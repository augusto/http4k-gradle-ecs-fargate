# alb.tf

resource "aws_alb" "main" {
  name            = "ecs-test-load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}
