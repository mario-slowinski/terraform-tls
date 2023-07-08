output "password" {
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
  value = length(var.ca_crt_pem) > 0 ? (
    one(tls_locally_signed_cert.crt[*])
    ) : (
    one(tls_self_signed_cert.ca[*])
  )
  description = "Certificate in PEM format."
  sensitive   = false
}
