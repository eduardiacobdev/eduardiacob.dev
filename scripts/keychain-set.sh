#!/usr/bin/env bash
# Store one secret in the macOS login Keychain.
# The value is typed at the `security` prompt: it is not echoed, not passed
# as a command-line argument and never written to a file.
#
# Usage: scripts/keychain-set.sh <name>
#   e.g. scripts/keychain-set.sh r2-access-key-id
# Read back: security find-generic-password -a "$USER" -s "eduardiacob-dev/<name>" -w
set -euo pipefail

name="${1:?usage: $0 <name>}"
[[ "$name" =~ ^[a-z0-9-]+$ ]] || { echo "name must be lowercase letters, digits, dashes" >&2; exit 1; }
service="eduardiacob-dev/${name}"

echo "Paste ${name} at the prompt, then again to confirm. Input is hidden."
security add-generic-password -U -a "$USER" -s "$service" -l "$service" -w
echo "Stored in Keychain as ${service}"
