resource "cloudflare_dns_record" "tunnel" {
  for_each = toset(concat(var.domains, [for app in var.application_configs : app.hostname if app.hostname != null]))
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.this.id}.cfargotunnel.com"
  name     = each.value
  proxied  = true
  ttl      = 1
  type     = "CNAME"
  zone_id  = var.cloudflare_zone.id
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "this" {
  account_id = var.cloudflare_zone.account.id
  name       = var.domains[0]
  config_src = "cloudflare"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "this" {
  account_id = var.cloudflare_zone.account.id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.this.id
  config = {
    ingress = concat(
      [for app_config in var.application_configs : merge(
        { service = var.proxy_service },
        app_config,
      )],
      [var.catch_all_config]
    )
  }
}

data "cloudflare_zero_trust_organization" "this" {
  zone_id = var.cloudflare_zone.id
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "this" {
  account_id = var.cloudflare_zone.account.id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.this.id
}
