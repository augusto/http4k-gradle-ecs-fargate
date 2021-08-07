data "aws_vpc" "main" {
  tags = {
    Name = "ecs-test-vpc"
  }
  state = "available"
}

data "aws_availability_zones" "available" {
}

data "aws_subnet" "public" {
  count             = var.az_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "ecs-test-public-subnet-${count.index}"
  }
}