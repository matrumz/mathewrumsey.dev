terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.6.0"
    }
  }
  required_version = "~> 1.14"
}
