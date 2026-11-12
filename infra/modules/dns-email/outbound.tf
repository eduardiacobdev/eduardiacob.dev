# Outbound domain mail: Gmail "Send mail as hello@" and the contact form send
# through Brevo SMTP (ADR-0007). Brevo signs with DKIM on our domain, so
# DMARC aligns on DKIM; no SPF include is needed (Brevo's Return-Path is its
# own domain).
#
# Values come from Brevo > Senders, domains, IPs > Domains > eduardiacob.dev
# (manual setup). They are public DNS data, not secrets.

locals {
  brevo_dkim = {
    brevo1 = "b1.${replace(var.domain, ".", "-")}.dkim.brevo.com"
    brevo2 = "b2.${replace(var.domain, ".", "-")}.dkim.brevo.com"
  }
}

# Proves domain ownership to Brevo.
resource "cloudflare_dns_record" "brevo_code" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "TXT"
  content = "\"brevo-code:${var.brevo_code}\""
  ttl     = 1
  comment = "Brevo domain verification (ADR-0007), managed by Terraform"
}

# Brevo rotates the DKIM keys behind these CNAMEs on its side.
resource "cloudflare_dns_record" "brevo_dkim" {
  for_each = local.brevo_dkim

  zone_id = var.zone_id
  name    = "${each.key}._domainkey.${var.domain}"
  type    = "CNAME"
  content = each.value
  proxied = false
  ttl     = 1
  comment = "Brevo DKIM (ADR-0007), managed by Terraform"
}

# p=quarantine (brief): every sender of @eduardiacob.dev mail (Gmail send-as
# and the contact form, both through Brevo) is DKIM-aligned, verified on
# 2026-11-12. Next step is p=reject once the aggregate reports stay clean.
# Reports go to Cloudflare DMARC Management, which created this record when it
# was enabled [human]; keep the rua address as it generated it.
resource "cloudflare_dns_record" "dmarc" {
  zone_id = var.zone_id
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  content = "\"v=DMARC1; p=quarantine; rua=mailto:${var.dmarc_rua}\""
  ttl     = 1
  comment = "DMARC, reports to Cloudflare DMARC Management (ADR-0007), managed by Terraform"
}
