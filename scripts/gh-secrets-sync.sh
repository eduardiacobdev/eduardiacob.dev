#!/usr/bin/env bash
# Copy the CI secrets from the macOS Keychain to the GitHub repo secrets.
# Values go from Keychain to `gh` through a pipe: never in argv, output,
# shell history or a file. Run it by hand after creating or rotating a secret.
#
# Usage: scripts/gh-secrets-sync.sh
set -euo pipefail

repo="eduardiacobdev/eduardiacob.dev"

get() { security find-generic-password -a "$USER" -s "eduardiacob-dev/$1" -w; }

# GitHub secret name <- Keychain item name
pairs=(
  "R2_ACCESS_KEY_ID:r2-access-key-id"
  "R2_SECRET_ACCESS_KEY:r2-secret-access-key"
  "CLOUDFLARE_API_TOKEN:cloudflare-api-token"
  "TF_VAR_GMAIL_ADDRESS:gmail-address"
)

for pair in "${pairs[@]}"; do
  name="${pair%%:*}"
  item="${pair#*:}"
  get "$item" | tr -d '\n' | gh secret set "$name" --repo "$repo" --app actions
done

gh secret list --repo "$repo" --app actions
