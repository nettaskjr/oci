# Variáveis locais para centralizar e facilitar a manutenção das configurações de rede.
locals {
  vcn_cidr_block      = "10.0.0.0/16"
  subnet_cidr_block   = "10.0.1.0/24"
  all_ips_cidr_block  = "0.0.0.0/0"
  ingress_ports = { for port in [22, 80, 443] : port => "Permite tráfego na porta ${port}" }
}

# Rede Virtual (VCN)
resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_ocid
  cidr_block     = local.vcn_cidr_block
  display_name   = "vcn-principal"
  dns_label      = "vcn"
}

# Internet Gateway
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "igw-principal"
}

# Tabela de Rotas para a subnet pública
resource "oci_core_route_table" "rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "rt-publica"

  route_rules {
    destination       = local.all_ips_cidr_block
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

# Subnet Pública
resource "oci_core_subnet" "subnet_publica" {
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.vcn.id
  cidr_block        = local.subnet_cidr_block
  display_name      = "subnet-publica"
  dns_label         = "publica"
  route_table_id    = oci_core_route_table.rt.id
  security_list_ids = [oci_core_security_list.sl.id]
}

# Lista de Segurança para a subnet pública
resource "oci_core_security_list" "sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "sl-publica"

  egress_security_rules {
    protocol    = "all"
    destination = local.all_ips_cidr_block
  }

  # Cria dinamicamente as regras de entrada para cada porta definida no local.ingress_ports
  dynamic "ingress_security_rules" {
    for_each = local.ingress_ports
    content {
      protocol    = "6" # TCP
      source      = local.all_ips_cidr_block
      description = ingress_security_rules.value
      tcp_options {
        min = ingress_security_rules.key
        max = ingress_security_rules.key
      }
    }
  }
}