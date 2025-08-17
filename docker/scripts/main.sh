#!/bin/sh
set -e

# Check if we need to initialize a Frizzante project first
if [ ! -f go.mod ]; then
		echo "No Frizzante project found. Creating a new one..."
		rm -rf tmp/

		# Create a new Frizzante project
		frizzante -y -c tmp

		# Move the created project files to the root
		if [ -d "tmp" ]; then
			cd tmp
			find . -mindepth 1 -maxdepth 1 ! -name "README.md" -exec cp -Rp {} .. \;
			cd ..
			rm -rf tmp/
		fi

		echo "Frizzante project created successfully!"

		# Set permissions excluding .git directory
		find . -path ./.git -prune -o -type f -exec chmod 0644 {} \;
		find . -path ./.git -prune -o -type d -exec chmod 0755 {} \;
fi

# Configure project.
test -d .gen/air || frizzante -y --configure
test -d .gen/bun || frizzante -y --configure

exec "$@"
