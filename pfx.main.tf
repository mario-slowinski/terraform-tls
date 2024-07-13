resource "local_sensitive_file" "key" {
  content         = tls_private_key.key.private_key_pem
  filename        = "${path.root}/${var.certs}/${var.subject.common_name}.key"
  file_permission = "0600"

  depends_on = [
    tls_private_key.key,
  ]
}

resource "local_file" "crt" {
  content = var.ca_crt_pem != null ? (
    tls_locally_signed_cert.crt[var.subject.common_name].cert_pem
    ) : (
    tls_self_signed_cert.ca[var.subject.common_name].cert_pem
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
    key = tls_private_key.key.id
    crt = tls_locally_signed_cert.crt[var.subject.common_name].id
    ca  = tls_self_signed_cert.ca[var.subject.common_name].id
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
