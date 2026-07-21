# Terraform Enterprise / HCP Terraform remote backend configuration.
#
# Point this at your own TFE organization + hostname to run this repo as a
# VCS-driven workspace: connect the workspace to this repo in TFE, and every
# push triggers a remote plan/apply governed by the Sentinel policy in
# ./sentinel. For a self-hosted TFE instance, set `hostname` to your TFE
# server's hostname instead of app.terraform.io.

terraform {
  cloud {
    organization = "your-tfe-org"
    hostname     = "app.terraform.io"

    workspaces {
      tags = ["task-manager", "showcase"]
    }
  }

  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
