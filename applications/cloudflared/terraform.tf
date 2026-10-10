terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.6.0"
    }
  }
}
