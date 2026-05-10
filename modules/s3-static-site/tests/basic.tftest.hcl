# Native Terraform test stub. Plan-only validation of the module against
# the smallest valid input set. Exercised in CI by `terraform test`.

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

variables {
  bucket_name = "tftest-static-site-example"
}

run "validate" {
  command = plan
}
