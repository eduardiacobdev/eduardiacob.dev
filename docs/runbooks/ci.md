# Runbook: CI and repository settings

The repo `eduardiacobdev/eduardiacob.dev` is public (architecture review A3). Every pull request and every push to `main` runs the checks below (TASKS T2.5).

## Workflows

| File | Job | What it does |
|---|---|---|
| `.github/workflows/ci.yml` | `secrets (gitleaks)` | Scans the full history for secrets |
| | `terraform (fmt, validate, tflint)` | `fmt -check`, `init -backend=false`, `validate`, tflint with the recommended preset (`.tflint.hcl`) |
| | `policy (checkov)` | Policy checks on Terraform and on the workflows (review A7) |
| | `scripts (shellcheck)` | Lints `scripts/*.sh` |
| | `web (lint, typecheck, test, build)` | `apps/web`: pnpm through corepack, `install --frozen-lockfile`, ESLint, `tsc`, Vitest, `next build` (static export) |
| | `terraform plan (prod)` | PRs only: plans against the R2 state and posts the plan as a PR comment (review A5) |
| `.github/workflows/codeql.yml` | `codeql (actions)`, `codeql (javascript-typescript)` | CodeQL `security-extended` on the workflows and on `apps/web`, weekly and on every change. Add `php` when `apps/api` exists |
| `.github/dependabot.yml` | — | Weekly grouped updates for Actions, Terraform providers and npm (pnpm workspace), 7-day cooldown |

Rules for workflows:

- `permissions: {}` at the top, then the least each job needs.
- Every third-party action is pinned to a full commit SHA with the version in a comment. Dependabot keeps them current.
- `persist-credentials: false` on checkout. No `${{ }}` of PR data inside `run:`: pass it through `env:`.
- Secrets sit only on the steps that need them, never at job or workflow level.

## Plan on a public repo

The PR comment and the job log are public. Protections:

- `gmail_address` is a `sensitive` variable, so Terraform masks it and every value derived from it.
- The job also registers the Gmail local part with `::add-mask::` and redacts any `…@gmail.com` before printing or commenting.
- The binary plan file (`tfplan`) holds real values: it is deleted in the same step and never uploaded.
- The job runs only for PRs from this repo. Forks and Dependabot get no secrets; the job is skipped for them.
- Concurrency group `tfstate-prod` serializes plans; the R2 lockfile protects the state.

Apply is not in CI yet: changes are applied locally with `scripts/tf.sh` after the PR is merged, until `deploy.yml` with the `prod` environment and a required reviewer (review A4).

## Secrets

| GitHub secret | Keychain item | Used by |
|---|---|---|
| `R2_ACCESS_KEY_ID` | `r2-access-key-id` | `plan`: state on R2 |
| `R2_SECRET_ACCESS_KEY` | `r2-secret-access-key` | `plan`: state on R2 |
| `CLOUDFLARE_API_TOKEN` | `cloudflare-api-token` | `plan`: Cloudflare provider |
| `TF_VAR_GMAIL_ADDRESS` | `gmail-address` | `plan`: Email Routing destinations |

Set or rotate them by hand from the Mac (the owner runs it; values never appear on screen):

```bash
scripts/gh-secrets-sync.sh
```

The rotation steps in [`local-secrets.md`](local-secrets.md) end with this script.

## Repository settings

Set with `gh api`, recorded here because GitHub has no settings file:

| Setting | Value |
|---|---|
| Visibility | Public |
| Secret scanning, push protection | On |
| Dependabot alerts, security updates | On |
| Private vulnerability reporting | On |
| Merge | Squash only, delete branch on merge |
| Wiki, Projects | Off |
| Ruleset `protect-main` | Default branch: no deletion, no force push, linear history, PR required (0 approvals, threads resolved, squash only), required checks: `secrets (gitleaks)`, `terraform (fmt, validate, tflint)`, `policy (checkov)`, `scripts (shellcheck)`, `terraform plan (prod)`, `codeql (actions)`. No bypass actors |
| Actions: default `GITHUB_TOKEN` | Read only, cannot approve PRs |
| Actions: allowed actions | GitHub-owned, verified creators and the listed ones, full SHA pinning required |
| Actions: fork PRs | Approval required for every outside contributor |
