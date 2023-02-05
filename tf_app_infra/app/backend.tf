terraform {
  backend "s3" {
    bucket         = ""
    key            = "dev/app-infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = ""
  }
}