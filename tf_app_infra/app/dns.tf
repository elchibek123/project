resource "aws_route53_record" "dev_a" {
  name = "app.dev.example.com"
  type = "CNAME"
  records = [aws_lb.app_lb.dns_name]
  depends_on = [
    aws_lb.app_lb
  ]
  zone_id = data.aws_route53_zone.dev_zone.zone_id
  ttl     = "60"
}

resource "aws_acm_certificate" "acm" {
  domain_name       = "app.dev.example.com"
  validation_method = "DNS"
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dev_record" {
  for_each = {
    for dvo in aws_acm_certificate.acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.dev_zone.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.acm.arn
  validation_record_fqdns = [for record in aws_route53_record.dev_record : record.fqdn]
}