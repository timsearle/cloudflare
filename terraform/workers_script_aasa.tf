# Adopt the existing Worker script used for AASA responses.
#
# This PR is import-only and intentionally avoids any in-place updates.

import {
  to = cloudflare_workers_script.aasa
  id = "acd08a5a3f8cf8ffbbd67166a949bb96/empty-haze-02db"
}

resource "cloudflare_workers_script" "aasa" {
  account_id  = "acd08a5a3f8cf8ffbbd67166a949bb96"
  script_name = "empty-haze-02db"

  content  = file("${path.module}/workers/empty-haze-02db.js")
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
    ignore_changes  = all
  }
}
