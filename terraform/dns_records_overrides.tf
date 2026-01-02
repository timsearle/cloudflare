# Hand-authored DNS records / overrides.
#
# Keep generated records in dns_records.tf (regenerate from Cloudflare only if needed).

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
