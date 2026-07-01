#region Cloudflare Resources

resource "cloudflare_url_normalization_settings" "this" {
  scope   = "incoming"
  type    = "cloudflare"
  zone_id = cloudflare_zone.this.id
}

resource "cloudflare_zero_trust_access_identity_provider" "google" {
  name    = "Google"
  type    = "google"
  zone_id = cloudflare_zone.this.id
  config = {
    client_id     = var.idps.google.client_id
    client_secret = var.idps.google.client_secret
  }
  scim_config = {
    enabled          = false
    seat_deprovision = false
    user_deprovision = false
  }
}

resource "cloudflare_zero_trust_access_policy" "allow_me_global" {
  account_id       = local.cloudflare_account_id
  decision         = "allow"
  include          = [for email in var.emails.me : { email = { email = email } } if email != null]
  name             = "Allow; Me; Global"
  session_duration = "6h"
}

resource "cloudflare_zero_trust_access_policy" "allow_me_us" {
  account_id       = local.cloudflare_account_id
  decision         = "allow"
  include          = [for email in var.emails.me : { email = { email = email } } if email != null]
  name             = "Allow; Me; US"
  require          = [{ geo = { country_code = "US" } }]
  session_duration = "6h"
}

resource "cloudflare_zero_trust_access_policy" "bypass_everyone" {
  account_id = local.cloudflare_account_id
  decision   = "bypass"
  include    = [{ everyone = {} }]
  name       = "Bypass; Everyone"
}

resource "cloudflare_zone" "this" {
  account = {
    id = local.cloudflare_account_id
  }
  name   = local.domain
  paused = false
  type   = "full"
}

resource "cloudflare_zone_dnssec" "this" {
  status  = "active"
  zone_id = cloudflare_zone.this.id
}

resource "cloudflare_zone_setting" "ssl" {
  setting_id = "ssl"
  value      = "strict" # "off", "flexible", "full", or "strict"
  zone_id    = cloudflare_zone.this.id
}

#endregion Cloudflare Resources

#region Submodules

module "cloudflared" {
  source = "./applications/cloudflared"
  application_configs = concat(
  )
  cloudflare_zone = cloudflare_zone.this
  domains = [
    local.domain,        # primary apex domain
    "*.${local.domain}", # preemptively reserve wildcard subdomain to avoid downtime when adding subdomains in the future
  ]
  proxy_service = module.traefik.proxy_service
}

#endregion
