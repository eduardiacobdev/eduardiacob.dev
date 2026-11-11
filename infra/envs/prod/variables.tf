variable "gmail_address" {
  description = "Personal Gmail address for domain mail (ADR-0007). Set via TF_VAR_gmail_address, never committed."
  type        = string
  sensitive   = true
}
