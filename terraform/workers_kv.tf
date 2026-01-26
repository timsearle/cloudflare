# KV namespace for .well-known static content
#
# Stores static files that need to be served with specific Content-Type headers.
# This approach works reliably with Worker Routes (unlike Worker Static Assets).

resource "cloudflare_workers_kv_namespace" "well_known" {
  account_id = var.cloudflare_account_id
  title      = "well-known-content"
}

# Apple App Site Association (AASA) file
# Key uses simple name (no slashes) to avoid provider URL-encoding bug
resource "cloudflare_workers_kv" "aasa" {
  account_id   = var.cloudflare_account_id
  namespace_id = cloudflare_workers_kv_namespace.well_known.id
  key_name     = "apple-app-site-association"
  value        = file("${path.module}/workers/assets/.well-known/apple-app-site-association")
}

# atproto DID (Bluesky handle verification)
# Key uses simple name (no slashes) to avoid provider URL-encoding bug
resource "cloudflare_workers_kv" "atproto_did" {
  account_id   = var.cloudflare_account_id
  namespace_id = cloudflare_workers_kv_namespace.well_known.id
  key_name     = "atproto-did"
  value        = file("${path.module}/workers/assets/.well-known/atproto-did")
}
