# Add to this list to automate secret / file creation
variable "repositories" {
  type = map(object({
    tf_secret = string
  }))
  default = {
    "workflows-test" = {
      tf_secret = "Created_by_terraform"
    }
    "thekevinwang.com" = {
      tf_secret = "Created_by_terraform"
    }
  }
}

# This module doesn't require each repository to be 
# managed by TF state
module "repository-files-secrets" {
  for_each = var.repositories

  source = "./modules/repository-files-secrets"

  repository = each.key
  tf_secret  = each.value.tf_secret

}

# This module requires each repository to be managed by TF state
# Previously created repositories need to be manually imported
module "repository-settings" {
  source = "./modules/repository-settings"
}
