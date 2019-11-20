#!/usr/bin/env bash

set -e

COMMAND="$@"

/lando-entrypoint.sh tools/entrypoint.sh "$COMMAND"
