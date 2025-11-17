# Busca os detalhes da zona (domínio) no Cloudflare
data "cloudflare_zone" "domain_zone" {
  name = var.domain_name
}

# Cria um registro DNS tipo 'A' para o domínio raiz (@)
# apontando para o IP público da instância OCI.
resource "cloudflare_record" "root_domain" {
  zone_id = data.cloudflare_zone.domain_zone.id
  name    = "@"
  content = oci_core_instance.minha_instancia.public_ip
  type    = "A"
  ttl     = 1    # TTL Automático
  proxied = true # Habilita o proxy do Cloudflare (recomendado)
}

# Cria um registro DNS tipo 'A' para o subdomínio 'www'
# apontando para o IP público da instância OCI.
resource "cloudflare_record" "www_subdomain" {
  zone_id = data.cloudflare_zone.domain_zone.id
  name    = "www"
  content = oci_core_instance.minha_instancia.public_ip
  type    = "A"
  ttl     = 1    # TTL Automático
  proxied = true # Habilita o proxy do Cloudflare (recomendado)
}