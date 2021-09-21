region      = "eu-west-1"
environment = "dev"
code_repo   = "https://github.com/UberWaffe/terraform-aws-sample-deployment"
namespace   = "infra"

application_name = {
  short = "asd",
  long  = "aws-sample-d"
}

nukeable = true

client_name = {
  short = "ct2",
  long  = "Cloudandthings"
}

purpose = "rnd"
owner   = "shawn@cloudandthings.io"

aws_account_id           = "353444730604"
assume_role_arn          = "5"
assume_role_session_name = "6"