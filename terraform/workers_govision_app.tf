# Worker to proxy govision.app -> searle.dev/govision
#
# This allows govision.app to serve content from the existing
# GitHub Pages site at searle.dev/govision while keeping the
# govision.app URL in the browser.

resource "cloudflare_workers_script" "govision_app_proxy" {
  account_id  = "acd08a5a3f8cf8ffbbd67166a949bb96"
  script_name = "govision-app-proxy"

  main_module  = "govision-app-proxy.js"
  content_file = "${path.module}/workers/govision-app-proxy.js"

  content_sha256 = filesha256("${path.module}/workers/govision-app-proxy.js")

  compatibility_date  = "2026-01-01"
  compatibility_flags = []
  usage_model         = "standard"
  logpush             = false

  observability = {
    enabled            = true
    head_sampling_rate = 1
    logs = {
      enabled            = true
      head_sampling_rate = 1
      invocation_logs    = true
      persist            = true
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Route all govision.app traffic through the proxy worker
resource "cloudflare_workers_route" "govision_app_root" {
  zone_id = var.govision_app_zone_id
  pattern = "govision.app/*"
  script  = cloudflare_workers_script.govision_app_proxy.script_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_workers_route" "govision_app_www" {
  zone_id = var.govision_app_zone_id
  pattern = "www.govision.app/*"
  script  = cloudflare_workers_script.govision_app_proxy.script_name

  lifecycle {
    prevent_destroy = true
  }
}
