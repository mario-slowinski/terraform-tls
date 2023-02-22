resource "local_sensitive_file" "key" {
  content  = trimspace(tls_private_key.key.private_key_pem)
  filename = "${path.root}/files/key.pem"

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
  filename = "${path.root}/files/crt.pem"

  depends_on = [
    tls_self_signed_cert.ca,
    tls_locally_signed_cert.crt,
  ]
}

resource "null_resource" "pem2pfx" {
  triggers = {
    key_id         = local_sensitive_file.key.id
    certificate_id = local_file.crt.id
  }

  provisioner "local-exec" {
    command = "openssl pkcs12 -export -in ${local_file.crt.filename} -inkey ${local_sensitive_file.key.filename} -out ${path.root}/files/${var.subject.common_name}.pfx -passout pass:${random_password.pfx.result}"
  }
}

data "local_file" "pfx" {
  filename = "${path.root}/files/${var.subject.common_name}.pfx"

  depends_on = [
    null_resource.pem2pfx,
  ]
}
