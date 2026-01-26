variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account ID"
  default     = "acd08a5a3f8cf8ffbbd67166a949bb96"
}

variable "zone_id" {
  type    = string
  default = "ee4724648879ff94b352fe5587800062" # searle.dev
}

variable "zone_name" {
  type    = string
  default = "searle.dev"
}

variable "govision_app_zone_id" {
  type    = string
  default = "e7ac204c739a2847e78b10aed8f324fe" # govision.app
}

variable "govision_app_zone_name" {
  type    = string
  default = "govision.app"
}

variable "altilium_app_zone_id" {
  type    = string
  default = "141d321f65157c63db2f0b263a68feed" # altilium.app
}

variable "altilium_app_zone_name" {
  type    = string
  default = "altilium.app"
}

