# ADR-0005: Cost ceiling

- Status: Accepted
- Date: 2026-11-11

## Context

The owner accepts the fixed yearly cost of the domain (about 12 $). Purelymail (10 $) was accepted at first and later dropped by [ADR-0007](0007-email-routing-instead-of-purelymail.md). Everything else must be 0, with an absolute tolerance of 5 €/month.

## Decision

- **Target: 0 $/month on AWS and Cloudflare.** No planned spend uses the tolerance.
- The 5 €/month tolerance is an emergency margin only, never a design budget.
- Guardrails stay as in the brief: alert on actual spend at 0.01 $, forecast at 0.50 $, Budget Action deny at 1 $. Raising them needs the owner.
- Any change that would create a recurring cost, even below 5 €, needs an ADR and owner approval.

## Consequences

- `eduardiacob.io` is not purchased.
- No paid mailbox: domain mail goes through Cloudflare Email Routing (ADR-0007).
