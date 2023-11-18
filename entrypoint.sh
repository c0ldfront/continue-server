#!/bin/bash
set -e

# Check if health check is disabled
if [ "$DISABLE_HEALTH_CHECK" = "true" ]; then
    # Disable Docker health check by setting to 'none'
    export NO_HEALTHCHECK="NONE"
else
    # Enable Docker health check (default behavior)
    export NO_HEALTHCHECK=""
fi

# Execute the CMD
exec "$@"
