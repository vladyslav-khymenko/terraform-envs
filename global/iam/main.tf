terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  profile = "vladyslav.khymenko-user"
}

# resource "aws_iam_user" "example" {
#   count = length(var.user_names)
#   name  = var.user_names[count.index]
# }

resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name     = each.value
}
