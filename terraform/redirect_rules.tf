# Redirect rules for searle.dev subdomains

resource "cloudflare_ruleset" "redirects" {
  zone_id     = var.zone_id
  name        = "Redirect rules"
  description = "Subdomain and path redirects"
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"

  rules = [
    {
      action = "redirect"
      action_parameters = {
        from_value = {
          status_code = 301
          target_url = {
            expression = "concat(\"https://govision.app\", http.request.uri.path)"
          }
          preserve_query_string = true
        }
      }
      expression  = "(http.host eq \"govision.searle.dev\")"
      description = "Redirect govision.searle.dev to govision.app"
      enabled     = true
    },
    {
      action = "redirect"
      action_parameters = {
        from_value = {
          status_code = 301
          target_url = {
            # Strip /govision prefix and redirect to govision.app
            expression = "concat(\"https://govision.app\", substring(http.request.uri.path, 9))"
          }
          preserve_query_string = true
        }
      }
      expression  = "(http.host eq \"searle.dev\" and starts_with(http.request.uri.path, \"/govision\"))"
      description = "Redirect searle.dev/govision/* to govision.app/*"
      enabled     = true
    }
  ]
}
