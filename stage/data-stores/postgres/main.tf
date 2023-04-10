resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running-pg"
  engine              = "postgres"
  engine_version      = "12"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true
  db_name             = "example_database"

  username = var.db_username
  password = var.db_password
}

# Partial configuration. The other settings (e.g., bucket, region) will be
# passed in from a file via 'terraform init -backend-config=backend.hcl'
terraform {
  backend "s3" {
    key = "stage/data-stores/postgres/terraform.tfstate"
  }
}
