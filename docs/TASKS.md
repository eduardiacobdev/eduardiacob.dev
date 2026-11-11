# Task board

Owner: **E** = Eduard (needs a human: accounts, passwords, payments, MFA) · **C** = collaborator (builds, prepares and proposes; never holds secrets or pays).
Status: `todo` · `doing` · `blocked` · `done`.

Rule: every human step is prepared and pre-filled in advance; Eduard only types secrets, pays and confirms.

## Phase 0 — Foundations

| ID | Task | Owner | Status | Notes |
|---|---|---|---|---|
| T0.1 | Architecture review + ADRs 0001–0006 | C | done | `docs/reviews`, `docs/adr` |
| T0.2 | Brand brief: who you are, target, 2–3 reference sites | E | todo | E answers, C writes it up |
| T0.3 | Brand identity (name treatment, palette, type, voice) | C | todo | After T0.2 |

## Phase 1 — Accounts (human)

| ID | Task | Owner | Status | Notes |
|---|---|---|---|---|
| T1.1 | GitHub: username `eduardiacobdev`, 2FA + passkey, email private | E | doing | Username, email privacy + push block done 2026-11-11; 2FA pending |
| T1.2 | Create the public repo `eduardiacob.dev` and push | C | todo | Needs T1.1 + `gh auth login` (E runs it once) |
| T1.3 | Cloudflare account (personal Gmail, see recovery chain), 2FA on | E | doing | Account created; 2FA pending |
| T1.4 | Buy `eduardiacob.dev` (Cloudflare Registrar), auto-renew + domain lock | E+C | todo | C searches and pre-fills; E enters contact/payment and confirms |
| T1.5 | Enable R2 (requires a payment method on file, stays 0 $ in free quota) | E | todo | |
| T1.6 | Cloudflare API token: Zone DNS Edit (this zone), Turnstile Edit, R2 Edit | E+C | todo | C configures scopes; E copies the token into the terminal prompt C prepares |
| T1.7 | Purelymail account, Simple plan (10 $/yr) | E | todo | |
| T1.8 | AWS account, **advanced** sign-up, Free plan, root MFA | E | blocked | Wait for T2.x + Purelymail (ADR-0006): saves free-plan months |
| T1.9 | IAM admin user with MFA (ADR-0002), `aws login` works | E+C | todo | C gives exact clicks; E sets password/MFA |
| T1.10 | Brevo free account, API key into SSM | E+C | todo | Key typed by E in a hidden terminal prompt |

## Phase 2 — Build (agent, local first)

| ID | Task | Owner | Status | Notes |
|---|---|---|---|---|
| T2.1 | Tooling: Terraform/OpenTofu, pnpm, pre-commit, gitleaks | C | todo | |
| T2.2 | Scaffold `apps/web` (Next.js static export) | C | todo | |
| T2.3 | Scaffold `apps/api` (Laravel + Bref, health + contact) | C | todo | |
| T2.4 | Terraform modules: dns-email, guardrails, cloudfront, lambda-api, dynamodb | C | todo | |
| T2.5 | CI: lint, test, `plan`, tfsec/checkov, CodeQL, Dependabot | C | todo | |

## Phase 3 — Go live (brief phases 2–10)

| ID | Task | Owner | Status | Notes |
|---|---|---|---|---|
| T3.1 | R2 state backend, `terraform init` | C | todo | Needs T1.5, T1.6 |
| T3.2 | DNS + email records, DNSSEC, CAA | C | todo | E confirms MX change |
| T3.3 | Guardrails: budgets, Budget Action, anomaly detection, SNS | C | todo | First thing on AWS |
| T3.4 | GitHub OIDC + deploy role | C | todo | |
| T3.5 | Frontend live on HTTPS with security headers | C | todo | |
| T3.6 | API live, `/api/health` 200 | C | todo | |
| T3.7 | Contact form end-to-end (Streams → Brevo, DLQ alarm) | C | todo | |
| T3.8 | Observability: 7-day logs, alarms tested | C | todo | |

## Phase 4 — Later

| ID | Task | Owner | Status | Notes |
|---|---|---|---|---|
| T4.1 | SEO + GEO (metadata, sitemap, schema.org, llms.txt) | C | todo | |
| T4.2 | Switch AWS to Paid + CloudFront flat-rate Free (by month 5) | E | todo | Then Identity Center (ADR-0002) |
