terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region

  assume_role {
    role_arn     = var.assume_role_arn
    session_name = var.assume_role_session_name
  }
}
