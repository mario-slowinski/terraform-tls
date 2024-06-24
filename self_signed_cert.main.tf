resource "tls_self_signed_cert" "ca" {
  # ca_cert_pem not set => creating CA cert => use self_signed_cert
  for_each = {
    for subject in [var.subject] :
    subject.common_name => subject
    if var.ca_crt_pem == null
  }

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
  validity_period_hours = var.validity_period_days * 24
  allowed_uses          = var.allowed_uses
  is_ca_certificate     = var.is_ca_certificate
  early_renewal_hours   = var.early_renewal_hours
}
