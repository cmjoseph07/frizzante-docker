#!/bin/sh
set -e

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
		
		# Set platform string
		PLATFORM="${OS}/${ARCH}"
		
		echo "Detected platform: $PLATFORM"
		frizzante --configure --platform="$PLATFORM"
		echo "Dependencies installed successfully!"

    # Wait for database
    # TODO: Advice to stop project and run docker-compose up --build --wait for database
fi

# Execute the command passed to the container
exec "$@"
