output "instance_public_ip" {
  description = "O endereço IP público da instância criada."
  value       = oci_core_instance.minha_instancia.public_ip
}

output "instance_url" {
  description = "URL para acessar a aplicação na instância."
  value       = "http://www.${var.domain_name}"
}