output "dnssec_ds" {
  description = "DS record Cloudflare publishes at the registry (public data)."
  value       = cloudflare_zone_dnssec.this.ds
}
