locals {
  account_id = "d41719423d64b5b6fea8a1223e4e2ec8"
  domain     = "eduardiacob.dev"
}

data "cloudflare_zone" "this" {
  filter = {
    name = local.domain
  }
}

module "dns_email" {
  source = "../../modules/dns-email"

  account_id    = local.account_id
  zone_id       = data.cloudflare_zone.this.zone_id
  domain        = local.domain
  gmail_address = var.gmail_address
  aliases       = ["hello", "ops", "aws"]

  # Brevo > Senders, domains, IPs > Domains (manual setup).
  brevo_code = "84a9bdf8759e8080893b7cafa19968cd"
  # Cloudflare > Email > DMARC Management, generated for this zone.
  dmarc_rua = "2e97ee7b8f744c07a7219eb1e7f12ddd@dmarc-reports.cloudflare.net"
}

output "mail_aliases" {
  value = module.dns_email.aliases
}

output "mail_destinations_verified" {
  value = module.dns_email.destination_status
}
