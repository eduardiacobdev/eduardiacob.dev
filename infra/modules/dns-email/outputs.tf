output "aliases" {
  description = "Domain addresses that receive mail."
  value       = sort([for a in var.aliases : "${a}@${var.domain}"])
}

output "destination_status" {
  description = "Verification state of each Gmail destination, by alias (true once verified)."
  value       = { for a, d in cloudflare_email_routing_address.alias : a => d.verified != null && d.verified != "" }
}
