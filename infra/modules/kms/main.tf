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

resource "aws_kms_alias" "master" {
  name          = "alias/rds-master-rotation"
  target_key_id = aws_kms_key.rds_master_password.key_id
}
