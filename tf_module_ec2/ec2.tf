resource "aws_instance" "ak3-server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ak3-sg.id]
  subnet_id              = var.subnet
  key_name               = var.key-name
  tags = merge(
    local.common_tags,
    {
      "Name" = "${var.product-name}-${var.environment}-ue1-ec2-00${var.resource-number}"
    }
  )
}

resource "aws_eip" "ak3-eip" {
  instance = aws_instance.ak3-server.id
  vpc      = true
  tags = merge(
    local.common_tags,
    {
      "Name" = "${var.product-name}-${var.environment}-ue1-eip-00${var.resource-number}"
    }
  )
}

resource "aws_security_group" "ak3-sg" {
  name        = "${var.product-name}-${var.environment}-ue1-sg-00${var.resource-number}"
  description = "This SG is used for ${var.product-name} instance"
  vpc_id      = var.vpc

  ingress {
    description = "SSH ezhanybaiuulu"
    from_port   = local.ssh-port
    to_port     = local.ssh-port
    protocol    = "tcp"
    cidr_blocks = ["67.162.97.181/32"]
  }

  egress {
    description = "Anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "${var.product-name}-${var.environment}-ue1-sg-00${var.resource-number}"
    }
  )
}