output "secretsmanager_rds_secret_id" {
  value = aws_db_instance.default.master_user_secret
}

output "db_name" {
  value = aws_db_instance.default.db_name
}

output "mysql_address" {
  value = aws_db_instance.default.address
}
