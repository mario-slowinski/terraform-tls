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
