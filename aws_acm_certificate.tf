resource "aws_acm_certificate" "cert" {
  count = length(var.name) > 0 ? 1 : 0

  private_key = trimspace(tls_private_key.key.private_key_pem)
  certificate_body = length(var.ca_crt_pem) > 0 ? (
    trimspace(one(tls_locally_signed_cert.crt[*].cert_pem))
    ) : (
    trimspace(one(tls_self_signed_cert.ca[*].cert_pem))
  )
  tags = merge(local.tags, var.tags, local.Name)

  depends_on = [
    tls_private_key.key,
    tls_self_signed_cert.ca,
    tls_locally_signed_cert.crt,
  ]
}
