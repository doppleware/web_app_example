output "hostname" {
  description = "The cluster endpoint"
  value       =   "${aws_rds_cluster.cluster.endpoint}"
}