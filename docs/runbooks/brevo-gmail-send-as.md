# Runbook: Brevo domain and Gmail "Send mail as hello@"

Outbound mail from `hello@eduardiacob.dev` leaves Gmail through Brevo SMTP (ADR-0007, TASKS T1.10). Inbound mail is Cloudflare Email Routing and is not covered here.

## Current setup (2026-11-12)

| Piece | Where | Value | Origin |
|---|---|---|---|
| Brevo account | app.brevo.com | Free plan, login with the owner's Gmail | [human] |
| Domain `eduardiacob.dev` | Brevo > Senders, domains, IPs > Domains | Authenticated (manual setup) | [human-approved] |
| Ownership TXT `brevo-code:…` | Cloudflare DNS | `cloudflare_dns_record.brevo_code` | Terraform |
| DKIM CNAMEs `brevo1/2._domainkey` → `b1/b2.eduardiacob-dev.dkim.brevo.com` | Cloudflare DNS | `cloudflare_dns_record.brevo_dkim` | Terraform |
| DMARC `p=quarantine` (T3.2), reports to Cloudflare DMARC Management | Cloudflare DNS | `cloudflare_dns_record.dmarc` (imported) | Terraform |
| Sender `hello@eduardiacob.dev` | Brevo > Senders | Verified automatically (authenticated domain) | [human-approved] |
| SMTP key `gmail-send-as-hello` | Brevo > SMTP & API > SMTP | Standard key, expires about 2027-11-12 | [human] |
| Anonymous tracking | Brevo > Settings > Transactional email > Tracking | Yes | [human-approved] |
| Gmail "Send mail as" `hello@` | Gmail > Settings > Accounts and Import | Via Brevo SMTP, reply from the same address on | [human-approved] |

Records live in [`infra/modules/dns-email/outbound.tf`](../../infra/modules/dns-email/outbound.tf). They are public DNS data, not secrets.

### Why no SPF include for Brevo

Brevo sends with its own Return-Path domain, so SPF is checked against Brevo, not against us, and could never align. DMARC passes on DKIM instead: Brevo signs with `d=eduardiacob.dev` through the two CNAMEs. The domain SPF stays `v=spf1 include:_spf.mx.cloudflare.net ~all` (Email Routing forwarding).

### Why no SMTP IP blocking

Brevo can restrict SMTP logins to known IPs, but Gmail connects from changing Google addresses. IP blocking stays off; the key is long, random and used only by Gmail.

## Gmail settings

Gmail > Settings > Accounts and Import > Send mail as > Add another email address:

- Name `Eduard Alexandru Iacob`, address `hello@eduardiacob.dev`, "Treat as an alias" on.
- SMTP server `smtp-relay.brevo.com`, port `587`, TLS.
- Username: the Brevo SMTP login shown on the SMTP page (`…@smtp-brevo.com`), password: the SMTP key.
- Gmail sends a confirmation mail to `hello@`, which Email Routing forwards back to Gmail: open the link.
- "When replying to a message: reply from the same address the message was sent to" on.

The SMTP key exists only in Brevo (hashed) and in Gmail. It is not in the Keychain or SSM: nothing else uses it. The contact form (T3.7) will use a separate Brevo **API** key stored in SSM.

## Testing

- Gmail hides a received message whose Message-ID matches one it sent. A test from `hello@` to `ops@` or `hello@` (both forward to the same Gmail) shows only the sent copy. Brevo > Transactional > Logs still shows `Sent` and `Delivered`.
- To check authentication, send from `hello@` to a mailbox outside this Gmail and look at the headers: `dkim=pass header.d=eduardiacob.dev` and `dmarc=pass`.

Verified on 2026-11-12 (test to an external mailbox): `dkim=pass header.d=eduardiacob.dev`, `dmarc=pass header.from=eduardiacob.dev`, `spf=pass` for the Return-Path `…@gy.d.sender-sib.com` (Brevo, not aligned).

## Tracking pixel (accepted limit)

Brevo logged a "Loaded by proxy" event for the external test: it adds an open-tracking pixel even to mail relayed from Gmail.

- It cannot be removed on the free plan. `removeTrackingPixel` exists only on Enterprise and only for API sends, not SMTP relay.
- Mitigation [human-approved, 2026-11-12]: Brevo > Settings > Transactional email > Tracking > "Anonymous email tracking" = **Yes**. Opens and clicks are counted in aggregate only, never tied to a recipient.
- Revisit if tracking of personal mail from `hello@` becomes a problem (e.g. the CNIL consent recommendation for open tracking): that means another SMTP relay, which needs the owner's approval.

## Rotation (TASKS T1.11)

The SMTP key expires about 2027-11-12. Rotate in October 2027:

1. Brevo > SMTP & API > SMTP > Generate a new SMTP key, name `gmail-send-as-hello-<year>`.
2. Gmail > Settings > Accounts and Import > `hello@` > edit info > paste the new key > Save.
3. Send a test to an external mailbox, check Brevo logs.
4. Delete the old key in Brevo.

If the key leaks: delete it in Brevo first (Gmail sending from `hello@` stops), then do steps 1–3.

## Recreate the domain in Brevo

1. Brevo > Senders, domains, IPs > Domains > Add a domain > `eduardiacob.dev` > manual setup.
2. Copy the `brevo-code` value into `brevo_code` in `infra/envs/prod/main.tf`. The DKIM targets follow the `b1/b2.<domain-with-dashes>.dkim.brevo.com` pattern; check them against the dashboard.
3. Plan and apply, then Authenticate in Brevo. Ignore the DMARC record Brevo suggests: ours is managed by Terraform.
