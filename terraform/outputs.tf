# Output each repository-settings' pull request URL.
# output "pull_request" {
#   value = {
#     for k, v in module.repository-files-secrets :
#     k => v.pull_request_url
#   }
# }


output "branch" {
  value = {
    for k, v in module.repository-files-secrets :
    k => v.branch
  }
}