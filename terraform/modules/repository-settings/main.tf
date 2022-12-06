locals {
  shared_settings = {
    allow_merge_commit     = false
    allow_rebase_merge     = false
    allow_squash_merge     = true
    delete_branch_on_merge = true
  }
}

#################################################################################################
# See docs on `github — github_repository`                                                      #
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository  #
#################################################################################################

resource "github_repository" "workflows-test" {
  name = "workflows-test"

  description = "A test repository for various things. (This was generated by terraform)"
  visibility  = "public"

  allow_merge_commit     = local.shared_settings.allow_merge_commit
  allow_rebase_merge     = local.shared_settings.allow_rebase_merge
  allow_squash_merge     = local.shared_settings.allow_squash_merge
  delete_branch_on_merge = local.shared_settings.delete_branch_on_merge

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository" "thekevinwang_com" {
  name = "thekevinwang.com"

  description = "Personal website."
  visibility  = "private"

  allow_merge_commit     = local.shared_settings.allow_merge_commit
  allow_rebase_merge     = local.shared_settings.allow_rebase_merge
  allow_squash_merge     = local.shared_settings.allow_squash_merge
  delete_branch_on_merge = local.shared_settings.delete_branch_on_merge

  has_downloads = true
  has_issues    = true
  has_wiki      = true
  has_projects  = true

  homepage_url = "https://thekevinwang.com"

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository" "nextjs-components_nextjs-components" {
  name = "nextjs-components"

  description = "A collection of React components, transcribed from https://vercel.com/design."
  visibility  = "public"

  allow_merge_commit     = local.shared_settings.allow_merge_commit
  allow_rebase_merge     = local.shared_settings.allow_rebase_merge
  allow_squash_merge     = local.shared_settings.allow_squash_merge
  delete_branch_on_merge = local.shared_settings.delete_branch_on_merge

  has_downloads = true
  has_issues    = true
  has_wiki      = true
  has_projects  = true

  homepage_url = "https://nextjs-components-thekevinwang.vercel.app/"

  topics = [
    "react",
    "nextjs",
    "design",
    "typescript",
    "components",
    "css-modules",
    "design-system"
  ]

  lifecycle {
    prevent_destroy = true
  }

  # Use different owner
  # https://www.terraform.io/language/meta-arguments/resource-provider
  provider = github.nextjs-components
}

