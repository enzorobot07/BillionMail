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

# GitHub repository info
REPO="enzorobot07/BillionMail"
BINARY_NAME="billionmail-$TARGETARCH"
DOWNLOAD_URL="https://github.com/$REPO/releases/latest/download/$BINARY_NAME"

echo "Attempting to download pre-built binary for $TARGETARCH..."

# Try to download pre-built binary
if command -v curl &> /dev/null; then
    mkdir -p core
    if curl -L -f -o "core/$BINARY_NAME" "$DOWNLOAD_URL" 2>/dev/null; then
        chmod +x "core/$BINARY_NAME"
        echo "Successfully downloaded pre-built binary: core/$BINARY_NAME"
        exit 0
    else
        echo "Failed to download pre-built binary from GitHub releases"
    fi
elif command -v wget &> /dev/null; then
    mkdir -p core
    if wget -O "core/$BINARY_NAME" "$DOWNLOAD_URL" 2>/dev/null; then
        chmod +x "core/$BINARY_NAME"
        echo "Successfully downloaded pre-built binary: core/$BINARY_NAME"
        exit 0
    else
        echo "Failed to download pre-built binary from GitHub releases"
    fi
else
    echo "Neither curl nor wget is available for downloading"
fi

echo "Falling back to local build..."

# Check if Go is available to build locally
if command -v go &> /dev/null; then
    cd core
    CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH go build -tags exclude_dev -o billionmail-$TARGETARCH main.go
    if [ $? -ne 0 ]; then
        echo "Failed to build Go binary"
        exit 1
    fi
    echo "Go binary built successfully: core/billionmail-$TARGETARCH"
    cd ..
    exit 0
fi

echo "Error: Unable to download or build the binary"
echo "Please ensure either:"
echo "1. curl or wget is installed to download pre-built binaries"
echo "2. Go 1.21+ is installed to build from source"
exit 1
