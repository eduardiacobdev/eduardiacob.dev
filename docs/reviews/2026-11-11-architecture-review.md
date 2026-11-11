# Architecture review — brief v1 (2026-11-11)

Reviewer: platform/DevOps lead
Input: the infrastructure brief v1 (private, not in the repo)
Status: **Approved with changes** — items marked *Needs owner decision* change a "closed" decision in the brief and wait for Eduard.

## Verdict

The brief is solid: everything-as-code, no static keys, OIDC, technical caps before alarms, explicit forbidden list, human gates on money and DNS. It is already above the level of most portfolio projects.

Five issues would break either the zero-cost rule or the build itself. Each has a fix below.

## Findings

### F1 — IAM Identity Center conflicts with the AWS Free plan (blocking)

- Identity Center grants access to AWS accounts only through an **organization instance**, which needs AWS Organizations. An *account instance* covers application access only.
- Per the [AWS Free Tier terms](https://aws.amazon.com/free/terms), a Free plan account that joins AWS Organizations is **converted to Paid** and loses Free Tier credits. The upgrade is irreversible.
- **Fix:** during the Free plan phase, use one IAM admin user with MFA and short-lived CLI credentials (`aws login` / console-derived session credentials; no access keys). Move to Identity Center at the Paid switch (phase 11). Record as ADR.
- *To verify at account creation:* the 2026 sign-up flow ("projects" with spend caps and invites, [Help Net Security](https://helpnetsecurity.com/2026/09/17/aws-spend-limit-agent-set-permissions)) may replace both options.

### F2 — WAF is not free before the CloudFront flat-rate plan (blocking for "zero cost")

- WAF bills per web ACL, per rule and per request. It is only bundled in the CloudFront flat-rate plans, which Free plan accounts cannot use ([Pricing Plan Manager](https://docs.aws.amazon.com/PricingPlanManager/latest/UserGuide/plans.html)).
- **Fix (months 0–5):** no WAF. Protect the contact form with Cloudflare Turnstile (free, server-side token check), Lambda reserved concurrency, and a per-IP counter in DynamoDB with TTL. Add WAF rate limiting when the flat-rate Free plan is active. *Needs owner decision* (Turnstile is a new Cloudflare service).

### F3 — POST through OAC to a Lambda Function URL needs a body hash (implementation)

- With OAC in front of a Function URL, `POST`/`PUT` requests must carry `x-amz-content-sha256` with the SHA-256 of the body ([AWS docs](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-lambda.html)).
- **Fix:** the web client computes the hash with Web Crypto. Covered by an end-to-end test. No decision needed.

### F4 — SQS + Lambda polls forever and creates a dual write (design)

- A Lambda event source mapping long-polls the queue even when empty: about 130k requests per month per queue, with five parallel pollers after idle periods ([AWS docs](https://docs.aws.amazon.com/lambda/latest/dg/services-sqs-scaling.html), [CloudBurn](https://cloudburn.io/blog/amazon-sqs-pricing)). It fits the 1M quota, but it is a permanent background cost.
- The API would write to DynamoDB **and** send to SQS: two writes that can disagree.
- **Fix:** write the message to DynamoDB only; a **DynamoDB Streams** trigger runs the notification worker (Lambda trigger reads of streams are free). Failed batches go to an SQS **on-failure destination** used as DLQ, which has no poller. One write, native outbox pattern, no idle traffic. *Needs owner decision* (changes a closed decision).

### F5 — Spend versus "zero budget"

- The brief accepts about 22 $/year (domain 12 + Purelymail 10). The domain is unavoidable for a credible portfolio.
- **Option:** Cloudflare Email Routing (free, inbound to an existing mailbox) + Brevo SMTP for "send as" (free, SPF/DKIM aligned) brings it to about 12 $/year. Trade-off: no real mailbox on the domain, mail lives in a personal provider. *Needs owner decision.*
- Skip `eduardiacob.io` (about 50 $/year, no value). `eduardiacob.com` is already registered by someone else; `eduardiacob.dev` and `.io` were free on 2026-11-11.

## Additions (no conflict with the brief)

| # | Addition | Why |
|---|---|---|
| A1 | DNSSEC on the Cloudflare zone | Free, prevents DNS spoofing |
| A2 | CAA records limited to Amazon (ACM) | Only our CA can issue certificates for the domain |
| A3 | Public repository with branch protection, Dependabot, CodeQL, secret scanning, `gitleaks` pre-commit | Portfolio visibility, unlimited Actions minutes, free security tooling |
| A4 | GitHub Environment `prod` with required reviewer on `deploy.yml` | Human gate on apply |
| A5 | `terraform plan` posted to PRs with sensitive values masked | Public repo must not leak state data |
| A6 | CloudFront Function for `/path` → `/path/index.html` | Next.js static export routing; 2M invocations/month free |
| A7 | `tfsec`/`trivy` + `checkov` in CI | Policy-as-code on every plan |
| A8 | OpenTofu instead of Terraform (optional, ADR) | Native client-side state encryption for a state file stored on R2 |

## Still to verify at start (from the brief, plus new ones)

- Exact limits of the CloudFront flat-rate Free plan (third-party sources say 1M requests, 100 GB, WAF with 5 rules; not yet confirmed on the official table).
- CloudWatch Logs free quota; Bref layer availability in `eu-central-1`.
- Whether the new AWS sign-up offers project spend limits.
- Whether "Lambda Web Functions" with OAC removes the F3 body-hash requirement (one Classmethod article says so; unconfirmed).

## Recommended order

1. **Now, no accounts needed (agent):** repo foundations, ADRs, CI skeleton, local scaffolding of `apps/web`, `apps/api`, `infra/modules`.
2. **Now, human:** Cloudflare account + buy `eduardiacob.dev`; GitHub account check; AWS account on the Free plan with root MFA.
3. **In parallel:** brand identity and content (positioning, name treatment, palette, type), so the frontend has something real to ship.
4. Then brief phases 2 → 11 in order, each with its verification.
