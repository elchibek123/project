# Application Security Group

resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "This is a Security Group for aKumoApplication instance"
  vpc_id      = var.vpc_id
  tags = merge(
    local.common_tags,
    {
      "Name" = "app-dev-ue1-sg-001"
    }
  )
}

resource "aws_security_group_rule" "ingress_rule" {
  count                  = 3
  type                   = "ingress"
  from_port              = element(var.ingress_port, count.index)
  to_port                = element(var.ingress_port, count.index)
  protocol               = "tcp"
  source_security_group_id = aws_security_group.app_alb_sg.id
  #cidr_blocks             = ["24.1.202.195/32", "67.162.97.181/32", "34.199.54.113/32", "34.232.25.90/32", "34.232.119.183/32", "34.236.25.177/32", "35.171.175.212/32", "52.54.90.98/32", "52.202.195.162/32", "52.203.14.55/32", "52.204.96.37/32","34.218.156.209/32", "34.218.168.212/32","52.41.219.63/32","35.155.178.254/32", "35.160.177.10/32", "34.216.18.129/32", "3.216.235.48/32", "34.231.96.243/32", "44.199.3.254/32", "174.129.205.191/32", "44.199.127.226/32", "44.199.45.64/32", "3.221.151.112/32", "52.205.184.192/32", "52.72.137.240/32"]
  security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "egress_rule" {
  type                   = "egress"
  from_port              = 0
  to_port                = 0
  protocol               = "-1"
  cidr_blocks             = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_sg.id
}

# RDS Security Group

resource "aws_security_group" "app_db_sg" {
    name = "app_rds_sg"
    description = "This is a Security Group for aKumoApplication RDS instance"
    vpc_id =  var.vpc_id

    tags = merge(
    local.common_tags,
    {
      "Name" = "app_rds-dev-ue1-sg-001"
    }
  )

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.app_sg.id]

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
}

# Application Load Balancer Security Group

resource "aws_security_group" "app_alb_sg" {
  name        = "alb-dev-ue1-sg-001"
  description = "This is a SG for ALB"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      "Name" = "alb-dev-ue1-sg-001"
    }
  )
}
resource "aws_security_group_rule" "alb_ingress_rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_alb_sg.id
}
resource "aws_security_group_rule" "alb_egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_alb_sg.id
}
