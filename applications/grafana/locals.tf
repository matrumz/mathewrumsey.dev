locals {
  alloy_domain      = "alloy.${var.apex_domain}"
  grafana_domain    = "grafana.${var.apex_domain}"
  prometheus_domain = "prometheus.${var.apex_domain}"
}
