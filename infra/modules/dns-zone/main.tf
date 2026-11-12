# Zone-level DNS security (architecture review A1, A2).

# DNSSEC signs the zone. With Cloudflare Registrar the DS record is published
# at the .dev registry automatically, no manual step at the registrar.
# Turning it off later must wait for the DS record to be removed first, or the
# domain stops resolving for validating resolvers.
resource "cloudflare_zone_dnssec" "this" {
  zone_id = var.zone_id
  status  = "active"
}

# CAA: only the listed CAs may issue certificates for the domain. While
# Universal SSL is on, Cloudflare also serves CAA records for its own CAs.
locals {
  caa = merge(
    { for ca in var.caa_issuers : "issue-${ca}" => { tag = "issue", value = ca } },
    { "issuewild" = { tag = "issuewild", value = ";" } },
    { "iodef" = { tag = "iodef", value = "mailto:${var.caa_iodef}" } },
  )
}

resource "cloudflare_dns_record" "caa" {
  for_each = local.caa

  zone_id = var.zone_id
  name    = var.domain
  type    = "CAA"
  ttl     = 1
  comment = "CAA ${each.value.tag} (review A2), managed by Terraform"

  data = {
    flags = 0
    tag   = each.value.tag
    value = each.value.value
  }
}
