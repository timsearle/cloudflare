# Apple App Site Association (AASA) Worker + routes
#
# This adopts the existing Cloudflare Worker `empty-haze-02db` and the two
# routes that serve `/.well-known/apple-app-site-association` with the correct
# content-type.
#
# IMPORTANT:
# - This PR is intended to be a no-op adoption (imports only, no changes).
# - Your Cloudflare API token must include Workers script permissions.
#   If the plan fails with `Authentication error` on workers/scripts,
#   update the token scopes to include:
#     * Account -> Workers Scripts: Read + Edit
#     * Zone    -> Workers Routes:  Read + Edit

import {
  to = cloudflare_workers_script.aasa
  id = "acd08a5a3f8cf8ffbbd67166a949bb96/empty-haze-02db"
}

import {
  to = cloudflare_workers_route.aasa_wildcard
  id = "ee4724648879ff94b352fe5587800062/036762556b394f6391ed3e799ffbbedd"
}

import {
  to = cloudflare_workers_route.aasa_root
  id = "ee4724648879ff94b352fe5587800062/6a9e06e85ad54c66aeae7177f199f014"
}

resource "cloudflare_workers_script" "aasa" {
  account_id  = var.account_id
  script_name = "empty-haze-02db"

  # Placeholder until we can safely fetch the exact script content via API.
  # We ignore changes to avoid unintended updates during adoption.
  content = file("${path.module}/workers/empty-haze-02db.js")

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [content]
  }
}

resource "cloudflare_workers_route" "aasa_wildcard" {
  zone_id = var.zone_id
  pattern = "*.${var.zone_name}/.well-known/apple-app-site-association"
  script  = cloudflare_workers_script.aasa.script_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_workers_route" "aasa_root" {
  zone_id = var.zone_id
  pattern = "${var.zone_name}/.well-known/apple-app-site-association"
  script  = cloudflare_workers_script.aasa.script_name

  lifecycle {
    prevent_destroy = true
  }
}
