resource "aws_security_group" "lb" {
  name        = "ecs-test-lb-security-group"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "lb-ingress-app1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "lb-ingress-app2" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

# I think think this should target the internal VPC only
# as the LB won't initiate a connection to the wide internet.
resource "aws_security_group_rule" "lb-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}
