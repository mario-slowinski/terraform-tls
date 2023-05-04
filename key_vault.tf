resource "azurerm_key_vault_certificate" "pfx" {
  count = length(var.key_vault_id) > 0 ? 1 : 0

  name         = coalesce(var.certificate_name, replace(var.subject.common_name, "/\\.\\w+/", ""))
  key_vault_id = var.key_vault_id

  certificate {
    contents = filebase64("${path.root}/files/${var.subject.common_name}.pfx")
    password = random_password.pfx.result
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }
    key_properties {
      exportable = var.key_properties.exportable
      key_type   = var.key.algorithm
      key_size   = var.key.rsa_bits
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
      content_type = "application/x-pkcs12"
    }
  }

  tags = length(var.tags) > 0 ? (
    var.tags
    ) : (
    { for tag in local.tags : tag.key => tag.value }
  )
  depends_on = [
    null_resource.pem2pfx,
  ]
}
