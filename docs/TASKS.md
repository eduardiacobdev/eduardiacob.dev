# Task board

Owner: **E** = Eduard (needs a human: accounts, passwords, payments, MFA) · **C** = collaborator (builds, prepares and proposes; never holds secrets or pays).
Status: `todo` · `doing` · `blocked` · `done`.

Rule: every human step is prepared and pre-filled in advance; Eduard only types secrets, pays and confirms.

## Phase 0 — Foundations

| ID | Task | Owner | Status | Notes |
|---|---|---|---|---|
| T0.1 | Architecture review + ADRs 0001–0007 | C | done | `docs/reviews`, `docs/adr` |
| T0.2 | Brand brief: who you are, target, 2–3 reference sites | E | done | 2026-11-12: `docs/brand/brief.md`. Reputation-first personal site, immersive 3D, EN + IT, HTML-first for SEO/GEO and accessibility |
| T0.3 | Brand identity (name treatment, palette, type, voice) + 3D world concept | C | done | 2026-11-12: E chose concept B, Rilievo (topographic island), out of three. See `docs/brand/identity.md`. Light `signal` darkened to pass WCAG AA |
| T0.4 | Content inventory: 3–6 projects, short bio, experience without company names, links, photo yes/no, 2–3 technical decisions | E | done | 2026-11-12: `docs/brand/content.md`. Identity line and bio in `apps/web` dictionaries. Four projects: this site, GeminiPort (named) and two anonymous case studies |
| T0.5 | Case study details for the agents and GeminiPort (problem, options, choice, result) | E | done | Texts in `docs/brand/content.md`, EN and IT. The LMS stays an experience line; the database migration is dropped; no images |

## Phase 1 — Accounts (human)

| ID | Task | Owner | Status | Notes |
|---|---|---|---|---|
| T1.1 | GitHub: username `eduardiacobdev`, 2FA + passkey, email private | E | done | 2026-11-11: username, email privacy + push block, TOTP 2FA; recovery codes kept outside the repo |
| T1.2 | Create the public repo `eduardiacob.dev` and push | C | done | 2026-11-12: `eduardiacobdev/eduardiacob.dev` public, history reviewed and cleaned of personal details before the first push. Secret scanning + push protection, Dependabot alerts + security updates, private vulnerability reporting on. Ruleset `protect-main` (PR and checks required since T2.5). Squash merge only, wiki and projects off |
| T1.3 | Cloudflare account (personal Gmail, see recovery chain), 2FA on | E | done | 2026-11-11: TOTP 2FA active; security key optional |
| T1.4 | Buy `eduardiacob.dev` (Cloudflare Registrar), auto-renew + domain lock | E+C | done | 2026-11-11: registered until 2027-11-11, auto-renew on ($12.20/yr), transfer lock on, WHOIS redacted. DNSSEC left to Terraform (T3.2) |
| T1.5 | Enable R2 (requires a payment method on file, stays 0 $ in free quota) | E+C | done | 2026-11-11: R2 on, bucket `eduardiacob-dev-tfstate` in EU jurisdiction, bucket-scoped key in Keychain. See `docs/runbooks/local-secrets.md` |
| T1.6 | Cloudflare API token `terraform-eduardiacob-dev` (DNS, zone settings, Email Routing, Turnstile; one zone) | E+C | done | 2026-11-11: account token, expires 2027-11-11, in Keychain, verified via API. No R2 scope: state uses the bucket key |
| T1.7 | Domain mail: Cloudflare Email Routing, `hello@` `ops@` `aws@` → Gmail (ADR-0007) | E+C | done | 2026-11-11: MX/SPF/DKIM, 3 destinations, 3 forward rules and catch-all drop applied, no drift (MX change confirmed by E). Gmail labels and filters set up (`docs/runbooks/gmail-filters.md`). Delivery test from an external mailbox: all 3 aliases arrived in about 20 s with the right label, SPF/DKIM/DMARC/ARC pass, DKIM signed by `eduardiacob.dev` |
| T1.8 | AWS account, **advanced** sign-up, Free plan, root MFA | E | blocked | Wait for T2.x + Email Routing live (ADR-0006): saves free-plan months |
| T1.9 | IAM admin user with MFA (ADR-0002), `aws login` works | E+C | todo | C gives exact clicks; E sets password/MFA |
| T1.10 | Brevo free account, domain authenticated, Gmail "Send mail as `hello@`" | E+C | done | 2026-11-12: Brevo free, domain DNS via Terraform (brevo-code, DKIM CNAMEs, DMARC imported), sender `hello@` verified, SMTP key `gmail-send-as-hello` (expires about 2027-11-12) only in Brevo and Gmail. Test from `hello@` to an external mailbox: `dkim=pass header.d=eduardiacob.dev`, `dmarc=pass`, SPF pass on Brevo's bounce domain (not aligned, as expected). See `docs/runbooks/brevo-gmail-send-as.md`. Brevo API key into SSM moves to T3.7 |
| T1.11 | Rotate R2 key, Cloudflare token (expire 2027-11-11) and Brevo SMTP key (about 2027-11-12) | E+C | todo | Due October 2027, steps in `docs/runbooks/local-secrets.md` and `docs/runbooks/brevo-gmail-send-as.md` |
| T1.12 | Cloudflare billing notification (R2 has no spend cap) | E+C | done | 2026-11-12: Billing budget alert at 1 USD to `ops@`, made by hand (provider has no `billing_budget_alert` yet), see `docs/runbooks/cloudflare-billing-alert.md`. Cloudflare default alert at 10 USD kept |

