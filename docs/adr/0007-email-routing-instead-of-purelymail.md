# ADR-0007: Cloudflare Email Routing instead of Purelymail

- Status: Accepted
- Date: 2026-11-11
- Supersedes: the Purelymail mailbox in the brief and in [ADR-0005](0005-cost-ceiling.md)

## Context

The brief uses Purelymail (10 $/year) as the mailbox for the domain. Its checkout does not accept the owner's payment methods. The review already listed a zero-cost alternative (finding F5).

## Decision

- **Inbound:** Cloudflare Email Routing (free) forwards `hello@`, `ops@` and `aws@eduardiacob.dev` to the owner's personal Gmail. Unknown addresses are dropped, no catch-all.
- **Outbound as `hello@`:** Gmail "Send mail as" through Brevo SMTP (free plan, already in the architecture for transactional mail). SPF and DKIM for Brevo are published on the domain, DMARC starts at `p=none` with reports and is tightened once aligned mail is confirmed.
- **As code:** Email Routing settings, rules and DNS records are managed by Terraform in the `dns-email` module. The destination Gmail address is verified once by the owner [human].
- No new account and no payment.

## Consequences

- Fixed yearly cost drops to the domain only (about 12 $).
- Mail lives in the personal Gmail, not in a separate mailbox. Gmail stays the root of the recovery chain (it already was).
- If Email Routing breaks, domain addresses stop receiving mail. Cloudflare login does not depend on domain mail, so the owner can always fix it. The AWS root email (`aws@`, ADR-0006) inherits this dependency; the routing config is under version control and checked by `terraform plan`.
- Revisit if the owner needs a separate mailbox (e.g. shared access), with any provider that accepts the owner's payment methods.
