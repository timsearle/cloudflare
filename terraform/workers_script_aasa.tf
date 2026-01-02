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

  # Required by the provider, but ignored during adoption.
  content = file("${path.module}/workers/empty-haze-02db.js")

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}