## Phase 2 — Build (local first)

| ID | Task | Owner | Status | Notes |
|---|---|---|---|---|
| T2.1 | Tooling: Terraform/OpenTofu, pnpm, pre-commit, gitleaks | C | done | 2026-11-12: Terraform 1.17.2, gitleaks 8.30.1 (same version pinned in CI), pre-commit 4.7.0 in `~/.local/bin`; hooks in `.pre-commit-config.yaml` pass and block a fake token and key. pnpm 12.18.0 through corepack 0.36.0 (`packageManager` in `package.json`, same on CI). See `docs/runbooks/tooling.md` |
| T2.2 | Scaffold `apps/web` (Next.js static export) | C | done | 2026-11-12: Next.js 16.4 static export, React 19, TypeScript strict, ESLint, Vitest. `/en/` and `/it/` with canonical, hreflang and x-default; `/` serves English; one bilingual 404. CI job `web` and CodeQL `javascript-typescript` (both required by `protect-main` since PR #8); Dependabot for npm. See `docs/runbooks/web.md`. Design and 3D wait for T0.3 |
| T2.3 | Scaffold `apps/api` (Laravel + Bref, health + contact) | C | todo | |
| T2.4 | Terraform modules: dns-email, guardrails, cloudfront, lambda-api, dynamodb | C | todo | |
| T2.5 | CI: lint, test, `plan`, tfsec/checkov, CodeQL, Dependabot | C | done | 2026-11-12: PR #1 merged: gitleaks, terraform fmt/validate/tflint, checkov, shellcheck, masked `plan` as PR comment (no Gmail in comment or log, verified), CodeQL (actions), Dependabot; Actions locked down (SHA pinning, read-only token). Ruleset `protect-main` now requires a PR and the 6 checks. See `docs/runbooks/ci.md`. App lint/test and CodeQL JS join with T2.2/T2.3 |

## Phase 3 — Go live (brief phases 2–10)

| ID | Task | Owner | Status | Notes |
|---|---|---|---|---|
| T3.1 | R2 state backend, `terraform init` | C | done | 2026-11-11: state in `eduardiacob-dev-tfstate`, lockfile locking, `scripts/tf.sh` |
| T3.2 | DNS + email records, DNSSEC, CAA | C | doing | 2026-11-12: PR #3 and #4 applied. DMARC `p=quarantine`. CAA `issue amazon.com`, `issuewild ";"`, `iodef` to `ops@`; Universal SSL off so Cloudflare adds no CAA for its own CAs (verified with `dig CAA` on both nameservers and 1.1.1.1). DNSSEC on, DNSKEY published; waiting for Cloudflare Registrar to publish the DS at the .dev registry (status `pending`). Done when `dig DS eduardiacob.dev @ns-tld2.charlestonroadregistry.com` answers, resolvers set `ad` and `plan` shows no drift. `p=reject` after clean DMARC reports |
| T3.3 | Guardrails: budgets, Budget Action, anomaly detection, SNS | C | todo | First thing on AWS |
| T3.4 | GitHub OIDC + deploy role | C | todo | |
| T3.5 | Frontend live on HTTPS with security headers | C | todo | |
| T3.6 | API live, `/api/health` 200 | C | todo | |
| T3.7 | Contact form end-to-end (Streams → Brevo, DLQ alarm) | C | todo | Brevo API key into SSM, typed by E at a hidden prompt |
| T3.8 | Observability: 7-day logs, alarms tested | C | todo | |

## Phase 4 — Later

| ID | Task | Owner | Status | Notes |
|---|---|---|---|---|
| T4.1 | SEO + GEO (metadata, sitemap, schema.org, llms.txt) | C | todo | |
| T4.2 | Switch AWS to Paid + CloudFront flat-rate Free (by month 5) | E | todo | Then Identity Center (ADR-0002) |
