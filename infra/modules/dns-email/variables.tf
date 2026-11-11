variable "account_id" {
  description = "Cloudflare account ID (owns the Email Routing destination addresses)."
  type        = string
}

variable "zone_id" {
  description = "Cloudflare zone ID of the domain."
  type        = string
}

variable "domain" {
  description = "Domain the aliases live on, e.g. eduardiacob.dev."
  type        = string
}

variable "gmail_address" {
  description = "Personal Gmail address that receives domain mail. Never committed: set via TF_VAR_gmail_address."
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[a-z0-9.]+@gmail\\.com$", var.gmail_address))
    error_message = "Must be a plain @gmail.com address without a plus tag."
  }
}

variable "aliases" {
  description = "Local parts that receive mail. Each forwards to <gmail-user>+<alias>@gmail.com (ADR-0007)."
  type        = set(string)

  validation {
    condition     = alltrue([for a in var.aliases : can(regex("^[a-z0-9-]+$", a))])
    error_message = "Aliases must be lowercase letters, digits and dashes."
  }
}

variable "brevo_code" {
  description = "Brevo domain verification code (hex part of the brevo-code TXT value)."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{32}$", var.brevo_code))
    error_message = "Must be the 32-character hex code Brevo shows for the domain."
  }
}

variable "dmarc_rua" {
  description = "Address that receives DMARC aggregate reports (Cloudflare DMARC Management)."
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+$", var.dmarc_rua))
    error_message = "Must be a plain email address, without mailto:."
  }
}
