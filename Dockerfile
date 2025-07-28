FROM golang:1.24.5-bookworm AS frizzante_upstream

# Base Frizzante image
FROM frizzante_upstream AS frizzante_base

WORKDIR /app

# Install build-essential
RUN apt-get update && apt-get install -y build-essential

# Disable VCS
RUN go env -w GOFLAGS="-buildvcs=false"

# Install frizzante
RUN go install github.com/razshare/frizzante@latest

# Copy configuration files
COPY --link --chmod=755 docker/scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]

# Dev frizzante image
FROM frizzante_base AS frizzante_dev

# Development command - entrypoint will handle initialization
CMD ["make", "dev"]

# Build stage for production
FROM frizzante_base AS frizzante_build

# Create non-root user for production
RUN useradd -u 1001 nonroot

# Copy all source files
COPY . .

# Build the production binary using frizzante
RUN frizzante --build

# Production image using scratch
FROM scratch AS frizzante_prod

WORKDIR /

# Copy the binary
COPY --from=frizzante_build /app/.gen/bin/app /frizzante

# Use non-root user
USER nonroot

# Expose port
EXPOSE 8080

# Run the binary
CMD ["/frizzante"]
