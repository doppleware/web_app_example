resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier         = "${var.sandbox_id}-instance"
  cluster_identifier = "${aws_rds_cluster.cluster.id}"
  instance_class     = "db.t2.medium"
  db_subnet_group_name = "${aws_db_subnet_group.rds.id}"

}

resource "aws_rds_cluster" "cluster" {
  cluster_identifier     = "${var.sandbox_id}-cluster"
  database_name          = "${var.db_name}"
  master_username        = "${var.username}"
  master_password        = "${var.password}"
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  db_subnet_group_name = "${aws_db_subnet_group.rds.id}"
  skip_final_snapshot    = true
}