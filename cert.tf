resource "tls_cert_request" "csr" {
  # ca_crt_pem set => creating TLS cert => use locally_signed_cert
  count = length(var.ca_crt_pem) > 0 ? 1 : 0

  private_key_pem = tls_private_key.key.private_key_pem
  subject {
    common_name         = var.subject.common_name
    country             = var.subject.country
    locality            = try(var.subject.locality, "")
    organization        = var.subject.organization
    organizational_unit = try(var.subject.organizational_unit, "")
    postal_code         = try(var.subject.postal_code, "")
    province            = try(var.subject.province, "")
    serial_number       = try(var.subject.serial_number, "")
    street_address      = try(var.subject.street_address, "")
  }
  dns_names = var.dns_names

  depends_on = [
    tls_private_key.key,
  ]
}

resource "tls_locally_signed_cert" "crt" {
  # ca_crt_pem set => creating TLS cert => use locally_signed_cert
  count = length(var.ca_crt_pem) > 0 ? 1 : 0

  ca_private_key_pem    = var.ca_key_pem
  ca_cert_pem           = var.ca_crt_pem
  cert_request_pem      = one(tls_cert_request.csr[*].cert_request_pem)
  validity_period_hours = var.validity_period_days * 24
  allowed_uses          = var.allowed_uses

  depends_on = [
    tls_cert_request.csr,
  ]
}
