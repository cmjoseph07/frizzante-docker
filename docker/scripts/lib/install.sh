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

# Install dependencies if not already done
which .gen/bun/bun || frizzante --add="bun" --platform="$PLATFORM" -y
which .gen/air/air || frizzante --add="air" --platform="$PLATFORM" -y
test -d app/node_modules || frizzante --install