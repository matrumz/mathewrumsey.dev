output "domain" {
  description = "Information on the managed domain"
  value = {
    name_servers = cloudflare_zone.this.name_servers
    dnssec = {
      key_tag        = cloudflare_zone_dnssec.this.key_tag
      data_algorithm = cloudflare_zone_dnssec.this.algorithm
      digest_type    = cloudflare_zone_dnssec.this.digest_type
      digest         = cloudflare_zone_dnssec.this.digest
    }
  }
}
