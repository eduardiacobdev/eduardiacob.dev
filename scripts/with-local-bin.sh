#!/usr/bin/env bash
# Run a command with ~/.local/bin first on PATH. Local tools (terraform,
# gitleaks, pre-commit) live there because Homebrew is not available, and
# git hooks run with whatever PATH the calling app has.
#
# Usage: scripts/with-local-bin.sh <command> [args]
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"
exec "$@"
