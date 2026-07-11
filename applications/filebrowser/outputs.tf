output "tunnel_configs" {
  description = "Cloudflare Tunnel configurations to be consumed by the cloudflared module. Schema matches that of an object in the ingress list of https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared_config."
  value = [
    {
      hostname       = local.application_domain
      origin_request = {}
    },
  ]
}
