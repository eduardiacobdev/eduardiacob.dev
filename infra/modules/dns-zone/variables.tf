variable "zone_id" {
  description = "Cloudflare zone ID of the domain."
  type        = string
}

variable "domain" {
  description = "Apex domain of the zone, e.g. eduardiacob.dev."
  type        = string
}

variable "caa_issuers" {
  description = "CA domains allowed to issue non-wildcard certificates (CAA issue). Wildcards are denied."
  type        = set(string)

  validation {
    condition     = length(var.caa_issuers) > 0 && alltrue([for ca in var.caa_issuers : can(regex("^[a-z0-9.-]+$", ca))])
    error_message = "List at least one CA domain, lowercase, e.g. amazon.com."
  }
}

variable "caa_iodef" {
  description = "Address that receives CAA violation reports from CAs."
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+$", var.caa_iodef))
    error_message = "Must be a plain email address, without mailto:."
  }
}
