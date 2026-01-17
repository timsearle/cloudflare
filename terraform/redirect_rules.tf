# Redirect rules for searle.dev subdomains

resource "cloudflare_ruleset" "redirects" {
  zone_id     = var.zone_id
  name        = "Redirect rules"
  description = "Subdomain redirects"
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"

  rules = [{
    action = "redirect"
    action_parameters = {
      from_value = {
        status_code = 301
        target_url = {
          expression = "concat(\"https://searle.dev/govision\", http.request.uri.path)"
        }
        preserve_query_string = true
      }
    }
    expression  = "(http.host eq \"govision.searle.dev\")"
    description = "Redirect govision.searle.dev to searle.dev/govision/"
    enabled     = true
  }]
}
