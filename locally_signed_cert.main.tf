resource "tls_cert_request" "csr" {
  # ca_crt_pem set => creating TLS cert => use locally_signed_cert
  for_each = { for subject in [var.subject] : subject.common_name => subject if var.ca_crt_pem != null }

  private_key_pem = tls_private_key.key.private_key_pem
  subject {
    common_name         = each.value.common_name
    country             = each.value.country
    locality            = each.value.locality
    organization        = each.value.organization
    organizational_unit = each.value.organizational_unit
    postal_code         = each.value.postal_code
    province            = each.value.province
    serial_number       = each.value.serial_number
    street_address      = each.value.street_address
  }
  dns_names = var.dns_names

  depends_on = [
    tls_private_key.key,
  ]
}

resource "tls_locally_signed_cert" "crt" {
  # ca_crt_pem set => creating TLS cert => use locally_signed_cert
  for_each = { for subject in [var.subject] : subject.common_name => subject if var.ca_crt_pem != null }

  ca_private_key_pem    = trimspace(var.ca_key_pem)
  ca_cert_pem           = trimspace(var.ca_crt_pem)
  cert_request_pem      = tls_cert_request.csr[var.subject.common_name].cert_request_pem
  validity_period_hours = var.validity_period_days * 24
  allowed_uses          = var.allowed_uses
  is_ca_certificate     = var.is_ca_certificate

  depends_on = [
    tls_cert_request.csr,
  ]
}
