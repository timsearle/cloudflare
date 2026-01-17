# Hand-authored DNS records / overrides.
#
# Keep generated records in dns_records.tf (regenerate from Cloudflare only if needed).

# GoVision landing page subdomain
# Points to GitHub Pages (same as www.searle.dev)
resource "cloudflare_dns_record" "govision_subdomain" {
  zone_id = var.zone_id
  name    = "govision"
  type    = "CNAME"
  content = "timsearle.github.io"
  ttl     = 1
  proxied = true

  lifecycle {
    prevent_destroy = true
  }
}

# Test record for validating PR plan/apply flow.
# resource "cloudflare_dns_record" "record_tf_test" {
#   zone_id = var.zone_id
#   name    = "@"
#   type    = "TXT"
#   content = "\"hello-from-terraform\""
#   ttl     = 1

#   lifecycle {
#     prevent_destroy = true
#   }
# }
