# Manage the existing Worker script used for AASA responses.
#
# This step removes ignore_changes, so Terraform becomes the source of truth for the script content.
# The provider will show an in-place update (Cloudflare metadata changes) even when content is identical.

import {
  to = cloudflare_workers_script.aasa
  id = "acd08a5a3f8cf8ffbbd67166a949bb96/empty-haze-02db"
}

resource "cloudflare_workers_script" "aasa" {
  account_id  = "acd08a5a3f8cf8ffbbd67166a949bb96"
  script_name = "empty-haze-02db"

  # Module-syntax worker (supports `export default`).
  main_module  = "empty-haze-02db.js"
  content_file = "${path.module}/workers/empty-haze-02db.js"

  content_sha256 = filesha256("${path.module}/workers/empty-haze-02db.js")

  assets = {
    directory        = "${path.module}/workers/assets"
    binding          = "ASSETS"
    run_worker_first = true
  }

  bindings = []

  # Match the currently deployed script settings to keep this a no-op.
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
