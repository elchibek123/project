terraform {
  backend "s3" {
    bucket         = ""
    key            = "shs/ec2-jfrog/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = ""
  }
}