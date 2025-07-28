#!/bin/sh
set -e

# Check if Delve should be installed
if [ "$DELVE_ENABLED" = "true" ]; then
    # Check if Delve is already installed
    if ! command -v dlv >/dev/null 2>&1; then
        echo "Installing Delve debugger..."
        go install github.com/go-delve/delve/cmd/dlv@latest
        echo "Delve installed successfully!"
    fi
fi

# Check if we need to initialize a Frizzante project first
if [ ! -f go.mod ]; then

		echo "No Frizzante project found. Creating a new one..."
		rm -rf tmp/
		
		# Create a new Frizzante project
		frizzante -c tmp
		
		# Move the created project files to the root
		if [ -d "tmp" ]; then
			cd tmp
			cp -Rp . ..
			cd ..
			rm -rf tmp/
		fi
		
		echo "Frizzante project created successfully!"
		
		# Install dependencies using shared script
		. /usr/local/bin/install-deps

    # Wait for database
    # TODO: Advice to stop project and run docker-compose up --build --wait for database
fi

# If Delve is enabled and the command is to run the dev server, we need to modify execution
if [ "$DELVE_ENABLED" = "true" ] && [ "$1" = "make" ] && [ "$2" = "dev" ]; then
    echo "Starting with Delve debugger on port ${DELVE_PORT:-2345}..."
    # Run frizzante through delve with --continue flag to start execution immediately
    exec dlv exec $(which frizzante) --headless --listen=:${DELVE_PORT:-2345} --api-version=2 --accept-multiclient --continue -- --dev
else
    # Execute the command passed to the container normally
    exec "$@"
fi
