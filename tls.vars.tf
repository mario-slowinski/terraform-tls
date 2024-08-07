variable "ca_key_pem" {
  type        = string
  description = "Certificate data of the Certificate Authority (CA) in PEM (RFC 1421) format."
  default     = null
}

variable "ca_crt_pem" {
  type        = string
  description = "Certificate data of the Certificate Authority (CA) in PEM (RFC 1421) format."
  default     = null
}

variable "allowed_uses" {
  type        = list(string)
  description = "List of key usages allowed for the issued certificate. Values are defined in RFC 5280 and combine flags defined by both Key Usages and Extended Key Usages."
  default = [
    "server_auth",
    "client_auth",
  ]
}

variable "dns_names" {
  type        = list(string)
  description = "List of DNS names for which a certificate is being requested."
  default     = []
}

variable "subject" {
  type = object({
    common_name         = string
    country             = string
    locality            = optional(string)
    organization        = string
    organizational_unit = optional(string)
    postal_code         = optional(string)
    province            = optional(string)
    serial_number       = optional(string)
    street_address      = optional(list(string))
  })
  default = {
    common_name  = null
    country      = null
    organization = null
  }
}

variable "validity_period_days" {
  type        = number
  description = "Number of days, after initial issuing, that the certificate will remain valid for."
  default     = 730
}

variable "is_ca_certificate" {
  type        = bool
  description = "Whether it is a CA certificate."
}

variable "early_renewal_hours" {
  type        = number
  description = "The resource will consider the certificate to have expired the given number of hours before its actual expiry time."
  default     = 120
}
