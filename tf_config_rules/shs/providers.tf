provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam:::role/iam_exec_role-all-ue1-rl-001"
  }
}