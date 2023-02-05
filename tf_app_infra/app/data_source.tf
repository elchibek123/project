data "aws_iam_policy" "app_policy" {
  name = "SecretsManagerReadWrite"
}

data "aws_route53_zone" "dev_zone" {
  name = "dev.example.com"
}

data "aws_acm_certificate" "acm" {
  domain = "app.dev.example.com"
  depends_on = [
    aws_acm_certificate.acm
  ]
}