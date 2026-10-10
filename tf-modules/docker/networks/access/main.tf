resource "docker_network" "this" {
  name       = "${var.name}.access"
  attachable = var.attachable
  driver     = "bridge"
  internal   = false
}
