# Este bloco configura o backend remoto do Terraform.
# Ele instrui o Terraform a armazenar o arquivo de estado (que rastreia seus recursos gerenciados)
# em um bucket do OCI Object Storage, em vez de localmente no arquivo terraform.tfstate.
# Usar um backend remoto é uma prática recomendada crucial para colaboração e segurança.
terraform {
  backend "oci" {
    # O nome do bucket que você definiu na variável state_bucket_name.
    bucket = var.state_bucket_name

    # O nome e caminho do arquivo de estado dentro do bucket.
    key = "infra/terraform.tfstate"
  }
}
