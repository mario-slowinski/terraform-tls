variable "key_vault_id" {
  type        = string
  description = "The ID of the Key Vault where the Certificate should be created."
  default     = ""
}

variable "certificate_name" {
  type        = string
  description = "Specifies the name of the Key Vault Certificate."
  default     = ""
}

variable "key_properties" {
  type        = map(bool)
  description = "Map of key arguments."
  default = {
    exportable = true
    reuse_key  = true
  }
}

variable "lifetime_action" {
  type        = map(string)
  description = "Map of lifetime_action arguments."
  default = {
    action_type        = "EmailContacts"
    days_before_expiry = 14
  }
}
