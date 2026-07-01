variable "apex_domain" {
  description = "The site's apex domain (e.g. example.com) to host Grafana on."
  type        = string
}

variable "cloudflare_access_policy" {
  description = "The ID of the Cloudflare Access policy to apply to the Grafana application."
  type        = string
}

variable "cloudflare_idp" {
  description = "The ID of an Identity Provider configured in Cloudflare Zero Trust."
  type        = string
}

variable "cloudflare_team_name" {
  description = "The name of the Cloudflare Zero Trust team."
  type        = string
}

variable "cloudflare_zone" {
  description = "The Cloudflare Zone ID where the Grafana application will be created."
  type        = string
}
