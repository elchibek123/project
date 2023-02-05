resource "aws_security_group" "sg" {
  name        = "jfrog_sg"
  description = "This is a Security Group for Jfrog instance"
  vpc_id      = var.vpc_id
  tags = merge(
    local.common_tags,
    {
      "Name" = "jfrog-shs-ue1-sg-001"
    }
  )
}

resource "aws_security_group_rule" "ingress_rule" {
  count                  = 4
  type                   = "ingress"
  from_port              = element(var.ingress_port, count.index)
  to_port                = element(var.ingress_port, count.index)
  protocol               = "tcp"
  cidr_blocks             = ["24.1.202.195/32", "67.162.97.181/32"]
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "engress_rule" {
  type                   = "egress"
  from_port              = 0
  to_port                = 0
  protocol               = "-1"
  cidr_blocks             = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}