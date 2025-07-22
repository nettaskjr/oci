output "instance_public_ip" {
  description = "O endereço IP público da instância criada."
  value       = oci_core_instance.minha_instancia.public_ip
}