# Makefile for C2P Plugins Contrib

.PHONY: help build build-plugins clean test lint regenerate-manifests

# Default target
help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Build all plugins
build-plugins: ## Build all plugins
	@echo "Building all plugins..."
	@for plugin in */; do \
		if [ -f "$$plugin/main.go" ]; then \
			echo "Building $$plugin..."; \
			(cd "$$plugin" && go build -o "../c2p-plugins/$$(basename "$$plugin")" .); \
		fi; \
	done
	@echo "All plugins built successfully!"

# Build individual plugins
build-kyverno: ## Build kyverno plugin
	@echo "Building kyverno plugin..."
	@mkdir -p c2p-plugins
	@cd kyverno-plugin && go build -o ../c2p-plugins/kyverno-plugin .

build-ocm: ## Build ocm plugin
	@echo "Building ocm plugin..."
	@mkdir -p c2p-plugins
	@cd ocm-plugin && go build -o ../c2p-plugins/ocm-plugin .

# Clean build artifacts
clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	@rm -rf c2p-plugins/
	@echo "Clean completed!"

# Run tests
test: ## Run tests for all plugins
	@echo "Running tests..."
	@go test ./...

# Run linting
lint: ## Run linting
	@echo "Running linter..."
	@golangci-lint run

# Regenerate manifests
regenerate-manifests: ## Regenerate plugin manifests for release
	@echo "Regenerating plugin manifests..."
	@./hack/regenerate-manifests.sh

# Install dependencies
deps: ## Install Go dependencies
	@echo "Installing dependencies..."
	@go mod download
	@go mod tidy

# Format code
fmt: ## Format Go code
	@echo "Formatting code..."
	@go fmt ./...

# Vet code
vet: ## Run go vet
	@echo "Running go vet..."
	@go vet ./...

# Build for release (used by Go Releaser)
build: clean build-plugins regenerate-manifests ## Build for release

# Development setup
dev-setup: deps ## Setup development environment
	@echo "Setting up development environment..."
	@mkdir -p bin
	@mkdir -p c2p-plugins
	@echo "Development environment ready!"

# Check if required tools are installed
check-tools: ## Check if required tools are installed
	@echo "Checking required tools..."
	@command -v go >/dev/null 2>&1 || { echo "Error: go is required but not installed."; exit 1; }
	@command -v jq >/dev/null 2>&1 || { echo "Error: jq is required but not installed."; exit 1; }
	@command -v git >/dev/null 2>&1 || { echo "Error: git is required but not installed."; exit 1; }
	@echo "All required tools are installed!"

# Default target
.DEFAULT_GOAL := help