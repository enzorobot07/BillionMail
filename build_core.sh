#!/bin/bash

# Determine architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    TARGETARCH="amd64"
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    TARGETARCH="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

export TARGETARCH

echo "Building Go binary locally for $TARGETARCH..."

# Check if Go is available to build locally
if command -v go &> /dev/null; then
    cd core
    CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH go build -tags exclude_dev -o billionmail-$TARGETARCH
    if [ $? -ne 0 ]; then
        echo "Failed to build Go binary"
        exit 1
    fi
    echo "Go binary built successfully: core/billionmail-$TARGETARCH"
    cd ..
    exit 0
fi

echo "Error: Go is not installed"
echo "Please either:"
echo "1. Wait for GitHub Actions to build the binary (check repository Actions tab)"
echo "2. Install Go: wget https://go.dev/dl/go1.21.5.linux-$TARGETARCH.tar.gz && sudo tar -C /usr/local -xzf go1.21.5.linux-$TARGETARCH.tar.gz"
exit 1
