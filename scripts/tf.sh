#!/usr/bin/env bash
# Run Terraform for infra/envs/prod with secrets read from the macOS Keychain.
# Secrets exist only in this process's environment, never on disk.
#
# Usage: scripts/tf.sh init | plan | apply | ...
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
tf="$(command -v terraform || echo "$HOME/.local/bin/terraform")"
[[ -x "$tf" ]] || { echo "terraform not found" >&2; exit 1; }

get() { security find-generic-password -a "$USER" -s "eduardiacob-dev/$1" -w; }

CLOUDFLARE_API_TOKEN="$(get cloudflare-api-token)"
TF_VAR_gmail_address="$(get gmail-address)"
export CLOUDFLARE_API_TOKEN TF_VAR_gmail_address

cmd="${1:?usage: $0 <terraform command> [args]}"
shift
if [[ "$cmd" == "init" ]]; then
  # Local state credentials: the `r2` profile in ~/.aws/config (see docs/runbooks/local-secrets.md).
  set -- -backend-config="profile=r2" "$@"
fi

exec "$tf" -chdir="$repo/infra/envs/prod" "$cmd" "$@"
