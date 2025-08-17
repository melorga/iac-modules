# Infrastructure as Code Modules

This repository contains Terraform modules for managing AWS infrastructure.

Enterprise-grade Terraform modules for AWS infrastructure, designed for production use with comprehensive testing and documentation.

## 🏗️ Available Modules

| Module | Description |
|--------|-------------|----------------|
| [s3-static-site](./modules/s3-static-site) | S3 + CloudFront static hosting |
| [eks-cluster](./modules/eks-cluster) | Production EKS cluster setup |
| [alb-fargate-service](./modules/alb-fargate-service) | Fargate service with ALB |
| [lambda-api](./modules/lambda-api) | Serverless API with Lambda |
| [rds-postgres](./modules/rds-postgres) | PostgreSQL RDS with encryption |

## 🚀 Quick Start

```hcl
# Use modules via Git with version pinning
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

## 🔧 Development

### Prerequisites

- Terraform >= 1.8
- Go >= 1.22 (for testing)
- AWS CLI configured
- tflint, tfsec, terraform-docs

### Testing

```bash
# Run static analysis
make lint

# Run unit tests
make test

# Run integration tests (requires AWS credentials)
make test-integration

# Generate documentation
make docs
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run the full test suite
6. Submit a pull request

## 📋 Module Standards

All modules in this repository follow these standards:

- **Semantic Versioning**: All releases use semver
- **Comprehensive Testing**: Unit and integration tests with Terratest
- **Security First**: tfsec and checkov compliance
- **Documentation**: Auto-generated with terraform-docs
- **Examples**: Working examples for each module
- **Backward Compatibility**: Maintained within major versions

## 🛡️ Security

- All modules pass tfsec security scanning
- Least privilege IAM policies
- Encryption at rest and in transit by default
- No hardcoded credentials or sensitive data

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Support

- 📚 [Documentation](https://github.com/melorga/iac-modules/wiki)
- 🐛 [Issues](https://github.com/melorga/iac-modules/issues)
- 💬 [Discussions](https://github.com/melorga/iac-modules/discussions)
