resource "local_sensitive_file" "token" {
  filename = "${path.module}/secrets/token.txt"
  content  = data.cloudflare_zero_trust_tunnel_cloudflared_token.this.token
}
