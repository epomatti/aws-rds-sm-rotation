resource "random_string" "suffix" {
  length  = 3
  special = false
  upper   = false
}

resource "aws_kms_key" "rds_master_password" {
  description             = "epomatti/rds/managed-master-password-key/${random_string.suffix.result}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}
