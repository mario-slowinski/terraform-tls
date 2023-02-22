variable "tags" {
  type        = map(string)
  description = "Map of tags to be used instead of the ones composed automatically."
  default     = {}
}

variable "tags_keys" {
  type        = list(string)
  description = "List of tags keys."
  default = [
    "environment",
    "vendor",
    "product",
    "instance",
  ]
}

variable "tags_values" {
  type        = list(string)
  description = "List of tags values."
  default = [
    "",
    "",
    "",
    "",
  ]
}

variable "names_keys" {
  type        = list(string)
  description = "List of tags keys to be used for name composition."
  default = [
    "environment",
    "vendor",
    "product",
    "instance",
  ]
}

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
