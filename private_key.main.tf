resource "tls_private_key" "key" {
  algorithm   = var.key.algorithm
  ecdsa_curve = var.key.ecdsa_curve
  rsa_bits    = tonumber(var.key.rsa_bits)
}
