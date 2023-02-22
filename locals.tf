locals {
  # must be as separated lists because maps are automatically sorted
  tags = [
    for key, value in zipmap(var.tags_keys, var.tags_values) : {
      key   = key
      value = value
    } if value != ""
  ]

  names = compact(matchkeys(var.tags_values, var.tags_keys, var.names_keys))
}