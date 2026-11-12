# Runbook: local tooling

Local tools live in `~/.local/bin`, with no sudo and no Homebrew (Homebrew is blocked by the old Command Line Tools on this Mac). Every download is an official release, pinned to a version.

| Tool | Version | Source | Check | Installed |
|---|---|---|---|---|
| Terraform | 1.17.2 | releases.hashicorp.com | SHA256 + Apple notarization | 2026-11-11 |
| gitleaks | 8.30.1 | GitHub release `gitleaks/gitleaks` | SHA256 from the release checksums file | 2026-11-12 |
| pre-commit | 4.7.0 | PyPI, in the venv `~/.local/share/pre-commit-venv`, linked into `~/.local/bin` | pip over HTTPS | 2026-11-12 |
| corepack | 0.36.0 | npm registry, global under nvm Node 22 (`npm i -g corepack@0.36.0`) | npm registry integrity | 2026-11-12 |
| pnpm | 12.18.0 | corepack, from `packageManager` in `package.json`; shims in `~/.local/bin` | SHA-512 in `packageManager` + npm registry signature of the native binary | 2026-11-12 |

Add `~/.local/bin` to PATH in `~/.zprofile`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Scripts and hooks do not rely on it: `scripts/tf.sh` falls back to `~/.local/bin/terraform`, and the local hooks run through [`scripts/with-local-bin.sh`](../../scripts/with-local-bin.sh).

## Git hooks

[`.pre-commit-config.yaml`](../../.pre-commit-config.yaml) runs on every commit:

- `gitleaks git --pre-commit --staged`: same version as CI (`GITLEAKS_VERSION` in `ci.yml`).
- `terraform fmt -check` on `infra/` when a `.tf` file changes.
- `pre-commit/pre-commit-hooks`, pinned to a commit SHA: private keys, files over 512 KB, merge markers, YAML/JSON syntax, shebangs, line endings, trailing whitespace.

Install once per clone:

```bash
pre-commit install
pre-commit run --all-files
```

Checked on 2026-11-12: all hooks pass on the repo, and a staged fake GitHub token and private key header are both blocked.

The hooks are a fast local net, not the gate: CI runs gitleaks on the full history and branch protection requires it. Do not skip them with `--no-verify`.

## pnpm

The version lives in one place: `packageManager` in the root `package.json`, with its SHA-512. Corepack downloads exactly that version on the Mac and on CI. Corepack 0.34 (bundled with Node 22) cannot run pnpm 11 or later, hence 0.36.0.

[`pnpm-workspace.yaml`](../../pnpm-workspace.yaml) sets:

- `minimumReleaseAge: 10080`: pnpm installs only versions published at least 7 days ago, the same cooldown as Dependabot. A compromised release is usually caught within days.
- `strictDepBuilds: true`: no dependency runs install scripts unless listed.

## Updates

- gitleaks: bump the local binary and `GITLEAKS_VERSION` in `ci.yml` in the same PR.
- pre-commit hooks: `pre-commit autoupdate --freeze` writes the new commit SHA; check the upstream changelog before merging.
- pnpm: `corepack use pnpm@<version>` rewrites `packageManager` with the new hash; commit it with the lockfile.
- Terraform: download the new release, check SHA256 and notarization, then bump `required_version` if needed.
