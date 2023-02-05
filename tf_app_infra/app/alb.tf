# Application Load Balancer

resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_alb_sg.id]
  subnets            = [var.subnet_id, var.rds_subnet_id_2]

  tags = merge(
    local.common_tags,
    {
      Name = "alb-dev-ue1-lb-001"
    }
  )
}

# Target Group

resource "aws_lb_target_group" "app_tg" {
  name                          = "tg-dev-ue1-lb-001"
  port                          = 5000
  protocol                      = "HTTP"
  vpc_id                        = var.vpc_id
  load_balancing_algorithm_type = "least_outstanding_requests"
  health_check {
    path    = "/"
    port    = 5000
    matcher = "200"
  }
  depends_on = [
    aws_lb.app_lb
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Target Group Attachment

resource "aws_lb_target_group_attachment" "app_tg_attach" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_ec2.id
  port             = 5000
}

# Listener

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.acm.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}