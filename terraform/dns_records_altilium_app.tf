# DNS records for altilium.app
# GitHub Pages hosting configuration

# GitHub Pages A records (apex domain)
resource "cloudflare_dns_record" "altilium_app_a_1" {
  zone_id = var.altilium_app_zone_id
  name    = "@"
  type    = "A"
  content = "185.199.108.153"
  ttl     = 1
  proxied = true
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "altilium_app_a_2" {
  zone_id = var.altilium_app_zone_id
  name    = "@"
  type    = "A"
  content = "185.199.109.153"
  ttl     = 1
  proxied = true
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "altilium_app_a_3" {
  zone_id = var.altilium_app_zone_id
  name    = "@"
  type    = "A"
  content = "185.199.110.153"
  ttl     = 1
  proxied = true
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "altilium_app_a_4" {
  zone_id = var.altilium_app_zone_id
  name    = "@"
  type    = "A"
  content = "185.199.111.153"
  ttl     = 1
  proxied = true
  lifecycle {
    prevent_destroy = true
  }
}

# www subdomain -> apex
resource "cloudflare_dns_record" "altilium_app_www" {
  zone_id = var.altilium_app_zone_id
  name    = "www"
  type    = "CNAME"
  content = "altilium.app"
  ttl     = 1
  proxied = true
  lifecycle {
    prevent_destroy = true
  }
}
