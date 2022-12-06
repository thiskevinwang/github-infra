# output "pull_request_url" {
#   value = format("%s/pull/%s", data.github_repository.repository.html_url, github_repository_pull_request.pull_request.number)
# }

output "branch" {
  value = github_branch.branch.branch
}