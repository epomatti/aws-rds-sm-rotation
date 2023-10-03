output "kms_key_arn" {
  value = aws_kms_key.rds_master_password.arn
}
