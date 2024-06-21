output "pfx" {
  value       = random_password.pfx.result
  description = "The TLS certificate password."
  sensitive   = true
}

# terraform output -raw key.private_key_pem
output "key" {
  value       = tls_private_key.key
  description = "Private key."
  sensitive   = true
}

output "crt" {
  value = var.ca_crt_pem != null ? (
    tls_locally_signed_cert.crt[var.subject.common_name]
    ) : (
    tls_self_signed_cert.ca[var.subject.common_name]
  )
  description = "Certificate in PEM format."
  sensitive   = false
}

output "pkcs8" {
  value = trimspace(join("", [
    var.ca_crt_pem != null ? (
      tls_locally_signed_cert.crt[var.subject.common_name].cert_pem
      ) : (
      tls_self_signed_cert.ca[var.subject.common_name].cert_pem
    ),
    tls_private_key.key.private_key_pem_pkcs8,
  ]))
  description = "Private key and certificate in PKCS8 format."
  sensitive   = true
}
