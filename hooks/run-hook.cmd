#!/usr/bin/env bash
# Cross-platform hook runner
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
exec bash "$SCRIPT_DIR/$1"
