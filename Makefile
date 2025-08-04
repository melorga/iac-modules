.DEFAULT_GOAL := help
.PHONY: help init validate format lint test test-integration docs clean

# Variables
TERRAFORM_VERSION := 1.8.5
GO_VERSION := 1.22

# Help target
help: ## Show this help message
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Initialize Terraform in all examples
	@echo "Initializing Terraform in all examples..."
	@for dir in examples/*/; do \
		echo "Initializing $$dir"; \
		terraform -chdir=$$dir init; \
	done

validate: ## Validate all Terraform configurations
	@echo "Validating Terraform configurations..."
	@for dir in modules/*/; do \
		echo "Validating $$dir"; \
		terraform -chdir=$$dir init -backend=false; \
		terraform -chdir=$$dir validate; \
	done
	@for dir in examples/*/; do \
		echo "Validating $$dir"; \
		terraform -chdir=$$dir init; \
		terraform -chdir=$$dir validate; \
	done

format: ## Format all Terraform files
	@echo "Formatting Terraform files..."
	@terraform fmt -recursive .

lint: ## Run linting tools
	@echo "Running tflint..."
	@for dir in modules/*/; do \
		echo "Linting $$dir"; \
		cd $$dir && tflint --init && tflint; \
		cd ../..; \
	done
	@echo "Running tfsec..."
	@tfsec .

test: ## Run Go unit tests
	@echo "Running Go tests..."
	@go mod tidy
	@go test -v ./tests/... -timeout 45m

test-integration: ## Run integration tests (requires AWS credentials)
	@echo "Running integration tests..."
	@echo "Warning: This will create real AWS resources and may incur costs!"
	@go test -v ./tests/... -timeout 45m -tags=integration

docs: ## Generate documentation
	@echo "Generating documentation..."
	@for dir in modules/*/; do \
		echo "Generating docs for $$dir"; \
		terraform-docs markdown table $$dir --output-file README.md; \
	done

clean: ## Clean up temporary files
	@echo "Cleaning up..."
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find . -name "*.tfplan" -delete
	@find . -name "terraform.tfstate*" -delete
	@find . -name ".terraform.lock.hcl" -delete

# Development targets
plan-example: ## Plan a specific example (usage: make plan-example EXAMPLE=s3-static-site)
	@if [ -z "$(EXAMPLE)" ]; then echo "Usage: make plan-example EXAMPLE=s3-static-site"; exit 1; fi
	@terraform -chdir=examples/$(EXAMPLE) plan

apply-example: ## Apply a specific example (usage: make apply-example EXAMPLE=s3-static-site)
	@if [ -z "$(EXAMPLE)" ]; then echo "Usage: make apply-example EXAMPLE=s3-static-site"; exit 1; fi
	@terraform -chdir=examples/$(EXAMPLE) apply

destroy-example: ## Destroy a specific example (usage: make destroy-example EXAMPLE=s3-static-site)
	@if [ -z "$(EXAMPLE)" ]; then echo "Usage: make destroy-example EXAMPLE=s3-static-site"; exit 1; fi
	@terraform -chdir=examples/$(EXAMPLE) destroy

# Version checks
check-versions: ## Check tool versions
	@echo "Terraform version:"
	@terraform version
	@echo "Go version:"
	@go version
	@echo "tflint version:"
	@tflint --version
	@echo "tfsec version:"
	@tfsec --version
