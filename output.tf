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

# terraform output -raw crt
output "crt" {
  value = length(var.ca_crt_pem) > 0 ? (
    one(tls_locally_signed_cert.crt[*].cert_pem)
    ) : (
    one(tls_self_signed_cert.ca[*].cert_pem)
  )
  description = "Certificate in PEM format."
  sensitive   = false
}

output "key_vault_secret_id" {
  value       = one(azurerm_key_vault_certificate.pfx[*].secret_id)
  description = "Key Vault certificate ID."
  sensitive   = true
}


output "key_vault_certificate_id" {
  value       = one(azurerm_key_vault_certificate.pfx[*].id)
  description = "Key Vault certificate ID."
  sensitive   = false
}
