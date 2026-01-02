# KV namespace for .well-known static content
#
# Stores static files that need to be served with specific Content-Type headers.
# This approach works reliably with Worker Routes (unlike Worker Static Assets).

resource "cloudflare_workers_kv_namespace" "well_known" {
  account_id = "acd08a5a3f8cf8ffbbd67166a949bb96"
  title      = "well-known-content"
}

# Apple App Site Association (AASA) file
resource "cloudflare_workers_kv" "aasa" {
  account_id   = "acd08a5a3f8cf8ffbbd67166a949bb96"
  namespace_id = cloudflare_workers_kv_namespace.well_known.id
  key_name     = "/.well-known/apple-app-site-association"
  value        = file("${path.module}/workers/assets/.well-known/apple-app-site-association")
}

# atproto DID (Bluesky handle verification)
resource "cloudflare_workers_kv" "atproto_did" {
  account_id   = "acd08a5a3f8cf8ffbbd67166a949bb96"
  namespace_id = cloudflare_workers_kv_namespace.well_known.id
  key_name     = "/.well-known/atproto-did"
  value        = file("${path.module}/workers/assets/.well-known/atproto-did")
}
