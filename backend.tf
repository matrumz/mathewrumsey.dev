terraform {
  backend "s3" { # R2 - https://developers.cloudflare.com/terraform/advanced-topics/remote-backend/
    bucket                      = "cloudflare-terraform"
    key                         = "mathewrumsey.dev/terraform.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    # Credentials and endpoint provided via environment variables:
    # AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_ENDPOINT_URL_S3
  }
}
