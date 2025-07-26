output "instance_public_ip" {
  description = "O endereço IP público da instância criada."
  value       = oci_core_instance.minha_instancia.public_ip
}

output "instance_url" {
  description = "URL para acessar a aplicação na instância."
  value       = "http://www.${var.domain_name}"
}

output "instance_ssh" {
  description = "Comando para acessar a instancia via SSH."
  value       = "ssh ubuntu@${oci_core_instance.minha_instancia.public_ip}"
}

# Caso queira adicionar um registro DNS no Cloudflare para acessar ssh pelo dominio, você pode seguir as instruções abaixo:

# Acesse o painel de controle do seu domínio no Cloudflare.

# Navegue até a seção "DNS".

# Clique em "Adicionar registro" e crie um novo registro do tipo "A".

# No campo "Nome", insira um subdomínio de sua escolha (por exemplo, ssh, direct ou server).

# No campo "Endereço IPv4", insira o endereço IP do seu servidor.

# Crucial: No ícone da nuvem, clique para que ele fique cinza ("DNS Only"). Isso desativa o proxy do Cloudflare para este subdomínio.

# Salve o registro.
