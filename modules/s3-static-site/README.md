# S3 Static Site Module

This module creates a static website hosting setup using S3, CloudFront, and optionally Route 53.

## Features

- Private S3 bucket (all public access blocked) served exclusively via CloudFront OAC
- Bucket policy scoped to the `cloudfront.amazonaws.com` service principal with `AWS:SourceArn` condition
- BucketOwnerEnforced object ownership (ACLs disabled)
- AES256 server-side encryption
- Versioning (toggleable)
- CloudFront with managed cache + origin-request policies (CachingOptimized, CORS-S3Origin)
- Hardened security response headers (HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, basic CSP)
- Optional Route 53 A/AAAA aliases

## Usage

```hcl
module "static_site" {
  source = "git::ssh://git@github.com/melorga/iac-modules.git//modules/s3-static-site?ref=v1.0.0"

  bucket_name         = "my-awesome-website"
  domain_name         = "example.com"
  subdomain           = "www"
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
| terraform | >= 1.9, < 2.0 |
| aws | ~> 6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket_name | Name of the S3 bucket for static website hosting | string | n/a | yes |
| domain_name | Domain name for the website (optional) | string | null | no |
| subdomain | Subdomain for the website (optional) | string | null | no |
| ssl_certificate_arn | ARN of SSL certificate in ACM (us-east-1) | string | null | no |
| index_document | Name of the index document | string | "index.html" | no |
| error_document | Name of the error document | string | "error.html" | no |
| versioning_enabled | Enable versioning on the S3 bucket | bool | true | no |
| force_destroy | Allow bucket to be destroyed even if it contains objects | bool | false | no |
| cloudfront_price_class | CloudFront price class | string | "PriceClass_100" | no |
| domain_aliases | List of CloudFront alternate domain names | list(string) | [] | no |
| tags | Tags to apply to resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| website_url | URL of the website |
| bucket_name | Name of the S3 bucket |
| bucket_arn | ARN of the S3 bucket |
| bucket_domain_name | Domain name of the S3 bucket |
| cloudfront_distribution_id | ID of the CloudFront distribution |
| cloudfront_domain_name | Domain name of the CloudFront distribution |
| route53_record_fqdn | FQDN of the Route 53 record (if created) |

## Security Considerations

- S3 bucket is fully private (`block_public_*` flags all `true`); CloudFront OAC is the only authorized reader
- HTTPS enforced via CloudFront `redirect-to-https`
- Server-side encryption (AES256) enabled on S3
- Default security headers attached to every response (HSTS preload, frame-deny, nosniff, strict referrer, baseline CSP)
