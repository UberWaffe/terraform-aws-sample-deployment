data "aws_caller_identity" "current" {}

// =============================
// Guardrails
// =============================
resource "null_resource" "tf_guard_provider_account_match" {
  count = tonumber(data.aws_caller_identity.current.account_id == var.aws_account_id ? "1" : "fail")
}

// =============================
// Naming
// =============================

locals {
  mandatory_tags = {
    "cat:application" = var.application_name.long
    "cat:client"      = var.client_name.long
    "cat:purpose"     = var.purpose
    "cat:owner"       = var.owner
    "cat:repo"        = var.code_repo
    "cat:nukeable"    = var.nukeable

    "tf:account_id" = data.aws_caller_identity.current.account_id
    "tf:caller_arn" = data.aws_caller_identity.current.arn
    "tf:user_id"    = data.aws_caller_identity.current.user_id

    "app:region"      = var.region
    "app:namespace"   = var.namespace
    "app:environment" = var.environment
  }

  naming_prefix = join("-", [
    var.client_name.short,
    var.application_name.short,
    var.environment,
    var.namespace
  ])
}

// =============================
// Output
// 
// We use various IaC tools and have found SSM Parameters
// a great way to share the output values between systems
// =============================

locals {
  outputs = {
    test_out = "Hello"
  }
}

// =============================
// Default Variables
// =============================
variable "region" {
  type        = string
  description = "The default region for the application / deployment"
}

variable "environment" {
  type        = string
  description = "Will this deploy a development (dev) or production (prod) environment"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Stage must be either 'dev' or 'prod'."
  }
}

variable "code_repo" {
  type        = string
  description = "Points to the source code used to deploy the resources {{repo}} [{{branch}}]"
}

variable "namespace" {
  type        = string
  description = "Used to identify which part of the application these resources belong to (auth, infra, api, web, data)"

  validation {
    condition     = contains(["auth", "infra", "api", "web", "data"], var.namespace)
    error_message = "Namespace needs to be : \"auth\", \"infra\", \"api\" or \"web\"."
  }
}

variable "application_name" {
  type = object({
    short = string
    long  = string
  })
  description = "Used in naming conventions, expecting an object"

  validation {
    condition     = length(var.application_name["short"]) <= 5
    error_message = "The application_name[\"short\"] needs to be less or equal to 5 chars."
  }

}

variable "nukeable" {
  type        = bool
  description = "Can these resources be cleaned up. Will be ignored for prod environments"
}

variable "client_name" {
  type = object({
    short = string
    long  = string
  })
  description = "Used in naming conventions, expecting an object"

  validation {
    condition     = length(var.client_name["short"]) <= 5
    error_message = "The client_name[\"short\"] needs to be less or equal to 5 chars."
  }
}

variable "purpose" {
  type        = string
  description = "Used for cost allocation purposes"

  validation {
    condition     = contains(["rnd", "client", "product"], var.purpose)
    error_message = "Purpose needs to be : \"rnd\", \"client\", \"product\"."
  }
}

variable "owner" {
  type        = string
  description = "Used to find resources owners, expects an email address"

  validation {
    condition     = can(regex("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$", var.owner))
    error_message = "Owner needs to be a valid email address."
  }
}

variable "aws_account_id" {
  type        = string
  description = "Needed for Guards to ensure code is being deployed to the correct account"
}