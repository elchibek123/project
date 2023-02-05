resource "random_password" "db_random_password"{
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "db_password_secret" {
  name = "aKumoAppCreds"
  depends_on = [
    aws_db_instance.app_rds
  ]
}

resource "aws_secretsmanager_secret_version" "db_password_secret_version" {
  secret_id = aws_secretsmanager_secret.db_password_secret.id
  secret_string = jsonencode(local.rds_creds)
}