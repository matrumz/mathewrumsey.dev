#region Cloud

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

#endregion

#region Local

locals {
  cloudflared_token_file = "/run/secrets/cloudflared-token"
}

module "docker_access_network" {
  source = "../../tf-modules/docker/networks/access"
  name   = "cloudflared"
}

resource "docker_container" "cloudflared" {
  name  = "cloudflared"
  image = docker_image.cloudflared.image_id
  ###
  command = ["tunnel", "run"]
  env = [for key, value in {
    TUNNEL_LOG_OUTPUT = "JSON"
    TUNNEL_TOKEN_FILE = local.cloudflared_token_file
    TZ                = "America/New_York"
  } : "${key}=${value}"]
  dynamic "labels" {
    for_each = {
      "dev.mathewrumsey.grafana.instance" = "default"
      "net.unraid.docker.icon"            = "https://raw.githubusercontent.com/aeleos/cloudflared/main/cloudflare-icon.png"
    }
    content {
      label = labels.key
      value = labels.value
    }
  }
  networks_advanced {
    name = module.docker_access_network.name
  }
  restart = "always"
  upload {
    file        = local.cloudflared_token_file
    content     = data.cloudflare_zero_trust_tunnel_cloudflared_token.this.token
    permissions = "0444"
  }
}

resource "docker_image" "cloudflared" {
  name          = "cloudflare/cloudflared:latest"
  keep_locally  = true
  pull_triggers = [timestamp()]
}

#endregion
