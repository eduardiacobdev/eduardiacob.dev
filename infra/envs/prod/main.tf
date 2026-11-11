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
}

output "mail_aliases" {
  value = module.dns_email.aliases
}

output "mail_destinations_verified" {
  value = module.dns_email.destination_status
}
