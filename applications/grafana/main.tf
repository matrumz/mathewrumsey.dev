resource "cloudflare_zero_trust_access_application" "alloy" {
  allowed_idps              = [var.cloudflare_idp]
  app_launcher_visible      = false
  auto_redirect_to_identity = true
  destinations = [{
    type = "public"
    uri  = local.alloy_domain
  }]
  domain                     = local.alloy_domain
  enable_binding_cookie      = true
  http_only_cookie_attribute = true
  name                       = "Alloy"
  options_preflight_bypass   = false
  policies                   = [{ id = var.cloudflare_access_policy }]
  same_site_cookie_attribute = "lax"
  session_duration           = "1h"
  type                       = "self_hosted"
  zone_id                    = var.cloudflare_zone
}

moved {
  from = cloudflare_zero_trust_access_application.this
  to   = cloudflare_zero_trust_access_application.grafana
}
resource "cloudflare_zero_trust_access_application" "grafana" {
  allowed_idps              = [var.cloudflare_idp]
  app_launcher_visible      = true
  auto_redirect_to_identity = true
  destinations = [{
    type = "public"
    uri  = local.grafana_domain
  }]
  domain                     = local.grafana_domain
  enable_binding_cookie      = true
  http_only_cookie_attribute = true
  name                       = "Grafana"
  options_preflight_bypass   = false
  policies                   = [{ id = var.cloudflare_access_policy }]
  same_site_cookie_attribute = "lax"
  session_duration           = "1h"
  type                       = "self_hosted"
  zone_id                    = var.cloudflare_zone
}

resource "cloudflare_zero_trust_access_application" "prometheus" {
  allowed_idps              = [var.cloudflare_idp]
  app_launcher_visible      = false
  auto_redirect_to_identity = true
  destinations = [{
    type = "public"
    uri  = local.prometheus_domain
  }]
  domain                     = local.prometheus_domain
  enable_binding_cookie      = true
  http_only_cookie_attribute = true
  name                       = "Prometheus"
  options_preflight_bypass   = false
  policies                   = [{ id = var.cloudflare_access_policy }]
  same_site_cookie_attribute = "lax"
  session_duration           = "1h"
  type                       = "self_hosted"
  zone_id                    = var.cloudflare_zone
}
