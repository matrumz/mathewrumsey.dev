provider "cloudflare" {
  # api_token = ""  ## Configured via environment variable: CLOUDFLARE_API_TOKEN
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
