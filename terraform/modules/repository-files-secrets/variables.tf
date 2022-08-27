# These variables are meant to be populated by the root module,
# which calls out to this module via `module "repository-settings" {`

variable "repository" {
  type = string
}


variable "tf_secret" {
  type = string
}

