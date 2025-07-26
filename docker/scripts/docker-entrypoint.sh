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
		frizzante --configure --platform "Linux/amd64"
		echo "Dependencies installed successfully!"

    # Wait for database
    # TODO: Advice to stop project and run docker-compose up --build --wait for database
fi
