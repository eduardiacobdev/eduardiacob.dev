# Inbound domain mail: Cloudflare Email Routing forwards each alias to its own
# Gmail plus address, everything else is dropped (ADR-0007).

locals {
  gmail_user = split("@", var.gmail_address)[0]
}

# Enables Email Routing on the zone. Cloudflare adds and locks the MX, SPF and
# DKIM records it needs.
resource "cloudflare_email_routing_dns" "this" {
  zone_id = var.zone_id
}

# Each destination is verified once by the owner through the link Cloudflare
# sends to it. Until then, mail to its alias is not delivered.
resource "cloudflare_email_routing_address" "alias" {
  for_each = var.aliases

  account_id = var.account_id
  email      = "${local.gmail_user}+${each.key}@gmail.com"
}

resource "cloudflare_email_routing_rule" "alias" {
  for_each = var.aliases

  zone_id = var.zone_id
  name    = "${each.key}@ to Gmail"
  enabled = true

  matchers = [{
    type  = "literal"
    field = "to"
    value = "${each.key}@${var.domain}"
  }]

  actions = [{
    type  = "forward"
    value = [cloudflare_email_routing_address.alias[each.key].email]
  }]

  depends_on = [cloudflare_email_routing_dns.this]
}

resource "cloudflare_email_routing_catch_all" "drop" {
  zone_id = var.zone_id
  name    = "Drop unknown addresses"
  enabled = true

  matchers = [{ type = "all" }]
  actions  = [{ type = "drop" }]

  depends_on = [cloudflare_email_routing_dns.this]
}
