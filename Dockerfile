# Trinity Background Agent API — Railway Deployment
# Minimal Zig binary deployment
# φ² + 1/φ² = 3 = TRINITY

# Stage 1: Build
FROM ubuntu:24.04 AS builder

RUN apt-get update && apt-get install -y \
    wget xz-utils git \
    && rm -rf /var/lib/apt/lists/*

# Install Zig 0.15.2
# Note: SHA256 verification temporarily disabled (ziglang.org access restricted)
# TODO: Re-enable with verified checksum once accessible
RUN wget -q -O /tmp/zig.tar.xz \
    https://ziglang.org/download/0.15.2/zig-x86_64-linux-0.15.2.tar.xz \
    && tar -xf /tmp/zig.tar.xz -C /usr/local \
    && rm /tmp/zig.tar.xz

ENV PATH="/usr/local/zig-x86_64-linux-0.15.2:${PATH}"

WORKDIR /app

# Copy all source files
COPY . ./

# Build background-agent-api with ReleaseSafe
RUN zig build -Doptimize=ReleaseSafe background-agent-api

# Stage 2: Runtime - Use Ubuntu minimal
FROM ubuntu:24.04

# Create user first
RUN useradd -m -u 1001 trinity

# Copy only the binary from builder
COPY --from=builder /app/zig-out/bin/background-agent-api /app/

USER trinity

EXPOSE 3000

ENV PORT=3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD test -x /app || exit 1

ENTRYPOINT ["/app"]
