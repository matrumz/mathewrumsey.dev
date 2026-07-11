resource "cloudflare_zero_trust_access_application" "this" {
  app_launcher_visible      = true
  auto_redirect_to_identity = false
  destinations = [{
    type = "public"
    uri  = local.application_domain
  }]
  domain                     = local.application_domain
  enable_binding_cookie      = true
  http_only_cookie_attribute = true
  name                       = "Pi-hole"
  options_preflight_bypass   = false
  policies                   = [{ id = var.cloudflare_access_policy }]
  same_site_cookie_attribute = "lax"
  session_duration           = "1h"
  type                       = "self_hosted"
  zone_id                    = var.cloudflare_zone
}

