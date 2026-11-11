# ADR-0006: AWS sign-up path (advanced) and account timing

- Status: Accepted
- Date: 2026-11-11

## Context

AWS now offers two sign-up paths ([compare](https://docs.aws.amazon.com/accounts/latest/reference/sign-up-for-aws.html)):

- **New experience:** project accounts with spend limits (Paid plan only), automatic Organizations and Identity Center. The Region is fixed by the contact country: Italy → `eu-north-1` (Stockholm), not selectable. CloudFront features that create resources outside that Region are unavailable, including WAF ([project Regions](https://docs.aws.amazon.com/accounts/latest/reference/project-regions.html)). No IAM Access Analyzer, no own SCPs, IAM users are programmatic-only.
- **Advanced:** classic account with root user, full Region choice, all services.

The architecture needs an ACM certificate in `us-east-1` for CloudFront, `eu-central-1` as primary Region, and later the bundled WAF. The Free plan's 6-month clock starts at sign-up.

## Decision

- Use **Sign up for AWS (advanced)** on the Free plan.
- Create the account **only when the Phase 2 code is ready to deploy** (TASKS T2.x done), so the 6 free months are spent running, not waiting.
- Root email: `aws@eduardiacob.dev`, forwarded to the owner's Gmail by Cloudflare Email Routing (ADR-0007). The address is unique to AWS and can be re-pointed without touching the AWS account. Email Routing must be live and tested before sign-up.

## Consequences

- No native spend limit: cost safety relies on the Free plan (cannot bill), technical caps and the guardrails module (ADR-0005).
- Reconsider the new experience only if it adds Region choice and cross-Region CloudFront features.
