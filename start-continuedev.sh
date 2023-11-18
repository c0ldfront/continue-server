#!/bin/bash

# Construct the command
cmd="python -m continuedev"

# Add options based on environment variables
[[ ! -z "$CONTINUE_PORT" ]] && cmd="$cmd --port $CONTINUE_PORT"
[[ ! -z "$CONTINUE_HOST" ]] && cmd="$cmd --host $CONTINUE_HOST"
[[ ! -z "$MEILISEARCH_URL" ]] && cmd="$cmd --meilisearch-url $MEILISEARCH_URL"
[[ "$DISABLE_MEILISEARCH" = true ]] && cmd="$cmd --disable-meilisearch"
[[ ! -z "$CONFIG_PATH" ]] && cmd="$cmd --config $CONFIG_PATH"
[[ "$HEADLESS_MODE" = true ]] && cmd="$cmd --headless"

# Execute the command
exec $cmd
