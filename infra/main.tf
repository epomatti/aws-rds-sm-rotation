terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# data "aws_caller_identity" "current" {}

locals {
  workload = "rdsrotation"
  # aws_account_id = data.aws_caller_identity.current.account_id
}

module "vpc" {
  source   = "./modules/vpc"
  workload = local.workload
}

module "kms_master_password" {
  source = "./modules/kms"
}

module "rds" {
  source   = "./modules/rds"
  workload = local.workload

  vpc_id                        = module.vpc.vpc_id
  public_subnets_ids            = module.vpc.public_subnets_ids
  master_user_secret_kms_key_id = module.kms_master_password.kms_key_arn
}
