output "secretsmanager_rds_secret_id" {
  value = module.rds.secretsmanager_rds_secret_id
}

output "rds_mysql_db_name" {
  value = module.rds.mysql_address
}

output "rds_mysql_address" {
  value = module.rds.mysql_address
}
