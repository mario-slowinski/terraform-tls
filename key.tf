resource "tls_private_key" "key" {
  algorithm = var.key.algorithm
  rsa_bits  = tonumber(var.key.rsa_bits)
}
