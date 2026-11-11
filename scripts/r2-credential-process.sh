#!/usr/bin/env bash
# AWS `credential_process` helper for the Terraform state bucket on Cloudflare R2.
# Reads the R2 key pair from the macOS login Keychain (stored with
# scripts/keychain-set.sh) and prints it in the format the AWS SDK expects.
# Nothing is written to disk. In CI the same values come from GitHub secrets.
#
# ~/.aws/config:
#   [profile r2]
#   credential_process = /absolute/path/to/scripts/r2-credential-process.sh
#   region = auto
set -euo pipefail

get() { security find-generic-password -a "$USER" -s "eduardiacob-dev/$1" -w; }

id="$(get r2-access-key-id)"
secret="$(get r2-secret-access-key)"

# R2 keys are hex strings, safe to embed in JSON without escaping.
[[ "$id" =~ ^[0-9a-f]+$ && "$secret" =~ ^[0-9a-f]+$ ]] || { echo "unexpected R2 key format in Keychain" >&2; exit 1; }

printf '{"Version":1,"AccessKeyId":"%s","SecretAccessKey":"%s"}\n' "$id" "$secret"
