# ADR-0005: Cost ceiling

- Status: Accepted
- Date: 2026-11-11

## Context

The owner accepts the fixed yearly costs of the domain (about 12 $) and Purelymail (10 $). Everything else must be 0, with an absolute tolerance of 5 €/month.

## Decision

- **Target: 0 $/month on AWS and Cloudflare.** No planned spend uses the tolerance.
- The 5 €/month tolerance is an emergency margin only, never a design budget.
- Guardrails stay as in the brief: alert on actual spend at 0.01 $, forecast at 0.50 $, Budget Action deny at 1 $. Raising them needs the owner.
- Any change that would create a recurring cost, even below 5 €, needs an ADR and owner approval.

## Consequences

- `eduardiacob.io` is not purchased.
- Purelymail stays as the mailbox provider.
