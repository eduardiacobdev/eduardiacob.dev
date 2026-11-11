# ADR-0007: Cloudflare Email Routing instead of Purelymail

- Status: Accepted
- Date: 2026-11-11
- Supersedes: the Purelymail mailbox in the brief and in [ADR-0005](0005-cost-ceiling.md)

## Context

The brief uses Purelymail (10 $/year) as the mailbox for the domain. Its checkout does not accept the owner's payment methods. The review already listed a zero-cost alternative (finding F5).

## Decision

- **Inbound:** Cloudflare Email Routing (free) forwards `hello@`, `ops@` and `aws@eduardiacob.dev` to the owner's personal Gmail. Unknown addresses are dropped, no catch-all.
- **Outbound as `hello@`:** Gmail "Send mail as" through Brevo SMTP (free plan, already in the architecture for transactional mail). Brevo DKIM is published on the domain (`d=eduardiacob.dev`), so DMARC aligns on DKIM; no SPF include is needed because Brevo uses its own Return-Path domain. DMARC starts at `p=none` with aggregate reports to Cloudflare DMARC Management and is tightened once aligned mail is confirmed (T3.2). Setup and rotation: [`docs/runbooks/brevo-gmail-send-as.md`](../runbooks/brevo-gmail-send-as.md).
- **As code:** Email Routing settings, rules and DNS records are managed by Terraform in the `dns-email` module. The destination Gmail address is verified once by the owner [human].
- No new account and no payment.

## Mail organization

Goal: project mail never mixes with personal mail, and every message shows which address it came through.

### Cloudflare: one address per purpose

| Address | Receives | Forwarded to | Gmail label |
|---|---|---|---|
| `hello@` | Public contact: people, recruiters, replies to the site | `<gmail>+hello@gmail.com` | `eduardiacob.dev/hello` |
| `ops@` | Machine alerts: AWS Budgets, SNS/CloudWatch alarms, Cloudflare notifications, Brevo | `<gmail>+ops@gmail.com` | `eduardiacob.dev/ops` |
| `aws@` | AWS root account only (ADR-0006) | `<gmail>+aws@gmail.com` | `eduardiacob.dev/aws` |
| `noreply@` | Nothing: sender of contact-form notifications via Brevo, no inbound rule | — | — |
| anything else | Dropped (catch-all = drop) | — | — |

- Each alias forwards to its own Gmail plus address. Gmail sorts on `deliveredto:`, which works even for Bcc and mailing-list mail, where the `To:` header does not show our address. Each plus address is a separate destination to verify once [human].
- The real Gmail address never enters the public repo: Terraform reads it from a sensitive variable (local env var, GitHub secret in CI).
- Gmail delivers plus addresses to the main inbox. Cloudflare accepts plus addresses as destinations (confirmed 2026-11-11).
- Cloudflare refuses a forwarding rule whose destination is not verified yet. The first apply creates the destinations and sends the verification mail; the rules are created by a second apply after the owner clicks the links.

### Gmail: labels and filters [human-approved]

- Labels: `eduardiacob.dev` with children `hello`, `ops`, `aws`, `accounts`, one colour each.
- One filter per plus address → its label, never sent to Spam. Mail stays in the inbox: alerts and the AWS root mail must be seen.
- `accounts`: mail that project services send straight to Gmail (Cloudflare, GitHub, Brevo), filtered by sender. These accounts keep Gmail as their login email so recovery never depends on our own domain.
- Sending: "Send mail as `hello@`" via Brevo SMTP, with "reply from the same address the message was sent to" on.
- As code: the filters live in `config/gmail/filters.xml.tmpl` (address replaced by a placeholder) and are imported with [`docs/runbooks/gmail-filters.md`](../runbooks/gmail-filters.md). Set up on 2026-11-11: hello blue, ops orange, aws red and always important, accounts dark grey and limited to mail from that date on.

## Consequences

- Fixed yearly cost drops to the domain only (about 12 $).
- Mail lives in the personal Gmail, not in a separate mailbox. Gmail stays the root of the recovery chain (it already was).
- If Email Routing breaks, domain addresses stop receiving mail. Cloudflare login does not depend on domain mail, so the owner can always fix it. The AWS root email (`aws@`, ADR-0006) inherits this dependency; the routing config is under version control and checked by `terraform plan`.
- Mail sent as `hello@` passes through Brevo, which adds an open-tracking pixel that the free plan cannot remove. Tracking is set to anonymous (aggregate counts only); see the runbook.
- Revisit if the owner needs a separate mailbox (e.g. shared access), with any provider that accepts the owner's payment methods.
