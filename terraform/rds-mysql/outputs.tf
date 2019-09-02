output "hostname" {
  value = "${aws_db_instance.default.endpoint}"
}