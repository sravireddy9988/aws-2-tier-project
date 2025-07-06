output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.rds_instance.endpoint
}

output "rds_instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.rds_instance.id
}
