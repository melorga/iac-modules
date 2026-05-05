# Native Terraform test stub. Plan-only validation of the module against
# the smallest valid input set. Exercised in CI by `terraform test`.

variables {
  bucket_name = "tftest-static-site-example"
}

run "validate" {
  command = plan
}
