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

echo "Building Go binary for $TARGETARCH..."
cd core
CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH go build -ldflags="-s -w" -o billionmail-$TARGETARCH main.go

if [ $? -ne 0 ]; then
    echo "Failed to build Go binary"
    exit 1
fi

echo "Go binary built successfully: core/billionmail-$TARGETARCH"
cd ..
