output "tunnel_configs" {
  description = "Cloudflare Tunnel configurations to be consumed by the cloudflared module. Schema matches that of an object in the ingress list of https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared_config."
  value = [
    {
      hostname = local.alloy_domain
      origin_request = {
        access = {
          aud_tag   = [cloudflare_zero_trust_access_application.alloy.aud]
          required  = true
          team_name = var.cloudflare_team_name
        }
      }
    },
    {
      hostname = local.grafana_domain
      origin_request = {
        access = {
          aud_tag   = [cloudflare_zero_trust_access_application.grafana.aud]
          required  = true
          team_name = var.cloudflare_team_name
        }
      }
    },
    {
      hostname = local.prometheus_domain
      origin_request = {
        access = {
          aud_tag   = [cloudflare_zero_trust_access_application.prometheus.aud]
          required  = true
          team_name = var.cloudflare_team_name
        }
      }
    }
  ]
}
