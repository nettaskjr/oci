# Busca os domínios de disponibilidade na região
data "oci_identity_availability_domains" "ad" {
  compartment_id = var.tenancy_ocid
}

# Busca a imagem mais recente do Ubuntu 22.04 (LTS) compatível com a shape
data "oci_core_images" "latest_ubuntu_image" {
  compartment_id           = var.tenancy_ocid # Imagens públicas da Oracle geralmente residem no compartimento raiz (tenancy).
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04" # Você pode ajustar a versão majoritária desejada
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# Cria a instância de computação
resource "oci_core_instance" "minha_instancia" {
  availability_domain = data.oci_identity_availability_domains.ad.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_display_name
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet_publica.id
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.latest_ubuntu_image.images[0].id
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
    user_data           = base64encode(file("${path.module}/cloud-init.sh"))
  }
}