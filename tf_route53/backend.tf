terraform {
  backend "s3" {
    bucket         = ""
    key            = "all/route53/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = ""
  }
}