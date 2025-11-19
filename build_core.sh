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

echo "Checking for pre-built binary for $TARGETARCH..."

# Check if binary already exists (from git clone)
if [ -f "core/billionmail-$TARGETARCH" ]; then
    echo "Binary already exists: core/billionmail-$TARGETARCH"
    chmod +x core/billionmail-$TARGETARCH
    exit 0
fi

# Try to download from GitHub releases or artifacts
echo "Downloading pre-built binary..."
REPO_OWNER="enzorobot07"
REPO_NAME="BillionMail"
BINARY_URL="https://github.com/$REPO_OWNER/$REPO_NAME/releases/latest/download/billionmail-$TARGETARCH"

# Download binary
cd core
if wget -q "$BINARY_URL" -O "billionmail-$TARGETARCH"; then
    chmod +x "billionmail-$TARGETARCH"
    echo "Downloaded pre-built binary successfully"
    cd ..
    exit 0
fi

# If download fails, check if Go is available to build locally
cd ..
if command -v go &> /dev/null; then
    echo "Building Go binary locally for $TARGETARCH..."
    cd core
    CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH go build -o billionmail-$TARGETARCH
    if [ $? -ne 0 ]; then
        echo "Failed to build Go binary"
        exit 1
    fi
    echo "Go binary built successfully: core/billionmail-$TARGETARCH"
    cd ..
    exit 0
fi

echo "Error: Pre-built binary not available and Go is not installed"
echo "Please either:"
echo "1. Wait for GitHub Actions to build the binary (check repository Actions tab)"
echo "2. Install Go: wget https://go.dev/dl/go1.21.5.linux-$TARGETARCH.tar.gz && sudo tar -C /usr/local -xzf go1.21.5.linux-$TARGETARCH.tar.gz"
exit 1
