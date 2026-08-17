#!/bin/bash
# CI entrypoint for formatting and linting checks.

# set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

export GOCACHE=$(mktemp -d /tmp/gocache.XXXXXX)
export GOMODCACHE=$(mktemp -d /tmp/gomodcache.XXXXXX)
export GOLANGCI_LINT_CACHE=$(mktemp -d /tmp/golangci-lint-cache.XXXXXX)
export GOFLAGS=-mod=mod

# ARCH=$(uname -m)

# if [ "$ARCH" = "x86_64" ]; then
#     echo "Running on amd64"
# elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
#     echo "Running on arm64"
# else
#     echo "Unknown architecture: $ARCH"
# fi

# export GOLANGCI_LINT=/hack/tools/bin/$ARCH/golangci-lint

# echo "$GOLANGCI_LINT"

# make fmt-check
make lint
