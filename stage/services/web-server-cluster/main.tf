# Partial configuration. The other settings (e.g., bucket, region) will be
# passed in from a file via 'terraform init -backend-config=backend.hcl'
terraform {
  backend "s3" {
    key = "stage/services/web-server-cluster/terraform.tfstate"
  }
}

module "web_server_cluster" {
  source = "github.com/vladyslav-khymenko/terraform-modules//services/web-server-cluster?ref=v0.0.12"

  server_text = "New server text from stage"

  cluster_name           = "web-servers-stage"
  db_remote_state_bucket = "terraform-up-n-running-state-07042023"
  db_remote_state_key    = "stage/data-stores/postgres/terraform.tfstate"
  enable_autoscaling     = false

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.web_server_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
