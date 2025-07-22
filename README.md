# 🚀 Provisionador de Instância Ubuntu na OCI com Terraform

![Terraform](https://img.shields.io/badge/Terraform-v1.2+-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Licença](https://img.shields.io/badge/license-MIT-green.svg?style=for-the-badge)
![Plataforma](https://img.shields.io/badge/Oracle%20Cloud-F80000?style=for-the-badge&logo=oracle&logoColor=white)

Este projeto utiliza o Terraform para provisionar uma infraestrutura de rede básica e uma instância de computação Ubuntu "Always Free" na Oracle Cloud Infrastructure (OCI).

A instância é configurada na inicialização usando um script `cloud-init` para automatizar a instalação de softwares e atualizações do sistema.

---

## 🏗️ Infraestrutura Criada

O script provisiona os seguintes recursos na OCI:

*   **Rede Virtual (VCN)**: Uma rede isolada para seus recursos (`10.0.0.0/16`).
*   **Subnet Pública**: Uma sub-rede dentro da VCN com acesso à internet (`10.0.1.0/24`).
*   **Internet Gateway**: Permite a comunicação entre a subnet e a internet.
*   **Tabela de Rotas**: Direciona o tráfego da subnet para o Internet Gateway.
*   **Lista de Segurança**: Atua como um firewall virtual, liberando as portas 22 (SSH), 80 (HTTP) e 443 (HTTPS).
*   **Instância de Computação**: Uma VM configurada com as especificações do "Always Free".
*   **Seleção Dinâmica de Imagem**: O Terraform busca automaticamente a **imagem mais recente do Ubuntu LTS** (22.04 por padrão) disponível na OCI, garantindo que sua instância seja criada com a versão mais atualizada.

Abaixo, uma representação visual da arquitetura:

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

```

---

## 🔧 Pré-requisitos

1.  **Conta na OCI**: Uma conta ativa na Oracle Cloud.
2.  **Terraform**: Instalado na sua máquina local.
3.  **Credenciais da API da OCI**: Você precisará do seu:
    *   Tenancy OCID
    *   User OCID
    *   Compartment OCID
    *   Fingerprint da chave API
    *   Caminho para a chave privada da API (`.pem`)
4.  **Par de Chaves SSH**: Uma chave SSH pública e privada para acessar a instância.

---

## 📂 Estrutura do Projeto

O projeto foi dividido em arquivos lógicos para facilitar a manutenção e a clareza.

```
.
├── main.tf                # Define a instância e o provedor OCI.
├── network.tf             # Define todos os recursos de rede (VCN, Subnet, etc.).
├── variables.tf           # Declaração de todas as variáveis do projeto.
├── terraform.tfvars       # (NÃO versionado) Valores das suas variáveis e segredos.
├── outputs.tf             # Saídas do projeto (ex: IP público da instância).
├── cloud-init.sh          # Script de inicialização da instância.
└── README.md              # Este arquivo de documentação.
```

---

## 🚀 Como Usar

1.  **Clone o repositório** (se aplicável) ou salve todos os arquivos na mesma pasta.

2.  **Preencha as variáveis**: Crie um arquivo chamado `terraform.tfvars` e preencha com suas credenciais da OCI e caminhos. **Nunca** adicione este arquivo ao controle de versão (Git).

    **Exemplo de `terraform.tfvars`:**
    ```hcl
    tenancy_ocid         = "ocid1.tenancy.oc1..xxxxxxxx"
    user_ocid            = "ocid1.user.oc1..xxxxxxxx"
    compartment_ocid     = "ocid1.compartment.oc1..xxxxxxxx"
    fingerprint          = "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
    region               = "us-ashburn-1"
    api_private_key_path = "~/.oci/oci_api_key.pem"
    ssh_public_key_path  = "~/.ssh/id_rsa.pub"
    ```
3.  **Inicialize o Terraform**: Este comando baixa o provedor da OCI.
    ```shell
    terraform init
    ```
4.  **Planeje a execução**: O Terraform mostrará quais recursos serão criados. É uma boa prática revisar o plano antes de aplicar.
    ```shell
    terraform plan
    ```
5.  **Aplique as mudanças**: Confirme com `yes` para criar a infraestrutura na OCI.
    ```shell
    terraform apply
    ```
    Ao final, o Terraform exibirá o IP público da instância na saída.

### 🔑 Acessando a Instância

Use sua chave SSH privada para se conectar ao servidor com o usuário `ubuntu`.
```shell
ssh -i ~/.ssh/id_rsa ubuntu@<IP_PUBLICO_DA_INSTANCIA>
```

---


### 🗑️ Destruindo a Infraestrutura

Para remover todos os recursos criados por este projeto e evitar custos, execute:
```shell
terraform destroy
```

---


## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir uma *issue* para relatar bugs ou sugerir melhorias. Se quiser adicionar funcionalidades, por favor, faça um *fork* do repositório e abra um *Pull Request*.

---

## 📜 Licença

Distribuído sob a licença MIT. Veja o arquivo `LICENSE` para mais informações.