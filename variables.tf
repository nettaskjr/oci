variable "tenancy_ocid" {
  description = "OCID da sua Tenancy na OCI. Usado para encontrar as imagens públicas do sistema operacional."
  type        = string
}

variable "user_ocid" {
  description = "OCID do seu usuário na OCI."
  type        = string
}

variable "compartment_ocid" {
  description = "OCID do compartimento onde os recursos serão criados. Se não for especificado, o compartimento raiz será usado."
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint da sua chave de API."
  type        = string
}

variable "region" {
  description = "Região da OCI onde os recursos serão criados."
  type        = string
}

variable "ssh_public_key_path" {
  description = "Caminho para o arquivo da sua chave pública SSH."
  type        = string
}

variable "api_private_key_path" {
  description = "Caminho para o arquivo da sua chave privada da API."
  type        = string
}

variable "user_instance" {
  description = "Nome de usuário para a instância."
  type        = string
  default     = "ubuntu"
}

variable "instance_display_name" {
  description = "Nome de exibição para a instância."
  type        = string
  default     = "ubuntu-instance"
}

variable "instance_shape" {
  description = "Forma da instância. Considere VM.Standard.E2.1.Micro (Amd) ou VM.Standard.A1.Flex (Arm), caso queira usar a opção Always Free."
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "instance_ocpus" {
  description = "Número de OCPUs para a instância (relevante para formas Flex)."
  type        = number
  default     = 1
}

variable "instance_memory_in_gbs" {
  description = "Memória em GBs para a instância (relevante para formas Flex)."
  type        = number
  default     = 6
}

variable "boot_volume_size_in_gbs" {
  description = "Tamanho do volume de inicialização em GBs."
  type        = number
  default     = 100
}

variable "email" {
  description = "E-mail do usuário para notificações."
  type        = string
}

variable "domain_name" {
  description = "Nome de domínio principal que será apontado para a instância (ex: exemplo.com)."
  type        = string
}

variable "cloudflare_api_token" {
  description = "Token da API do Cloudflare com permissões para editar DNS."
  type        = string
}

variable "state_bucket_name" {
  description = "Nome do bucket no OCI Object Storage para armazenar o estado do Terraform. Deve ser um nome único."
  type        = string
}