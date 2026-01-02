# Ensure correct Content-Type for extensionless .well-known assets.
#
# Cloudflare's static assets serving can omit Content-Type for extensionless files.
# These response header transforms guarantee the expected types.

resource "cloudflare_ruleset" "well_known_content_types" {
  zone_id = var.zone_id
  name    = "Well-known Content-Types"
  kind    = "zone"
  phase   = "http_response_headers_transform"

  rules = [
    {
      action      = "set_http_response_header"
      description = "Set Content-Type for AASA"
      enabled     = true
      expression  = "(http.request.uri.path eq \"/.well-known/apple-app-site-association\")"

      action_parameters = {
        headers = [
          {
            name      = "Content-Type"
            operation = "set"
            value     = "application/json; charset=utf-8"
          },
          {
            name      = "Content-Disposition"
            operation = "set"
            value     = "inline"
          },
        ]
      }
    },
    {
      action      = "set_http_response_header"
      description = "Set Content-Type for atproto DID"
      enabled     = true
      expression  = "(http.request.uri.path eq \"/.well-known/atproto-did\")"

      action_parameters = {
        headers = [
          {
            name      = "Content-Type"
            operation = "set"
            value     = "text/plain; charset=utf-8"
          },
          {
            name      = "Content-Disposition"
            operation = "set"
            value     = "inline"
          },
        ]
      }
    },
  ]
}
