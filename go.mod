module github.com/melorga/iac-modules

go 1.24

require (
	// TODO: bump terratest to current release (>= v0.49.0 expected as of
	// May 2026). Skipped here because this agent has no WebSearch/WebFetch
	// available to verify the latest published version.
	github.com/gruntwork-io/terratest v0.46.8
	github.com/stretchr/testify v1.8.4
)
