resource "tls_self_signed_cert" "ca" {
  # ca_cert_pem not set => creating CA cert => use self_signed_cert
  count = length(var.ca_crt_pem) > 0 ? 0 : 1

  private_key_pem = tls_private_key.key.private_key_pem

  subject {
    common_name         = var.subject.common_name
    country             = var.subject.country
    locality            = var.subject.locality
    organization        = var.subject.organization
    organizational_unit = var.subject.organizational_unit
    postal_code         = var.subject.postal_code
    province            = var.subject.province
    serial_number       = var.subject.serial_number
    street_address      = var.subject.street_address
  }
  validity_period_hours = var.validity_period_days * 24
  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
  is_ca_certificate = var.is_ca_certificate
}
