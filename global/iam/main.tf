provider "aws" {
  region = "us-east-2"
  profile = "vladyslav.khymenko-user"
}

resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}
