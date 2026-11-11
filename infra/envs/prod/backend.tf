# State lives on Cloudflare R2 (S3-compatible), EU jurisdiction.
# Credentials are not set here: locally `scripts/tf.sh init` passes the `r2`
# AWS profile (Keychain via credential_process), in CI they come from secrets.
terraform {
  backend "s3" {
    bucket = "eduardiacob-dev-tfstate"
    key    = "prod/terraform.tfstate"
    region = "auto"

    endpoints = {
      s3 = "https://d41719423d64b5b6fea8a1223e4e2ec8.eu.r2.cloudflarestorage.com"
    }

    use_lockfile                = true
    use_path_style              = true
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}
