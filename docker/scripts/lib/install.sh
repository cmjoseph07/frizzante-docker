#!/bin/sh
set -e

# Shared function to install frizzante dependencies
# This is used by both entrypoint and build scripts

# Detect platform
OS=$(uname -s)
ARCH=$(uname -m)

# Map architecture names
case "$ARCH" in
    x86_64)
        ARCH="amd64"
        ;;
    aarch64|arm64)
        ARCH="arm64"
        ;;
esac

PLATFORM="${OS}/${ARCH}"

echo "Detected platform: $PLATFORM"

# Configure project and install dependencies.
FRIZZANTE_USING_DOCKER=1 frizzante --configure --platform="$PLATFORM" -y