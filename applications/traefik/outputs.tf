output "proxy_service" {
  description = "The service address of the proxy that Cloudflared routes traffic through."
  value       = "https://proxy.${var.apex_domain}"
}

output "tunnel_configs" {
  description = "Cloudflare Tunnel configurations to be consumed by the cloudflared module. Schema matches that of an object in the ingress list of https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared_config."
  value = [
    {
      hostname = local.application_domain
      origin_request = {
        access = {
          aud_tag   = [cloudflare_zero_trust_access_application.this.aud]
          required  = true
          team_name = var.cloudflare_team_name
        }
      }
    },
  ]
}
