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

locals {
  branch = "automated-${replace(timestamp(), ":", "_")}"
}

# Create a git branch
resource "github_branch" "branch" {
  repository    = data.github_repository.repository.name
  source_branch = data.github_repository.repository.default_branch
  branch       = local.branch
  # branch        = "automated-${replace(timestamp(), ":", "_")}"
  # branch = "automated-${sha1(local.codeowners)}"

  # https://github.com/hashicorp/terraform/blob/main/docs/planning-behaviors.md#configuration-driven-behaviors
  lifecycle {
    # ignore_changes = all
    create_before_destroy = true
    # prevent_destroy = true
  }
}

resource "null_resource" "local-exec" {
  provisioner "local-exec" {
    interpreter = ["bash", "-exuc"]
    command     = <<EOC
      # Check if the target branch exists and create it if not
      if [ "$(curl -s -w "%%{http_code}" -X HEAD -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/${var.repository}/branches/${local.branch})" == "404" ]; then
        default_branch_sha=$(curl -s -X GET -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/${var.repository}/branches/${data.github_repository.repository.default_branch} | jq -r .commit.sha)
        curl -X POST -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/${var.repository}/git/refs -d '{"ref": "refs/heads/${local.branch}", "sha": "'$default_branch_sha'"}'
        branch_is_new=true
      fi
    EOC
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}


# Modify a file
resource "github_repository_file" "codeowners" {
  depends_on = [
    null_resource.local-exec
  ]
  repository = data.github_repository.repository.name
  branch     = github_branch.branch.branch

  file                = ".github/CODEOWNERS"
  content             = local.codeowners
  commit_message      = "[skip ci] This was generated by `gitub-infra`"
  overwrite_on_create = true

  lifecycle {
    # Replace `github_repository_file` each time this instance of
    # the `github_branch` is replaced.
    replace_triggered_by = [
      github_branch.branch.branch
    ]
    ignore_changes = all
    # prevent_destroy = true
    create_before_destroy = true
  }
}

# Open a PR
# resource "github_repository_pull_request" "pull_request" {
#   # depends_on = [
#   #   github_repository_file.codeowners
#   # ]
#   base_repository = data.github_repository.repository.name
#   base_ref        = "main"
#   head_ref        = github_repository_file.codeowners.branch
#   title           = "CODEOWNERS"
#   body = templatefile(
#     "${path.module}/templates/pr-body.tftpl",
#     {}
#   )

#   # https://github.com/hashicorp/terraform/blob/main/docs/planning-behaviors.md#configuration-driven-behaviors
#   count = 0
#   lifecycle {
#     ignore_changes = all
#   }
# }

resource "github_actions_secret" "elevated_token" {
  repository      = data.github_repository.repository.name
  secret_name     = "TF_SECRET"
  plaintext_value = var.tf_secret

  lifecycle {
    ignore_changes = all
  }
}
