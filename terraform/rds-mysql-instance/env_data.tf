data "aws_vpc" "default" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "apps_subnets" {
  vpc_id = "${var.vpc_id}"
  tags = {
    Name = "app-subnet*"
  }
}