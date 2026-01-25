# Worker to proxy altilium.app -> searle.dev/altilium
#
# This allows altilium.app to serve content from the existing
# GitHub Pages site at searle.dev/altilium while keeping the
# altilium.app URL in the browser.

resource "cloudflare_workers_script" "altilium_app_proxy" {
  account_id  = "acd08a5a3f8cf8ffbbd67166a949bb96"
  script_name = "altilium-app-proxy"

  main_module  = "altilium-app-proxy.js"
  content_file = "${path.module}/workers/altilium-app-proxy.js"

  content_sha256 = filesha256("${path.module}/workers/altilium-app-proxy.js")

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

# Route all altilium.app traffic through the proxy worker
resource "cloudflare_workers_route" "altilium_app_root" {
  zone_id = var.altilium_app_zone_id
  pattern = "altilium.app/*"
  script  = cloudflare_workers_script.altilium_app_proxy.script_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_workers_route" "altilium_app_www" {
  zone_id = var.altilium_app_zone_id
  pattern = "www.altilium.app/*"
  script  = cloudflare_workers_script.altilium_app_proxy.script_name

  lifecycle {
    prevent_destroy = true
  }
}
