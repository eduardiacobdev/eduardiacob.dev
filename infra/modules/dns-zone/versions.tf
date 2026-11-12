# Modules state a minimum and the major version; the root module pins exact
# minors (envs/prod/versions.tf).
terraform {
  required_version = ">= 1.17"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5.28, < 6.0"
    }
  }
}
