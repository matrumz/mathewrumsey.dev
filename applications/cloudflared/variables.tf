variable "application_configs" {
  description = "Routing configuration for exposed applications. Schema matches that of an object in the ingress list of https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared_config."
  type        = list(any)
  default     = []
}

variable "catch_all_config" {
  description = "Optional catch-all routing configuration for requests that don't match any application-specific rules. Schema matches that of an object in the ingress list of https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared_config."
  type        = map(any)
  default = {
    service = "http_status:404"
  }
}

variable "cloudflare_zone" {
  description = "The Cloudflare Zone where the Cloudflare Tunnel will be created."
  type = object({
    id = string
    account = object({
      id = string
    })
  })
}

variable "domains" {
  description = "List of domains served by the Cloudflare Tunnel. The first domain should be the primary apex domain."
  type        = list(string)
}

variable "proxy_service" {
  description = "The service address of the proxy that Cloudflared routes traffic through. This should be set to the output of the Traefik module, if using Traefik as the proxy."
  type        = string
}
