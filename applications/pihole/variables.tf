variable "apex_domain" {
  description = "The site's apex domain (e.g. example.com) to host Pi-hole on."
  type        = string
}

variable "cloudflare_access_policy" {
  description = "The ID of the Cloudflare Access policy to apply to the Pi-hole application."
  type        = string
}

variable "cloudflare_zone" {
  description = "The Cloudflare Zone ID where the Pi-hole application will be created."
  type        = string
}
