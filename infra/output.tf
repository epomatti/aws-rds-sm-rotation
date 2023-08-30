output "secretsmanager_rds_secret_id" {
  value = aws_db_instance.default.master_user_secret
}
