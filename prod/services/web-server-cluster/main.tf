# Partial configuration. The other settings (e.g., bucket, region) will be
# passed in from a file via 'terraform init -backend-config=backend.hcl'
terraform {
  backend "s3" {
    key = "prod/services/web-server-cluster/terraform.tfstate"
  }
}

module "web_server_cluster" {
  source = "github.com/vladyslav-khymenko/terraform-modules//services/web-server-cluster?ref=v0.0.1"

  cluster_name = "web-servers-prod"
  db_remote_state_bucket = "terraform-up-n-running-state-07042023"
  db_remote_state_key = "prod/data-stores/postgres/terraform.tfstate"

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 10
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"

  autoscaling_group_name = module.web_server_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name  = "scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 17 * * *"

  autoscaling_group_name = module.web_server_cluster.asg_name
}
