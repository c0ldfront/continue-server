ARG BASE_IMAGE=python:3.10-slim
ARG COMMIT_SHA=""
ARG COMMIT_BRANCH=""
ARG BUILD_VERSION=""
ARG BUILD_CREATED=""

# Use a base image with Python
FROM ${BASE_IMAGE}

# Set labels for the image with commit SHA and version
LABEL org.opencontainers.image.revision=${COMMIT_SHA}
# LABEL org.opencontainers.image.version=${BUILD_VERSION}

ARG PUID="1000"
ARG GUID="1000"

# Build information
ENV COMMIT_SHA=${COMMIT_SHA}
ENV COMMIT_BRANCH=${COMMIT_BRANCH}
# ENV BUILD_VERSION=${BUILD_VERSION}
# ENV BUILD_CREATED=${BUILD_CREATED}

# Environment settings
ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=off \
    PYTHONUNBUFFERED=1

# User information and environment variables
ENV CONTINUE_PORT=65432 \
    CONTINUE_HOST="127.0.0.1" \
    MEILISEARCH_URL="" \
    DISABLE_MEILISEARCH=false \
    CONFIG_PATH="" \
    HEADLESS_MODE=false \
    DISABLE_HEALTH_CHECK=false

# Install required packages (including curl for health check) and clean up in one layer to reduce image size
RUN apt-get update && \
    apt-get install -y git curl tini && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a new user and group with UID and GID of default 1000
RUN groupadd -g $GUID continue && \
    useradd -m -u $PUID -g $GUID continue

# Set the working directory
WORKDIR /app

# Change ownership of the /app directory and switch to non-root user
RUN chown -R continue:$GUID /app

USER $PUID

# Install continuedev package with optional PIP index and trusted hosts
ARG PIP_INDEX_URL=""
ARG PIP_TRUSTED_HOSTS=""
RUN if [ -z "$PIP_INDEX_URL" ]; then \
    pip install --user continuedev; \
    else \
    pip install --index-url $PIP_INDEX_URL --trusted-host $PIP_TRUSTED_HOSTS --user continuedev; \
    fi

# Add a startup script
COPY --chown=continue:$GUID start-continuedev.sh /app/start-continuedev.sh
RUN chmod +x /app/start-continuedev.sh

# Add the entry-point script
COPY --chmod=0755 entrypoint.sh /entrypoint.sh

# Expose the application port
EXPOSE 65432

# Health check: Replace '/health' with the appropriate path or endpoint you have for health checks
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD if [ "$NO_HEALTHCHECK" = "NONE" ]; then exit 0; else curl -f http://localhost:$CONTINUE_PORT/health || exit 1; fi

# Set tini as the entry-point
ENTRYPOINT ["/usr/bin/tini", "--"]

# Command to run the server using the startup script
CMD ["/app/start-continuedev.sh"]
