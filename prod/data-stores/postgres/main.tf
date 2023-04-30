# data "aws_secretsmanager_secret_version" "creds" {
#   secret_id = "db-creds"
# }

# locals {
#   db_creds = jsondecode(
#     data.aws_secretsmanager_secret_version.creds.secret_string
#   )
# }

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running-pg-prod"
  engine              = "postgres"
  engine_version      = "12"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true
  db_name             = "example_database_prod"

  # username = local.db_creds.username
  # password = local.db_creds.password
  username = var.db_username
  password = var.db_password
}

# Partial configuration. The other settings (e.g., bucket, region) will be
# passed in from a file via 'terraform init -backend-config=backend.hcl'
terraform {
  backend "s3" {
    key = "prod/data-stores/postgres/terraform.tfstate"
  }
}
