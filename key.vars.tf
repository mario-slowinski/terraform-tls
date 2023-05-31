variable "key" {
  type = object({
    algorithm   = string
    ecdsa_curve = optional(string)
    rsa_bits    = optional(string)
  })
  description = "TLS certificate private key attributes."
  default = {
    algorithm = "RSA"
    rsa_bits  = 4096
  }
}
