# Variables
IMAGE_NAME ?= ollama-git-skill
TAG ?= latest
PLATFORMS ?= linux/amd64,linux/arm64
REGISTRY ?= # Optional: e.g., docker.io/username
HOST_OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')

# Toolchain Variables
TOOLS_DIR := ./hack/tools
TOOLS_BIN_DIR := $(abspath $(TOOLS_DIR)/bin)
ARCHS := amd64 arm64
GOLANGCI_LINT    := $(abspath $(TOOLS_BIN_DIR)/golangci-lint)

# Derived variables
FULL_IMAGE_NAME := $(REGISTRY)$(IMAGE_NAME)
BUILD_FILE := ci/Containerfile
BUILD_CONTEXT := .

.PHONY: all build build-local push help clean tools

all: build tools

help: ## Show this help message
	@grep -E '^[a-zA-MS]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

tools: ## Build all tools for all supported architectures
	@for arch in $(ARCHS); do \
		for os in linux $(HOST_OS); do \
			echo "Building golangci-lint for $$os/$$arch..."; \
			mkdir -p $(TOOLS_BIN_DIR)/$$os/$$arch; \
			if [ -d "$(TOOLS_DIR)" ]; then \
				GOOS=$$os GOARCH=$$arch go -C $(TOOLS_DIR) build -tags=tools -o $(TOOLS_BIN_DIR)/$$os/$$arch/golangci-lint github.com/golangci/golangci-lint/v2/cmd/golangci-lint; \
			else \
				echo "Error: $(TOOLS_DIR) directory not found. Please ensure it exists and contains go.mod."; \
				exit 1; \
			fi; \
		done; \
	done

build: ## Build multi-arch image using buildx (requires buildx setup)
	@echo "Building multi-arch image: $(FULL_IMAGE_NAME) for platforms $(PLATFORMS)"
	docker buildx build --platform $(PLATFORMS) -f $(BUILD_FILE) $(BUILD_CONTEXT) -t $(FULL_IMAGE_NAME):$(TAG) -t $(FULL_IMAGE_NAME):$(TAG)-multiarch --load

build-local: ## Build single-arch image for local testing (amd64)
	@echo "Building local image: $(FULL_IMAGE_NAME) for amd64"
	docker build -f $(BUILD_FILE) $(BUILD_CONTEXT) -t $(FULL_IMAGE_NAME):local

push: ## Push the multi-arch image to registry
	@echo "Pushing $(FULL_IMAGE_NAME):$(TAG) to $(REGISTRY)"
	docker buildx build --platform $(PLATFORMS) -f $(BUILD_FILE) $(BUILD_CONTEXT) -t $(FULL_IMAGE_NAME):$(TAG) --push

# 	docker run --rm -v "$(pwd)":/app -w /app quay.io/cdoan0/ci:latest ./ci/lint.sh

AARCH := $(shell uname -m)

ifeq ($(AARCH),x86_64)
    ENV_ARCH = amd64
else ifneq ($(filter aarch64 arm64,$(AARCH)),)
    ENV_ARCH = arm64
else
    ENV_ARCH = unknown
endif

lint:
	./hack/tools/bin/$(HOST_OS)/$(ENV_ARCH)/golangci-lint run --config ./.golangci.yml --timeout 5m ./...

ci-lint:
	docker run --rm -v "$(CURDIR)":/app -w /app localhost/ollama-git-skill:latest ./ci/lint.sh

