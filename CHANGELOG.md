# Changelog

All notable changes to this project will be documented in this file. The
format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased] - audit fixes

### Security
- **s3-static-site**: `aws_s3_bucket_public_access_block` now sets all four
  flags to `true` (previously `false`). The bucket is private; CloudFront OAC
  is the only authorized reader.
- **s3-static-site**: bucket policy principal scoped to
  `Service = cloudfront.amazonaws.com` (was wildcard `*`); `AWS:SourceArn`
  condition retained.
- **s3-static-site**: added `aws_s3_bucket_ownership_controls` with
  `BucketOwnerEnforced` to disable ACLs.
- **s3-static-site**: added `aws_cloudfront_response_headers_policy` with
  HSTS (preload), `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`,
  `Referrer-Policy: strict-origin-when-cross-origin`, and a baseline CSP
  (`default-src 'self'`).

### Changed
- **s3-static-site**: replaced deprecated `forwarded_values` with AWS managed
  cache (CachingOptimized) and origin-request (CORS-S3Origin) policies.
- **s3-static-site**: restricted `allowed_methods` to `GET/HEAD/OPTIONS`.
- **s3-static-site**: bumped `required_version` to `>= 1.9, < 2.0` and AWS
  provider to `~> 6.0`; extracted into `versions.tf`.
- **examples/s3-static-site**: dropped `timestamp()` from `aws_s3_object`
  (perpetual diff); now uses `source` + `filemd5` etag.
- **README**: catalog trimmed to the only implemented module; the four
  unimplemented modules moved to a Roadmap section.

### Added
- Native `terraform test` stub at `modules/s3-static-site/tests/basic.tftest.hcl`.
- GitHub Actions: `ci.yml` (fmt, tflint, matrix validate, Trivy SARIF,
  `terraform test`) and `terratest.yml` (weekly OIDC integration).
- Dependabot config (terraform / github-actions / gomod).
- `CODEOWNERS`, `SECURITY.md`, `CHANGELOG.md`.

### Fixed
- `.gitignore`: removed `*.md` blanket ignore + `README.md` allowlist quirk
  that prevented adding CHANGELOG/SECURITY/CONTRIBUTING; stopped ignoring
  `.terraform.lock.hcl`.
