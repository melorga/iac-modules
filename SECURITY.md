# Security Policy

## Reporting a Vulnerability

If you discover a security issue in any module in this repository, **please do
not open a public issue**. Instead, report it privately via GitHub:

- Use the repository's ["Report a vulnerability"](https://github.com/melorga/iac-modules/security/advisories/new) form
  (Security tab → *Report a vulnerability*).

You should receive an acknowledgement within **72 hours**. We will work with
you to confirm the issue, develop a fix, and coordinate disclosure.

## Supported Versions

Only the latest minor release of each module is actively patched. Older
versions may receive fixes on a best-effort basis.

## Scope

In-scope:

- Misconfigurations in the Terraform modules under `modules/*` that could
  expose data or grant unintended access (e.g. public S3, overly broad IAM).
- Vulnerabilities in CI workflows under `.github/workflows/` (e.g. command
  injection, secret exfiltration).

Out-of-scope:

- Issues in upstream Terraform providers — please report those to HashiCorp
  or the provider maintainers directly.
