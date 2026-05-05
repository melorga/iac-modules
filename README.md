# iac-modules

Reusable AWS Terraform modules — currently: **S3 static site**.

## Implemented

| Module | Description |
|--------|-------------|
| [s3-static-site](./modules/s3-static-site) | Private S3 bucket fronted by CloudFront (OAC), hardened response headers, optional Route 53 aliases. |

## Roadmap (not yet implemented)

These modules are planned but **not present in this repository yet**. Tracking-only:

- `eks-cluster` — production EKS cluster setup
- `alb-fargate-service` — Fargate service behind an ALB
- `lambda-api` — serverless API with Lambda + API Gateway
- `rds-postgres` — PostgreSQL RDS with encryption and backups

If you need any of these, open an issue and it will be prioritized.

## Quick Start

```hcl
module "static_site" {
  source = "git::ssh://git@github.com/melorga/iac-modules.git//modules/s3-static-site?ref=v1.0.0"

  bucket_name = "my-awesome-website"
  domain_name = "example.com"

  tags = {
    Project = "MyProject"
    Owner   = "MyTeam"
  }
}
```

See [`modules/s3-static-site/README.md`](./modules/s3-static-site/README.md) for full inputs/outputs.

## Development

### Prerequisites

- Terraform >= 1.9, < 2.0
- Go >= 1.22 (only required for the optional Terratest suite)
- AWS CLI configured
- `tflint` (CI uses v4)

### Common targets

```bash
make validate          # init + validate every module and example
make lint              # tflint + tfsec
make test              # native `terraform test` (plan-only stubs)
make test-integration  # Terratest — creates real AWS resources
```

## Module Standards

- **Semantic Versioning** for releases
- **Native Terraform tests** (`*.tftest.hcl`) for every module; Terratest for paid integration runs
- **Security-first**: Trivy config scans in CI, IAM least privilege, encryption on by default, no public S3
- **Examples**: each module ships a runnable `examples/<module>` configuration
- **Backward compatibility** is maintained within a major version

## Security

See [SECURITY.md](./SECURITY.md) for how to report vulnerabilities. Modules pass Trivy `config` scans in CI; results are uploaded to GitHub code scanning.

## License

MIT — see [LICENSE](LICENSE).
