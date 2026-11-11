# eduardiacob.dev

Personal portfolio of Eduard Alexandru Iacob, built as a production-grade, zero-cost platform on AWS and Cloudflare.

> Status: **foundation** — architecture reviewed, infrastructure not yet provisioned.

## Architecture (target)

- **Edge:** Cloudflare DNS (DNS-only) → Amazon CloudFront with security headers.
- **Frontend:** Next.js static export on a private S3 bucket (Origin Access Control).
- **API:** Laravel on AWS Lambda (Bref, arm64) via Function URL behind CloudFront `/api/*`.
- **Data:** DynamoDB (provisioned, single-table) with TTL.
- **Infra:** Terraform, remote state on Cloudflare R2. CI/CD on GitHub Actions with OIDC (no static keys).
- **Cost guardrails:** AWS Budgets with deny action, Cost Anomaly Detection, hard technical caps.

See [`docs/reviews/2026-11-11-architecture-review.md`](docs/reviews/2026-11-11-architecture-review.md) for the current review and open decisions, and [`docs/adr/`](docs/adr/) for decision records.

## Rebuild from scratch

Instructions will be added as each phase lands.

- Local secrets and the R2 state backend: [`docs/runbooks/local-secrets.md`](docs/runbooks/local-secrets.md).
