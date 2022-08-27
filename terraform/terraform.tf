# Configuration for Terraform itself
terraform {
  cloud {
    organization = "github-infra"
    workspaces {
      name = "github-infra"
    }
  }

  required_version = "~> 1.0"
  required_providers {
    github = "~> 4.29"
  }
}
