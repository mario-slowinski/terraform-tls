resource "azurerm_key_vault_certificate" "this" {
  count = length(var.key_vault_id) > 0 ? 1 : 0

  name         = coalesce(var.certificate_name, replace(var.subject.common_name, "/\\.\\w+/", ""))
  key_vault_id = var.key_vault_id

  certificate {
    contents = var.content_type == "application/x-pem-file" ? (
      join("", [
        one(tls_private_key.key[*].private_key_pem_pkcs8),
        one(tls_locally_signed_cert.crt[*].cert_pem),
        ]
      )
      ) : (
      filebase64("${path.root}/${var.certs}/${var.subject.common_name}.pfx")
    )
    password = random_password.pfx.result
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }
    key_properties {
      curve      = var.key_properties.curve
      exportable = var.key_properties.exportable
      key_type   = var.key_properties.key_type
      key_size   = var.key_properties.key_size
      reuse_key  = var.key_properties.reuse_key
    }
    lifetime_action {
      action {
        action_type = var.lifetime_action.action_type
      }
      trigger {
        days_before_expiry = var.lifetime_action.days_before_expiry
      }
    }
    secret_properties {
      content_type = var.content_type
    }
  }

  tags = merge(local.tags, var.tags)

  depends_on = [
    tls_private_key.key,
    tls_self_signed_cert.ca,
    tls_locally_signed_cert.crt,
    null_resource.pem2pfx,
  ]
}
