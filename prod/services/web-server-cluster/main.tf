# Partial configuration. The other settings (e.g., bucket, region) will be
# passed in from a file via 'terraform init -backend-config=backend.hcl'
terraform {
  backend "s3" {
    key = "prod/services/web-server-cluster/terraform.tfstate"
  }
}

module "web_server_cluster" {
  source = "github.com/vladyslav-khymenko/terraform-modules//services/web-server-cluster?ref=v0.0.12"

  server_text = "New server text from prod"

  cluster_name           = "web-servers-prod"
  db_remote_state_bucket = "terraform-up-n-running-state-07042023"
  db_remote_state_key    = "prod/data-stores/postgres/terraform.tfstate"
  enable_autoscaling     = true

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 10

  custom_tags = {
    Owner     = "wonderful-team"
    ManagedBy = "terraform"
  }
}
