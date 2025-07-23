# 🚀 Provisionador de Instância Ubuntu na OCI com Terraform

![Terraform](https://img.shields.io/badge/Terraform-v1.2+-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Licença](https://img.shields.io/badge/license-MIT-green.svg?style=for-the-badge)
![Plataforma](https://img.shields.io/badge/Oracle%20Cloud-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![Cloudflare](https://img.shields.io/badge/Cloudflare-API-orange?style=for-the-badge&logo=cloudflare)

Este projeto utiliza o Terraform para provisionar uma infraestrutura completa na Oracle Cloud Infrastructure (OCI), incluindo rede, instância Ubuntu Always Free, DNS automatizado via Cloudflare e armazenamento seguro do estado do Terraform em bucket OCI.

A instância é configurada na inicialização usando um script `cloud-init` para automatizar a instalação de softwares e atualizações do sistema.

---

## 🏗️ Infraestrutura Criada

O projeto provisiona os seguintes recursos:

*   **Rede Virtual (VCN)**: Rede isolada para os recursos (`10.0.0.0/16`).
*   **Subnet Pública**: Sub-rede com acesso à internet (`10.0.1.0/24`).
*   **Internet Gateway**: Permite comunicação da subnet com a internet.
*   **Tabela de Rotas**: Direciona o tráfego da subnet para o Internet Gateway.
*   **Lista de Segurança**: Firewall virtual liberando portas 22 (SSH), 80 (HTTP) e 443 (HTTPS).
*   **Instância de Computação Ubuntu**: VM Always Free, com seleção dinâmica da imagem mais recente do Ubuntu LTS (22.04).
*   **Configuração Automática via Cloud-Init**: Instalação de pacotes, Nginx e página de teste personalizada.
*   **Bucket de Object Storage**: Armazena o estado do Terraform de forma segura e versionada (backend remoto).
*   **Provisionamento DNS via Cloudflare**: Criação automática dos registros DNS tipo A para o domínio principal e subdomínio www, apontando para o IP público da instância.
*   **Outputs**: Exibe o IP público da instância e a URL de acesso ao serviço.

### Arquitetura Visual

```
          +---------------------+
          |      Internet       |
          +----------+----------+
                     |
          +----------v----------+
          |  Internet Gateway   |
          +----------+----------+
                     |
  +------------------+-------------------+
  |   VCN (10.0.0.0/16)                  |
  |                                      |
  |   +--------------------------------+ |
  |   | Subnet Pública (10.0.1.0/24)   | |
  |   |                                | |
  |   |  +-------------------------+   | |
  |   |  | Instância Ubuntu        |   | |
  |   |  | (IP Público)            |   | |
  |   |  +-------------------------+   | |
  |   |                                | |
  |   +--------------------------------+ |
  |                                      |
  +--------------------------------------+
                     |
          +----------v----------+
          |   Cloudflare DNS    |
          +--------------------+
```

---

## 🔧 Pré-requisitos

1.  **Conta na OCI**: Uma conta ativa na Oracle Cloud.
2.  **Conta Cloudflare**: Para gerenciar DNS do domínio.
3.  **Terraform**: Instalado na máquina local.
4.  **Credenciais da API da OCI**: Tenancy OCID, User OCID, Compartment OCID, Fingerprint, chave privada da API.
5.  **Par de Chaves SSH**: Para acesso à instância.
6.  **Token da API do Cloudflare**: Permissão para editar DNS.

---

## 📂 Estrutura do Projeto

O projeto está dividido em arquivos lógicos para facilitar manutenção e clareza:

```
.
├── backend.tf            # Configuração do backend remoto no OCI Object Storage.
├── main.tf               # Criação da instância e seleção dinâmica da imagem Ubuntu.
├── network.tf            # Recursos de rede (VCN, Subnet, Gateway, Segurança).
├── storage.tf            # Criação do bucket para o estado do Terraform.
├── dns.tf                # Provisionamento automático de registros DNS no Cloudflare.
├── providers.tf          # Configuração dos provedores OCI e Cloudflare.
├── variables.tf          # Declaração das variáveis do projeto.
├── terraform.tfvars      # (NÃO versionado) Valores das variáveis e segredos.
├── outputs.tf            # Saídas do projeto (IP público, URL).
├── cloud-init.sh         # Script de inicialização da instância.
└── README.md             # Este arquivo de documentação.
```

---

## 🚀 Como Usar

1.  **Clone o repositório** ou salve todos os arquivos na mesma pasta.

2.  **Preencha as variáveis**: Crie o arquivo `terraform.tfvars` com suas credenciais da OCI, Cloudflare e caminhos. **Nunca** adicione este arquivo ao controle de versão.

    **Exemplo de `terraform.tfvars`:**
    ```hcl
    tenancy_ocid         = "ocid1.tenancy.oc1..xxxxxxxx"
    user_ocid            = "ocid1.user.oc1..xxxxxxxx"
    compartment_ocid     = "ocid1.compartment.oc1..xxxxxxxx"
    fingerprint          = "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
    region               = "us-ashburn-1"
    api_private_key_path = "~/.oci/oci_api_key.pem"
    ssh_public_key_path  = "~/.ssh/id_rsa.pub"
    domain_name          = "seudominio.com"
    cloudflare_api_token = "seu_token_cloudflare"
    state_bucket_name    = "nome-unico-do-bucket"
    ```

3.  **Inicialize o Terraform**:
    ```shell
    terraform init
    ```

4.  **Planeje a execução**:
    ```shell
    terraform plan
    ```

5.  **Aplique as mudanças**:
    ```shell
    terraform apply
    ```
    Ao final, o Terraform exibirá o IP público da instância e a URL de acesso.

### 🔑 Acessando a Instância

Use sua chave SSH privada para se conectar ao servidor com o usuário `ubuntu`:
```shell
ssh -i ~/.ssh/id_rsa ubuntu@<IP_PUBLICO_DA_INSTANCIA>
```

### 🌐 Acessando via Domínio

O domínio principal e o subdomínio www serão automaticamente apontados para o IP público da instância via Cloudflare.

### 🗑️ Destruindo a Infraestrutura

Para remover todos os recursos criados e evitar custos:
```shell
terraform destroy
```

---

## 🤝 Contribuições

Contribuições são bem-vindas! Abra uma *issue* para bugs ou sugestões, ou faça um *fork* e envie um *Pull Request*.

---

## 📜 Licença

Distribuído sob a licença MIT. Veja o arquivo `LICENSE` para mais informações.