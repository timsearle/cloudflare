variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "zone_id" {
  type    = string
  default = "ee4724648879ff94b352fe5587800062" # searle.dev
}

variable "zone_name" {
  type    = string
  default = "searle.dev"
}

