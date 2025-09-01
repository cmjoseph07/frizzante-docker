# syntax=docker/dockerfile:1
FROM golang:1.25.0-bookworm AS frizzante_upstream

# Base Frizzante image
FROM frizzante_upstream AS frizzante_base

WORKDIR /frizzante

# Install build-essential with cache mount
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

# Disable VCS
RUN go env -w GOFLAGS="-buildvcs=false"

# Install frizzante with Go module cache
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go run github.com/razshare/frizzante/setup/install@latest

# Copy configuration files
COPY --link --chmod=755 docker/scripts/main.sh /usr/local/bin/main
COPY --link --chmod=755 docker/scripts/start.sh /usr/local/bin/start
COPY --link --chmod=755 docker/scripts/build.sh /usr/local/bin/build

ENTRYPOINT ["main"]

# Start frizzante image
FROM frizzante_base AS frizzante_start

# Start command - entrypoint will handle initialization
CMD ["start"]

# Build stage for production
FROM frizzante_base AS frizzante_build

# Create non-root user for production
RUN useradd -u 1001 nonroot

# Copy dependency files first for better caching
COPY --link go.* ./

# Download dependencies if go.mod exists
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    if [ -f go.mod ]; then go mod download; fi

# Copy all source files
COPY --link . .

# Build the production binary with cache mounts
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=//frizzante/.gen/cache \
    /usr/local/bin/build

# Production image using distroless with C++ libraries
FROM gcr.io/distroless/cc-debian12:latest AS frizzante_prod

WORKDIR /frizzante

# Copy passwd file to enable nonroot user
COPY --from=frizzante_build /etc/passwd /etc/passwd

# Create .gen directory with proper permissions for nonroot user
COPY --from=frizzante_build --chown=nonroot:nonroot /frizzante/.gen /frizzante/.gen

# Copy the binary
COPY --from=frizzante_build /frizzante/.gen/bin/app /frizzante/server

# Use non-root user
USER nonroot

# Expose port
EXPOSE 8080

# Run the binary
CMD ["/app/server"]
