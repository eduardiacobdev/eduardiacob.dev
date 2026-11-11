# ADR-0003: Contact form abuse protection without WAF until the flat-rate plan

- Status: Accepted
- Date: 2026-11-11
- Supersedes: brief v1, "rate limiting WAF" for the Free plan phase

## Context

AWS WAF is billed per web ACL, rule and request (about 6+ $/month minimum). It is included at no cost only in the CloudFront flat-rate plans, which Free plan accounts cannot use. The protection must be free and must not add friction for real visitors.

## Decision

Layered, free controls from day one:

1. **Cloudflare Turnstile** in invisible/managed mode: no puzzle for real users; token verified server-side by the API. Widget managed in Terraform (`cloudflare_turnstile_widget`), secret in SSM.
2. **Honeypot field** and minimum fill time, rejected silently.
3. **Per-IP rate limit** in DynamoDB (atomic counter, TTL-expired windows), inside the provisioned capacity cap.
4. **CloudFront Function** on `/api/*`: allow only expected methods, paths and body size (free tier: 2M invocations/month).
5. **Lambda reserved concurrency 5**: the hard ceiling on compute regardless of traffic.

When the CloudFront flat-rate Free plan is active (phase 11), add the bundled WAF rate-based rule and managed rules as an outer layer; the layers above stay.

## Consequences

- Cost: 0 $. Turnstile is free with no request limit for this use.
- Adds one Cloudflare service (approved by the owner on 2026-11-11).
- Flood risk during the Free plan is an availability risk, not a billing risk: the account cannot be charged.
