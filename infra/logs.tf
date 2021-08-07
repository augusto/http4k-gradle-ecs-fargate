# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "ecs_test_log_group" {
  name              = "/ecs-test/myapp"
  retention_in_days = 30

  tags = {
    Name = "ecs-test-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "myapp_log_stream" {
  name           = "ecs-test-log-stream"
  log_group_name = aws_cloudwatch_log_group.ecs_test_log_group.name
}