variable "name" {
  description = "Network name prefix."
  type        = string
}

variable "attachable" {
  description = "Whether the Docker network should be attachable."
  type        = bool
  default     = false
}
