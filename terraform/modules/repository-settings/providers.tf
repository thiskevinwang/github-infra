# This is available as an override to the root-level "github" provider
provider "github" {
  alias = "nextjs-components"
  owner = "nextjs-components"
  token = var.gh_token
}
