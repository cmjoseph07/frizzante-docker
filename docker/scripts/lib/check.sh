#!/bin/sh
set -e

# Check if this is a valid Go project before attempting to build
if [ ! -f go.mod ]; then
    echo "ERROR: No go.mod found in /app directory."
    echo "Cannot build production binary without a valid Go project."
    echo ""
    echo "To create a production build:"
    echo "1. Ensure your Go project with go.mod is in the mounted volume"
    echo "2. Run: docker compose run --rm frizzante frizzante --build"
    echo ""
    echo "To create a new Frizzante project:"
    echo "Run: docker compose run --rm frizzante frizzante -c ."
    exit 1
fi

# Install dependencies using shared script
. lib/install

# Build the production binary
exec frizzante --build