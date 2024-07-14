locals {
  crt = var.ca_crt_pem != null ? (
    tls_locally_signed_cert.crt[var.subject.common_name]
    ) : (
    tls_self_signed_cert.ca[var.subject.common_name]
  )
}
