# Generated from inventory/searle.dev/20260101T202906Z — do not hand-edit

resource "cloudflare_dns_record" "record_3756d4f7f734056ac1009e674eecbda6" {
  zone_id = var.zone_id
  name    = "@"
  type    = "A"
  content = "185.199.109.153"
  ttl     = 1
  proxied = true
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_590866fa031d53720f124eb9617f4949" {
  zone_id = var.zone_id
  name    = "@"
  type    = "A"
  content = "185.199.108.153"
  ttl     = 1
  proxied = true
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_7ed3a3b25c5582b8a39d1d7eda6e15dd" {
  zone_id = var.zone_id
  name    = "@"
  type    = "A"
  content = "185.199.111.153"
  ttl     = 1
  proxied = true
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_9fd9116d849dcadcc5338848ca42f16d" {
  zone_id = var.zone_id
  name    = "@"
  type    = "A"
  content = "185.199.110.153"
  ttl     = 1
  proxied = true
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_08238491ef75d8de055648a639152d68" {
  zone_id = var.zone_id
  name    = "_domainconnect"
  type    = "CNAME"
  content = "_domainconnect.1and1.com"
  ttl     = 1
  proxied = false
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_ad14d1be2b57a710a7b1178232fa3054" {
  zone_id = var.zone_id
  name    = "fm1._domainkey"
  type    = "CNAME"
  content = "fm1.searle.dev.dkim.fmhosted.com"
  ttl     = 1
  proxied = false
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_df073047af2b39710b3147587dbfd46b" {
  zone_id = var.zone_id
  name    = "fm2._domainkey"
  type    = "CNAME"
  content = "fm2.searle.dev.dkim.fmhosted.com"
  ttl     = 1
  proxied = false
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_fc65103cd8ebf4b8575eb4dcdab8b38e" {
  zone_id = var.zone_id
  name    = "fm3._domainkey"
  type    = "CNAME"
  content = "fm3.searle.dev.dkim.fmhosted.com"
  ttl     = 1
  proxied = false
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_9911aaac2c97540a994fd05c460b35be" {
  zone_id = var.zone_id
  name    = "www"
  type    = "CNAME"
  content = "timsearle.github.io"
  ttl     = 1
  proxied = true
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_340938fb4464f72723b319a1f8c3e5f4" {
  zone_id  = var.zone_id
  name     = "@"
  type     = "MX"
  content  = "in1-smtp.messagingengine.com"
  ttl      = 1
  priority = 10
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_9a66ad1272524d755a80180efbe5c522" {
  zone_id  = var.zone_id
  name     = "@"
  type     = "MX"
  content  = "in2-smtp.messagingengine.com"
  ttl      = 1
  priority = 20
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_248ee8ed564a30720866bfa524332a22" {
  zone_id = var.zone_id
  name    = "@"
  type    = "NS"
  content = "ns1064.ui-dns.com"
  ttl     = 1
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_4965fa316050dcbd308fa464a7cc79a5" {
  zone_id = var.zone_id
  name    = "@"
  type    = "NS"
  content = "ns1072.ui-dns.de"
  ttl     = 1
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_54418e661f223185f2da9a7f18e114ba" {
  zone_id = var.zone_id
  name    = "@"
  type    = "NS"
  content = "ns1038.ui-dns.org"
  ttl     = 1
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_5d98180d12d167fbdac033b41d4c7127" {
  zone_id = var.zone_id
  name    = "@"
  type    = "NS"
  content = "ns1054.ui-dns.biz"
  ttl     = 1
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_57b761f5a335c770da9db68dde6f0b77" {
  zone_id = var.zone_id
  name    = "_dmarc"
  type    = "TXT"
  content = "\"v=DMARC1; p=none; rua=mailto:72c809d177a64dc185420e667fe85165@dmarc-reports.cloudflare.net\""
  ttl     = 1
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_999029c22059c401dc7903f75a38d81e" {
  zone_id = var.zone_id
  name    = "@"
  type    = "TXT"
  content = "\"v=spf1 include:spf.messagingengine.com ?all\""
  ttl     = 1
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_dns_record" "record_d0292f742c068ba926b9c3b99aef2121" {
  zone_id = var.zone_id
  name    = "@"
  type    = "TXT"
  content = "\"openai-domain-verification=dv-HKbilf33JN3wwBUEeIyISWGr\""
  ttl     = 1
  lifecycle {
    prevent_destroy = true
  }
}

