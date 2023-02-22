output "pfx" {
  value       = random_password.pfx.result
  description = "The TLS certificate password."
  sensitive   = true
}

# terraform output -raw key
output "key" {
  value       = tls_private_key.key.private_key_pem
  description = "Private key in PEM format."
  sensitive   = true
}

# terraform output -raw cert
output "cert" {
  value = length(var.ca_crt_pem) > 0 ? (
    one(tls_self_signed_cert.ca[*].cert_pem)
    ) : (
    one(tls_locally_signed_cert.crt[*].cert_pem)
  )
  description = "Certificate in PEM format."
  sensitive   = false
}

output "key_vault_secret" {
  value       = one(azurerm_key_vault_certificate.pfx[*].versionless_secret_id)
  description = "Key Vault certificate ID."
  sensitive   = true
}


output "key_vault_certificate" {
  value       = one(azurerm_key_vault_certificate.pfx[*].versionless_id)
  description = "Key Vault certificate ID."
  sensitive   = false
}
