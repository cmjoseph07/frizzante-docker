FROM golang:1.24.5-bookworm AS frizzante_upstream

# Base Frizzante image
FROM frizzante_upstream AS frizzante_base

WORKDIR /app

# Install build-essential and expect for automation
RUN apt-get update && apt-get install -y build-essential

# Install Go tools with explicit GOOS/GOARCH for linux/amd64
RUN go install github.com/razshare/frizzante@latest

# Copy configuration files
COPY --link --chmod=755 docker/scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]

# Dev Frizzante image
FROM frizzante_base AS frizzante_dev

# Development command - entrypoint will handle initialization
CMD ["make", "dev"]
