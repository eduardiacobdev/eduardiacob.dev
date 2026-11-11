# Runbook: local secrets and the Terraform state backend

Secrets for local work live in the macOS login Keychain, never in files or shell history. In CI the same values are GitHub secrets. Nothing here is committed.

## Keychain items

All items use service name `eduardiacob-dev/<name>` and account `$USER`.

| Name | What | Scope | Created | Expires |
|---|---|---|---|---|
| `r2-access-key-id` | R2 account API token `terraform-state-eduardiacob-dev`, access key | Object Read & Write on bucket `eduardiacob-dev-tfstate` only | 2026-11-11 | 2027-11-11 |
| `r2-secret-access-key` | Same token, secret key | same | 2026-11-11 | 2027-11-11 |
| `cloudflare-api-token` | Cloudflare account API token `terraform-eduardiacob-dev` | see below | 2026-11-11 | 2027-11-11 |
| `gmail-address` | Owner's Gmail address, destination of the Email Routing aliases (ADR-0007). Not a credential, kept out of the public repo | — | 2026-11-11 | — |

Cloudflare token permissions (least privilege for the `dns-email` and Turnstile work):

- Account: Email Routing Addresses Edit, Turnstile Sites Edit.
- Zone `eduardiacob.dev` only: DNS Edit, Zone DNS Settings Edit (DNSSEC), Zone Settings Edit, Zone Read, Email Routing Rules Edit.
- No R2, Workers, billing or member permissions. No IP filter (CI runners have no fixed IP).

## Store or rotate a secret

```bash
scripts/keychain-set.sh <name>
```

The value is pasted at a hidden prompt: it never appears in argv, history or a file. Running it again overwrites the item.

Check that an item exists without printing it:

```bash
v=$(security find-generic-password -a "$USER" -s "eduardiacob-dev/<name>" -w) && echo "length=${#v}"; unset v
```

## State backend on R2

- Bucket `eduardiacob-dev-tfstate`, EU jurisdiction, Standard class, private (no public or `r2.dev` access).
- S3 endpoint: `https://d41719423d64b5b6fea8a1223e4e2ec8.eu.r2.cloudflarestorage.com`.
- Local credentials come from an AWS profile that calls [`scripts/r2-credential-process.sh`](../../scripts/r2-credential-process.sh):

```ini
# ~/.aws/config
[profile r2]
credential_process = /absolute/path/to/repo/scripts/r2-credential-process.sh
region = auto
```

Verified on 2026-11-11: `s3api list-objects-v2` on the bucket succeeds, `s3api list-buckets` is denied (the key is bucket-scoped).

R2 has no spending cap. The bucket stays far below the free quota (10 GB, 1M Class A, 10M Class B per month); a Cloudflare billing notification is the alarm.

## Running Terraform locally

- Terraform is the official HashiCorp binary in `~/.local/bin/terraform` (SHA256 and Apple notarization checked). Add `export PATH="$HOME/.local/bin:$PATH"` to `~/.zprofile`; [`scripts/tf.sh`](../../scripts/tf.sh) falls back to that path anyway.
- Always go through the wrapper: `scripts/tf.sh init`, `scripts/tf.sh plan -out=x.tfplan`, `scripts/tf.sh apply x.tfplan`. It exports `CLOUDFLARE_API_TOKEN` and `TF_VAR_gmail_address` from the Keychain into the Terraform process only, and passes `profile=r2` to `init`.
- Bootstrap exception: the first Email Routing apply (2026-11-11) ran locally because the repo was not on GitHub yet. From the first push on, infra changes go through a PR with the plan attached.

## Rotation

Both tokens expire on 2027-11-11. Rotate in October 2027 (TASKS T1.11): create the new token in the dashboard, store it with `scripts/keychain-set.sh`, update the GitHub secrets, run `terraform plan`, then delete the old token.

If a secret leaks: revoke it in the Cloudflare dashboard first, then rotate.
