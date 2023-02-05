resource "aws_db_instance" "app_rds" {
  identifier                = "akumoapplicationdb"
  allocated_storage         = 10
  max_allocated_storage     = 100
  storage_type              = "gp2"
  port                      = "3306"
  engine                    = "mysql"
  engine_version            = "8.0.28"
  instance_class            = "db.t2.micro"
  db_name                   = "akumoproject"
  username                  = var.db_user
  db_subnet_group_name      = aws_db_subnet_group.app_subnet.name
  vpc_security_group_ids    = [aws_security_group.app_db_sg.id]
  password                  = random_password.db_random_password.result
  depends_on = [
    random_password.db_random_password
  ]
  publicly_accessible       = var.env == "dev" ? true : false
  skip_final_snapshot       = var.env != "prod" ? true : false
  final_snapshot_identifier = var.env != "prod" ? null : "${var.env}-final-shapshot"

  tags = merge(
    local.common_tags,
    {
      "Name" = "app-dev-ue1-rds-001"
    }
  )
}

resource "aws_db_subnet_group" "app_subnet" {
  name       = "rds_subnet_groups"
  subnet_ids = [var.rds_subnet_id, var.rds_subnet_id_2]

  tags = merge(
    local.common_tags,
    {
      "Name" = "subnet_group-dev-ue1-rds-001"
    }
  )
}