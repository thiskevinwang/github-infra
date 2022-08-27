# GitHub Infra

This a centralized Terraform config for multiple GitHub repositories

It manages
- Repository settings (like allowing only squash merges)
- Repository secrets
- Repository files

## Importing into state

```bash
terraform import 'module.repositories.github_repository.workflows-test' "workflows-test"
```

## Removing from state

```bash
terraform state rm 'module.repositories.github_repository.workflows-test'
terraform state rm github_repository.workflows-test
```

## Structure

```
.
└── terraform
    ├── main.tf
    ├── modules
    │   ├── repository-files-secrets
    │   └── repository-settings
    ├── outputs.tf
    ├── terraform.tf
    ├── terraform.tfvars
    └── variables.tf
```