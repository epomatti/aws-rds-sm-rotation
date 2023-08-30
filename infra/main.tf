terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_kms_key" "main" {
  description             = "kms-rdspass-managed-key"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          "AWS" : "arn:aws:iam::${var.aws_account_id}:root"
        }
        Action   = "kms:*",
        Resource = "*"
      }
    ]
  })
}

resource "aws_db_instance" "default" {
  identifier     = "database-1"
  db_name        = "testdb"
  engine         = "postgres"
  engine_version = "15.3"
  username       = "dbadmin"
  password       = "DF1238DCVc#R53"

  manage_master_user_password   = true
  master_user_secret_kms_key_id = aws_kms_key.main.arn

  publicly_accessible = true
  instance_class      = "db.t4g.medium"
  allocated_storage   = "30"
  storage_type        = "gp3"
  storage_encrypted   = true
  multi_az            = false

  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false
  apply_immediately           = false

  deletion_protection      = false
  skip_final_snapshot      = true
  delete_automated_backups = true
}
