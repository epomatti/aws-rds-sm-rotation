resource "aws_db_instance" "default" {
  identifier     = "database-1"
  db_name        = "testdb"
  engine         = "mysql"
  engine_version = "8.0"
  username       = "dbadmin"

  // Password Management
  manage_master_user_password   = true
  master_user_secret_kms_key_id = var.master_user_secret_kms_key_id

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

  blue_green_update {
    enabled = false
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "rds-group-${var.workload}"
  subnet_ids = var.public_subnets_ids
}

### Security Groups ###
resource "aws_security_group" "allow_mysql" {
  name   = "rds-${var.workload}"
  vpc_id = var.vpc_id

  tags = {
    Name = "sg-rds-${var.workload}"
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
