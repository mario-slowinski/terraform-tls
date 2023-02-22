variable "key" {
  type        = map(string)
  description = "TLS certificate private key attributes."
  default = {
    algorithm = "RSA"
    rsa_bits  = 4096
  }
}
