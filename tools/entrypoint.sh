#!/usr/bin/env bash

set -e

COMMAND="$@"

bash -l -c - "$COMMAND"
