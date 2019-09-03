module "db" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 2.0"

  name                            = "aurora_${var.sandbox_id}"

  engine                          = "aurora-postgresql"
  engine_version                  = "9.6.9"

  vpc_id                          = "${var.vpc_id}"
  subnets                         = ["${data.aws_subnet_ids.apps_subnets.ids}"]

  replica_count                   = 1
  allowed_security_groups         = ["${aws_security_group.rds.id}"]
  allowed_security_groups_count   = 1
  instance_type                   = "db.r4.large"
  storage_encrypted               = true
  apply_immediately               = true
  monitoring_interval             = 10

  db_parameter_group_name         = "default"
  db_cluster_parameter_group_name = "default"

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags                            = {
    Environment = "dev"
    Terraform   = "true"
  }
}