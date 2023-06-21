[![CI](https://github.com/bihealth/annonars-data-clinvar/actions/workflows/build.yml/badge.svg)](https://github.com/bihealth/annonars-data-clinvar/actions/workflows/build.yml)

# `annonars` ClinVar Data Builds

# Developer Documentation

The following is for developers of `annonars-data-clinvar` itself.

## Managing Project with Terraform

```
# export GITHUB_OWNER=bihealth
# export GITHUB_TOKEN=ghp_TOKEN

# cd utils/terraform
# terraform init
# terraform import github_repository.annonars-data-clinvar annonars-data-clinvar
# terraform validate
# terraform fmt
# terraform plan
# terraform apply
```
