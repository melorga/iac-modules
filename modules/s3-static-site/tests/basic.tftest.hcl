# Native Terraform test stub. Plan-only validation against the module example.
# Exercised in CI by `terraform test`.

run "validate" {
  command = plan

  module {
    source = "./examples/s3-static-site"
  }
}
