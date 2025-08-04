# S3 Static Site Module

This module creates a static website hosting setup using S3, CloudFront, and optionally Route 53.

## Features

- S3 bucket configured for static website hosting
- CloudFront distribution with Origin Access Control
- SSL/TLS termination with ACM certificates
- Route 53 DNS records (optional)
- Proper security configurations
- Cost-optimized CloudFront settings

## Usage

```hcl
module "static_site" {
  source = "git::ssh://git@github.com/melorga/iac-modules.git//modules/s3-static-site?ref=v1.0.0"

  bucket_name     = "my-awesome-website"
  domain_name     = "example.com"
  subdomain       = "www"
  ssl_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234"

  tags = {
    Project = "MyWebsite"
    Owner   = "TeamName"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.8 |
| aws | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket_name | Name of the S3 bucket for static website hosting | string | n/a | yes |
| domain_name | Domain name for the website (optional) | string | null | no |
| subdomain | Subdomain for the website (optional) | string | null | no |
| ssl_certificate_arn | ARN of SSL certificate in ACM (us-east-1) | string | null | no |

## Outputs

| Name | Description |
|------|-------------|
| website_url | URL of the website |
| bucket_name | Name of the S3 bucket |
| cloudfront_distribution_id | ID of the CloudFront distribution |

## Security Considerations

- S3 bucket is private with CloudFront Origin Access Control
- HTTPS is enforced via CloudFront
- Server-side encryption enabled on S3
