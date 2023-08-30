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
  workload       = "rdsmgpass"
  aws_account_id = data.aws_caller_identity.current.account_id


  az1 = "${var.aws_region}a"
  az2 = "${var.aws_region}b"
}

### KMS ###

resource "random_string" "suffix" {
  length  = 3
  special = false
  upper   = false
}

resource "aws_kms_key" "rds_master_password" {
  description             = "epomatti/rds/managed-master-password-key/${random_string.suffix.result}"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

### RDS MySQL ###

resource "aws_db_instance" "default" {
  identifier     = "database-1"
  db_name        = "testdb"
  engine         = "mysql"
  engine_version = "8.0.34"
  username       = "dbadmin"

  manage_master_user_password   = true
  master_user_secret_kms_key_id = aws_kms_key.rds_master_password.arn

  ca_cert_identifier = "rds-ca-rsa2048-g1"

  publicly_accessible = true
  instance_class      = "db.t4g.micro"
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

  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]
}

resource "aws_db_subnet_group" "default" {
  name       = "rds-group-${local.workload}"
  subnet_ids = [aws_subnet.public1.id, aws_subnet.public2.id]
}

### Network ###
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${local.workload}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ig-${local.workload}"
  }
}

### Routes ###

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "rt-${local.workload}-public"
  }
}

### Subnets ###

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = local.az1
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${local.workload}-pub1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = local.az2
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${local.workload}-pub2"
  }
}

### Routes ###

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

### Security Groups ###
resource "aws_security_group" "allow_mysql" {
  name   = "rds-${local.workload}"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sg-rds-${local.workload}"
  }
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_mysql.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_mysql.id
}
