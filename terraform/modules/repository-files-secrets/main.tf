###################
###    Module   ###
###################

# Clone repo
data "github_repository" "repository" {
  name = var.repository
}

# Check if a previous branch was created
# data "github_branch" "remote_branch" {
#   repository = data.github_repository.repository.full_name
#   branch     = local.branch
# }

locals {
  codeowners = templatefile(
    "${path.module}/templates/CODEOWNERS.tftpl",
    {
      repository = var.repository
    }
  )
}

# Create a git branch
resource "github_branch" "branch" {
  count = 0
  repository    = data.github_repository.repository.name
  source_branch = data.github_repository.repository.default_branch
  branch        = "automated-${replace(timestamp(), ":", "_")}"
  # branch = "automated-${sha1(local.codeowners)}"

  # https://github.com/hashicorp/terraform/blob/main/docs/planning-behaviors.md#configuration-driven-behaviors
  lifecycle {
    ignore_changes = all
  }
}


# Modify a file
resource "github_repository_file" "codeowners" {
  repository = data.github_repository.repository.name
  branch     = github_branch.branch.branch

  file                = ".github/CODEOWNERS"
  content             = local.codeowners
  commit_message      = "[skip ci] This was generated by `gitub-infra`"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = all
  }
}

# Open a PR
resource "github_repository_pull_request" "pull_request" {
  # depends_on = [
  #   github_repository_file.codeowners
  # ]
  base_repository = data.github_repository.repository.name
  base_ref        = "main"
  head_ref        = github_repository_file.codeowners.branch
  title           = "CODEOWNERS"
  body = templatefile(
    "${path.module}/templates/pr-body.tftpl",
    {}
  )

  # https://github.com/hashicorp/terraform/blob/main/docs/planning-behaviors.md#configuration-driven-behaviors
  count = 0
  lifecycle {
    ignore_changes = all
  }
}

resource "github_actions_secret" "elevated_token" {
  repository      = data.github_repository.repository.name
  secret_name     = "TF_SECRET"
  plaintext_value = var.tf_secret

  lifecycle {
    ignore_changes = all
  }
}
