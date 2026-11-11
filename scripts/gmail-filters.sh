#!/usr/bin/env bash
# Render config/gmail/filters.xml.tmpl with the Gmail address from the Keychain.
# Usage: scripts/gmail-filters.sh <output.xml>   (write it outside the repo)
set -euo pipefail
repo="$(cd "$(dirname "$0")/.." && pwd)"
out="${1:?usage: $0 <output.xml>}"
case "$(cd "$(dirname "$out")" && pwd)/" in "$repo"/*) echo "write the rendered file outside the repo" >&2; exit 1;; esac
addr="$(security find-generic-password -a "$USER" -s eduardiacob-dev/gmail-address -w)"
[[ "$addr" =~ ^([a-z0-9.]+)@gmail\.com$ ]] || { echo "unexpected gmail-address format in Keychain" >&2; exit 1; }
sed "s/{{GMAIL_USER}}/${BASH_REMATCH[1]}/g" "$repo/config/gmail/filters.xml.tmpl" > "$out"
echo "Rendered $(grep -c '<entry>' "$out") filters to $out"
