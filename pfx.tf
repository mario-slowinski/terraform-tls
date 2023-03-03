resource "local_sensitive_file" "key" {
  content         = trimspace(tls_private_key.key.private_key_pem)
  filename        = "${path.root}/${var.certs}/${var.subject.common_name}.key"
  file_permission = "0600"

  depends_on = [
    tls_private_key.key,
  ]
}

resource "local_file" "crt" {
  content = length(var.ca_crt_pem) > 0 ? (
    trimspace(one(tls_locally_signed_cert.crt[*].cert_pem))
    ) : (
    trimspace(one(tls_self_signed_cert.ca[*].cert_pem))
  )
  filename        = "${path.root}/${var.certs}/${var.subject.common_name}.crt"
  file_permission = "0644"

  depends_on = [
    tls_self_signed_cert.ca,
    tls_locally_signed_cert.crt,
  ]
}

resource "null_resource" "pem2pfx" {
  triggers = {
    key_id         = local_sensitive_file.key.content
    certificate_id = local_file.crt.content
  }

  provisioner "local-exec" {
    command = "openssl pkcs12 -export -in ${local_file.crt.filename} -inkey ${local_sensitive_file.key.filename} -out ${path.root}/${var.certs}/${var.subject.common_name}.pfx -passout pass:${random_password.pfx.result}"
  }

  depends_on = [
    local_sensitive_file.key,
    local_file.crt,
    random_password.pfx,
  ]
}

data "local_file" "pfx" {
  filename = "${path.root}/${var.certs}/${var.subject.common_name}.pfx"

  depends_on = [
    null_resource.pem2pfx,
  ]
}
