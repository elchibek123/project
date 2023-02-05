terraform {
  backend "s3" {
    bucket         = ""
    key            = "dev/config/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = ""
  }
}