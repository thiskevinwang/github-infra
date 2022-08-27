# Default GitHub provider
# This may be overridden by individual resources using the
# `provider` meta-argument
# 
# https://www.terraform.io/language/meta-arguments/resource-provider
provider "github" {
  owner = "thiskevinwang"
  token = var.gh_token
}
