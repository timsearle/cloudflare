# Apple App Site Association (AASA) worker routes
#
# This PR ONLY adopts the two existing Worker Routes that map
# `/.well-known/apple-app-site-association` to the already-existing Worker
# script `empty-haze-02db`.
#
# We intentionally do NOT adopt the worker script itself in this PR, because
# the Workers Scripts API permissions can vary and we want a strict no-op
# (no in-place updates) on the first merge.

import {
  to = cloudflare_workers_route.aasa_wildcard
  id = "ee4724648879ff94b352fe5587800062/036762556b394f6391ed3e799ffbbedd"
}

import {
  to = cloudflare_workers_route.aasa_root
  id = "ee4724648879ff94b352fe5587800062/6a9e06e85ad54c66aeae7177f199f014"
}

resource "cloudflare_workers_route" "aasa_wildcard" {
  zone_id = var.zone_id
  pattern = "*.${var.zone_name}/.well-known/apple-app-site-association*"
  script  = "empty-haze-02db"

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_workers_route" "aasa_root" {
  zone_id = var.zone_id
  pattern = "${var.zone_name}/.well-known/apple-app-site-association*"
  script  = "empty-haze-02db"

  lifecycle {
    prevent_destroy = true
  }
}

# atproto DID (Bluesky handle verification)
resource "cloudflare_workers_route" "atproto_wildcard" {
  zone_id = var.zone_id
  pattern = "*.${var.zone_name}/.well-known/atproto-did*"
  script  = "empty-haze-02db"

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_workers_route" "atproto_root" {
  zone_id = var.zone_id
  pattern = "${var.zone_name}/.well-known/atproto-did*"
  script  = "empty-haze-02db"

  lifecycle {
    prevent_destroy = true
  }
}
