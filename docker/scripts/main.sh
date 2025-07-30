#!/bin/sh
set -e

# Check if we need to initialize a Frizzante project first
if [ ! -f go.mod ]; then
		echo "No Frizzante project found. Creating a new one..."
		rm -rf tmp/

		# Create a new Frizzante project
		FRIZZANTE_USING_DOCKER=1 frizzante -c tmp

		# Move the created project files to the root
		if [ -d "tmp" ]; then
			cd tmp
			cp -Rp . ..
			cd ..
			rm -rf tmp/
		fi

		echo "Frizzante project created successfully!"

		chmod -R 0755 .
fi

# Install dependencies using shared script
. /usr/local/bin/lib/install

# Touch app/dist
FRIZZANTE_USING_DOCKER=1 frizzante --touch

exec "$@"
