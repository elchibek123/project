locals {
  rds_creds = {
      "db_name": "${aws_db_instance.app_rds.name}",
      "user_name": "${var.db_user}",
      "rds_password": "${random_password.db_random_password.result}",
      "db_endpoint": "${aws_db_instance.app_rds.endpoint}"
    }
  common_tags = {
    OwnerID      = ""
    OwnerContact = ""
    Project      = "ak3"
    Environment  = "dev"
    Team         = "devops"
    ManagedBy    = "terraform"
  }
}