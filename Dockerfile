# Trinity Background Agent API — Railway Deployment
# Minimal Zig binary deployment
# φ² + 1/φ² = 3 = TRINITY

# Stage 1: Build
FROM ubuntu:24.04 AS builder

RUN apt-get update && apt-get install -y \
    wget xz-utils git \
    && rm -rf /var/lib/apt/lists/*

# Install Zig 0.15.2
RUN wget -q -O /tmp/zig.tar.xz \
    https://ziglang.org/download/0.15.2/zig-x86_64-linux-0.15.2.tar.xz \
    && tar -xf /tmp/zig.tar.xz -C /usr/local \
    && rm /tmp/zig.tar.xz

ENV PATH="/usr/local/zig-x86_64-linux-0.15.2:${PATH}"

WORKDIR /app

# Copy all source files
COPY . ./

# Build background-agent-api
RUN zig build background-agent-api

# Copy binary to artifacts directory
RUN mkdir -p /artifacts && find /app/.zig-cache -name "background-agent-api" -type f -exec cp {} /artifacts/background-agent-api \; \
    && chmod +x /artifacts/background-agent-api

# Stage 2: Runtime
FROM ubuntu:24.04

# Install curl for healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create user with home directory
RUN useradd -m -u 1001 trinity

# Create app directory owned by trinity user
RUN mkdir -p /app && chown trinity:trinity /app

# Copy binary and set permissions
COPY --from=builder --chown=trinity:trinity /artifacts/background-agent-api /app/background-agent-api
RUN chmod +x /app/background-agent-api

USER trinity
WORKDIR /app

EXPOSE 3000
ENV PORT=3000

# Health check: use curl to test /health endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Use shell wrapper to capture both stdout and stderr
CMD ["/app/background-agent-api"]
